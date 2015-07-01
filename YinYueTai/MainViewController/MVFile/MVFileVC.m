//
//  MVFileVC.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-23.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "MVFileVC.h"
#import "MVmodel.h"

@interface MVFileVC ()
{
    // 没网时，增加的刷新手势
    UITapGestureRecognizer *_flushTap;
}

@end

@implementation MVFileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.MVArray = [NSMutableArray array];
        
        // 选中标题更改通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMVIndexChange) name:kMVSelectIndexChangeNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self isOline]) {
        [self loadData];
    }else
    {
        if (!_flushTap)
        {
            _flushTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [self.view addGestureRecognizer:_flushTap];
        }

    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_MV.png"];
    [self titleImageSet:navImg];
    
}

//没网时调用
- (void)tapAction{
    [super tapAction];
    if ([self isOline]) {
        [self loadData];

    }
}

- (void)initTitleView
{
    NSMutableArray *codeArr = [NSMutableArray arrayWithCapacity:self.ereasArray.count];
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:self.ereasArray.count];
    for (NSDictionary *dic in self.ereasArray)
    {
        NSString *codeString = [dic objectForKey:@"code"];
        [codeArr addObject:codeString];
        NSString *nameString = [dic objectForKey:@"name"];
        [nameArr addObject:nameString];
    }
    _titleTableView = [[TitleTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) style:UITableViewStylePlain];
    
    _titleTableView.dataList = nameArr;
    _titleTableView.sourceData = self.ereasArray;
    [self.view addSubview:_titleTableView];
    [_titleTableView reloadData];
}

- (void)initMvView
{
    if (!_mvTableView)
    {
        _mvTableView  = [[MVTableView alloc] initWithFrame:CGRectMake(0, _titleTableView.bottom, kScreenWidth, kScreenHeight - 50 - 49) style:UITableViewStylePlain];
        __block MVFileVC *this = self;
        _mvTableView.pullDownBlock = ^(){
            [this loadDown];
                    };
        
        _mvTableView.pullUpBlock = ^(){
            
            [this loadUp];

        };
        [self.view addSubview:_mvTableView];
        
        _mvTableView.backgroundColor = [UIColor clearColor];
        _mvTableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"horizontalLine"]];
        _mvTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    _mvTableView.showArray = _MVArray[_titleTableView.currentIndex];
    [_mvTableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
    
}

- (void)loadUp{
 

    
    [self loadMVData];
    
}
- (void)loadDown{
    [_mvTableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
//     [_mvTableView doneLoadingTableViewData];
}

- (void)loadData{
    
    self.view.userInteractionEnabled = NO;
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"];
    
    [jsonDict setObject:@"20" forKey:@"size"];
    [jsonDict setObject:@"0" forKey:@"offset"];
//    NSLog(@"%d", _ereasArray.count);
    if (!_ereasArray.count) {   //如果有数组了 就不在请求
    [DataService requestWithURL:@"http://mapi.yytcdn.com/video/get_mv_areas.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        self.ereasArray = result;
        if (self.ereasArray.count > 0)
        {   
            
            self.offsetArray = [NSMutableArray arrayWithCapacity:_ereasArray.count]; //存放offset
            
            
            for (int i = 0; i < _ereasArray.count; i++) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [_MVArray addObject:array];
                
                [_offsetArray addObject:[NSNumber numberWithInt:0]];
            }
            
            // 数据请求成功后再初始化视图
            [self initTitleView];
            
            
            // 加载完标题后，再加载对应的mv表视图
            [self loadMVData];
            self.view.userInteractionEnabled = YES;
        }
    }];
        
    }
    
        
    
    
}

- (void)loadMVData
{
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"];
   
    [jsonDict setObject:@"20" forKey:@"size"];
    [jsonDict setObject: [NSNumber numberWithInt:[_MVArray[_titleTableView.currentIndex] count]] forKey:@"offset"];
    _mvRequestParam = [self.ereasArray[_titleTableView.currentIndex] objectForKey:@"code"];
    //请求MV需要上面的 参数
    [jsonDict setObject:_mvRequestParam forKey:@"area"];
    [DataService requestWithURL:@"http://mapi.yytcdn.com/video/list.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        NSArray *array = [result objectForKey:@"videos"];
        NSMutableArray *addArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            MVmodel *model = [[MVmodel alloc] initWithDataDic:dic];
            [addArray addObject:model];
            [_mvTableView doneLoadingTableViewData];
        }
        
        [_MVArray[_titleTableView.currentIndex] addObjectsFromArray:addArray];
       
        if ([self.MVArray[_titleTableView.currentIndex] count] > 0)
        {
            // 同样的，先确定数据已请求下来了
            
            [self initMvView];
        }
        
    }];

}

- (void)selectMVIndexChange
{
    int zz = _titleTableView.currentIndex;
    int offset = [_MVArray[_titleTableView.currentIndex] count];
    if (offset > 0) {
        //大于0不加载
        _mvTableView.showArray = _MVArray[_titleTableView.currentIndex] ;
        [_mvTableView reloadData];
    }else{
       [self loadMVData]; 
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end