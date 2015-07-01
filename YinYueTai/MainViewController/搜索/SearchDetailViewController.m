//
//  SearchDetailViewController.m
//  YinYueTai
//
//  Created by Dick on 13-10-30.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "SearchCell.h"
#import "MVmodel.h"
#import "VlistModel.h"
#import "MVSearchName.h"
#import "PlayListSearchName.h"


@interface SearchDetailViewController ()

@end

@implementation SearchDetailViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _defaultSearchArr = [[NSArray alloc] init];
        _defaultMVSearchArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _textField.text = _keyWord;
    if (_textField.text.length > 0)
    {
        // 默认显示mv列表
        [self showListAction:_showMVButton];
 
        [_textField resignFirstResponder];
        
        [self saveSearchData];
        
        
    }
    
    NSArray *arr = [self checkAllName:@"MVSearchName"];
    if (arr.count > 0)
    {
        for (MVSearchName *search in arr)
        {
            [_defaultMVSearchArr addObject:search.searchName];
        }
    }

    NSLog(@"%@", _defaultMVSearchArr);
    
    
    _textField.delegate = self;
    
//    _defaultSearchArr = [@[@"少女时代", @"BIGBANG", @"MIC男团", @"EXO", @"F(X)", @"周杰伦", @"Taylor Swift", @"T-ARA", @"金贤重", @"陈奕迅", @"东方神起", @"SUPER JUNIOR", @"SHINEE", @"AKB48", @"艾薇儿", @"五月天", @"江南", @"刘德华", @"江南STYLE", @"2PM"]retain];
    if(_keyWord.length == 0)
    {
        if (_textField.text.length == 0)
        {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom + 15, kScreenWidth, kScreenHeight - 175) style:UITableViewStylePlain];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.backgroundColor = [UIColor clearColor];
            _tableView.separatorColor = [UIColor colorWithWhite:0.138 alpha:1.000];
            _tableView.showsVerticalScrollIndicator = NO;
            

            [self.view addSubview:_tableView];
        }else
        {
            [_tableView removeFromSuperview];
        }
        
    }
    
    

}

// 保存搜索记录
static BOOL isRepeat = NO;
- (void)saveSearchData
{
    if (_isMVList) {
        MVSearchName *mvSearch = [NSEntityDescription insertNewObjectForEntityForName:@"MVSearchName" inManagedObjectContext:self.managedObjectContext];
        
        
        NSArray *searchArr = [self checkAllName:@"MVSearchName"];
        
        // 是否存在重复
        for (MVSearchName *mvName in searchArr)
        {
            if ([mvName.searchName isEqualToString:_keyWord])
            {
                isRepeat = YES;
            }
        }
        mvSearch.searchName = _keyWord;
        
        if (!isRepeat)
        {
            [self.managedObjectContext insertObject:mvSearch];
            isRepeat = NO;
            [self.managedObjectContext save:NULL];
        }
        
    }else if (_isPlayList)
    {
        PlayListSearchName *playListSearch = [NSEntityDescription insertNewObjectForEntityForName:@"PlayListSearchName" inManagedObjectContext:self.managedObjectContext];
        NSArray *searchArr = [self checkAllName:@"PlayListSearchName"];
        for (PlayListSearchName *playListName in searchArr)
        {
            if ([playListName.searchName isEqualToString:playListSearch.searchName])
            {
                isRepeat = YES;
            }
        }
        playListSearch.searchName = _keyWord;
        
        if (!isRepeat)
        {
            [self.managedObjectContext insertObject:playListSearch];
            isRepeat = NO;
            [self.managedObjectContext save:NULL];
        }

    }else
    {
        
    }
    

}

- (NSArray *)checkAllName:(NSString *)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext]];
    NSArray *searchArr = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return searchArr;
}

- (void)loadMVData
{
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"];
    
    [jsonDict setObject:@"20" forKey:@"size"];
    [jsonDict setObject:@"0" forKey:@"offset"];
    
    //请求MV需要的参数
    if (_keyWord.length > 0) {
        [jsonDict setObject:_keyWord forKey:@"keyword"];
    }
    
    [DataService requestWithURL:@"http://mapi.yinyuetai.com/search/video.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        NSArray *array = [result objectForKey:@"videos"];
        NSMutableArray *addArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            MVmodel *model = [[MVmodel alloc] initWithDataDic:dic];
            [addArray addObject:model];
            [model release];
            [_mvTbView doneLoadingTableViewData];
        }
        
        self.mvData = addArray;
        if (self.mvData.count > 0)
        {
            // 同样的，先确定数据已请求下来了
            [self initMvView];
        }
        
    }];
    
}

- (void)initMvView
{
    if (!_mvTbView)
    {
        _mvTbView  = [[MVTableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom , kScreenWidth, kScreenHeight - _headerView.bottom - 12) style:UITableViewStylePlain];
        __block SearchDetailViewController *this = self;
        _mvTbView.pullDownBlock = ^(){
            [this loadDown];
        };
        
        _mvTbView.pullUpBlock = ^(){
            
            [this loadUp];
            
        };
        [self.view addSubview:_mvTbView];
        
        _mvTbView.backgroundColor = [UIColor clearColor];
        _mvTbView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"horizontalLine"]];
        _mvTbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else
    {
        _mvTbView.hidden = NO;
    }
    _mvTbView.showArray = self.mvData;
    [_mvTbView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
    
}

- (void)loadPlayListData
{
        
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"]
    ;
    
    [jsonDict setObject:@"20" forKey:@"size"];
    //请求playList需要的参数
    if (_keyWord.length > 0) {
        [jsonDict setObject:_keyWord forKey:@"keyword"];
    }
    NSString *offset = [NSString stringWithFormat:@"%i",_vlistArray.count];
    [jsonDict setObject:offset forKey:@"offset"];
    
    [DataService requestWithURL:@"http://mapi.yytcdn.com/playlist/list.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        NSArray *array = [result objectForKey:@"playLists"];
        NSMutableArray *dicArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            VlistModel *model = [[VlistModel alloc] initWithDataDic:dic];
            [dicArray addObject:model];
            [model release];
        }
        [_vlistArray addObjectsFromArray:dicArray];
        [self initPlayListView];
        
        
    }];
    
}

- (void)initPlayListView{
    
    if (!_vlistTavleView) {
    
        _vlistTavleView = [[CollectionTableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom -80, kScreenWidth, kScreenHeight  - 57 - _headerView.height) style:UITableViewStylePlain];
        _vlistTavleView.backgroundColor = [UIColor clearColor];
        _vlistTavleView.separatorColor = [UIColor clearColor];
        _vlistTavleView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_vlistTavleView];
        
        _vlistTavleView.pullDownBlock = ^(){
            
            [_vlistTavleView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
            
        };
        _vlistTavleView.pullUpBlock = ^(){
            [self loadPlayListData];
            
        };
        
    }else
    {
        _vlistTavleView.hidden = NO;
    }
    //解决  数据不够的的时候的
    _vlistTavleView.showArray = _vlistArray;
    if (_vlistTavleView.showArray.count == 0) {
        _vlistTavleView.hidden = YES;
    }else{
        _vlistTavleView.hidden = NO;
    }
    if (_vlistTavleView.showArray.count < 19) {
        _vlistTavleView.footViewl.hidden = YES;
        _vlistTavleView.refreshView.hidden = YES;
    }else{
        _vlistTavleView.footViewl.hidden = NO;
        _vlistTavleView.refreshView.hidden = NO;

    }
    [_vlistTavleView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
    
}

- (void)loadUp
{
    [self loadMVData];
}
- (void)loadDown{
    [_mvTbView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    //     [_mvTableView doneLoadingTableViewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_keyWord release];
    [_mvTbView release];
    [_mvData release];
    [_tableView release];
    [_textField release];
    [_vlistTavleView release];
    [_vlistArray release];
    [_headerView release];
    [_showMVButton release];
    [_showPlayListButton release];
    [_showArtistButton release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTextField:nil];
    [self setHeaderView:nil];
    [self setShowMVButton:nil];
    [self setShowPlayListButton:nil];
    [self setShowArtistButton:nil];
    [super viewDidUnload];
}



#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _defaultMVSearchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"kSearchCell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.text.text = _defaultMVSearchArr[indexPath.row];

    return cell;
}



- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textField.text = _defaultMVSearchArr[indexPath.row];
    _keyWord = _textField.text;
    
    [self saveSearchData];
    
    [self loadMVData];
    [_tableView removeFromSuperview];
//    _tableView.hidden = YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *clearRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearRecordButton.frame = CGRectMake(67, 1, 186, 38);
    [clearRecordButton setImage:[UIImage imageNamed:@"search_clearHistoryButton.png"] forState:UIControlStateNormal];
    [clearRecordButton addTarget:self action:@selector(clearHistoryRecord) forControlEvents:UIControlEventTouchUpInside];
    return clearRecordButton;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _keyWord = textField.text;
    if (_keyWord.length > 0)
    {
//        [_tableView removeFromSuperview];
//        [_tableView release];
//        _tableView = nil;
        _tableView.hidden = YES;
        [self loadMVData];
        
        // 保存搜索
        [self saveSearchData];
        
    }
    [_textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 取消按钮
- (IBAction)cancelSearchAction:(id)sender
{
    _textField.text = @"";
    _keyWord = @"";
    [_textField resignFirstResponder];
    if (_mvTbView) {
//        [_mvTbView removeFromSuperview];
//        [_mvTbView release];
//        _mvTbView = nil;
        _mvTbView.hidden = YES;
    }
    
    // 如果textField无内容 则重新创建一个默认出现的tableView 
    if (_textField.text.length == 0)
    {
//        if (!_tableView)
//        {
//            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom + 5, kScreenWidth, kScreenHeight - 105) style:UITableViewStylePlain];
//            _tableView.dataSource = self;
//            _tableView.delegate = self;
//            _tableView.backgroundColor = [UIColor clearColor];
//            _tableView.separatorColor = [UIColor colorWithWhite:0.138 alpha:1.000];
//            _tableView.showsVerticalScrollIndicator = NO;
//            [self.view addSubview:_tableView];
//            [_tableView reloadData];
//        }else
//        {
            _tableView.frame = CGRectMake(0, _headerView.bottom + 5, kScreenWidth, kScreenHeight - 175);
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.backgroundColor = [UIColor clearColor];
            _tableView.separatorColor = [UIColor colorWithWhite:0.138 alpha:1.000];
            _tableView.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_tableView];
            dispatch_async ( dispatch_get_main_queue (), ^{
                [self.tableView reloadData];
            });
        

//        }
//    }else
//    {
//        [_tableView removeFromSuperview];
    }

}

- (void)clearHistoryRecord
{
    NSArray *itemArray = [self checkAllName:@"MVSearchName"];
    for (MVSearchName *deleteItem in itemArray) {
        
        [self.managedObjectContext deleteObject:deleteItem];
        [self.managedObjectContext save:NULL];
    }
    [_defaultMVSearchArr removeAllObjects];
    [_tableView reloadData];
}

- (IBAction)showListAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 400:
            _isArtistList = NO;
            _isPlayList = NO;
            _isMVList = YES;
            [_showArtistButton setSelected:_isArtistList];
            [_showPlayListButton setSelected:_isPlayList];
            _showMVButton.selected = _isMVList;
            
            if (_vlistTavleView)
            {
//                [_vlistTavleView removeFromSuperview];
                _vlistTavleView.hidden = YES;
            }
            [self loadMVData];
            break;
        case 401:
            
            _isArtistList = NO;
            _isPlayList = YES;
            _isMVList = NO;
            [_showArtistButton setSelected:_isArtistList];
            [_showPlayListButton setSelected:_isPlayList];
            _showMVButton.selected = _isMVList;
            
            if (_mvTbView)
            {
//                [_mvTbView removeFromSuperview];
                _mvTbView.hidden = YES;
            }
            [self loadPlayListData];
            break;
        default:
            
            _isArtistList = YES;
            _isPlayList = NO;
            _isMVList = NO;
            [_showArtistButton setSelected:_isArtistList];
            [_showPlayListButton setSelected:_isPlayList];
            _showMVButton.selected = _isMVList;

            break;
    }
    
    
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSString *name = @"SearchName";

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];

    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SearchName.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
