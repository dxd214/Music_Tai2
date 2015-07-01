//
//  VRankVC.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-23.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "VRankVC.h"
#import "MVmodel.h"


@interface VRankVC ()
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIPickerView *_pickerView;
    UIButton *_cancel;
    UIButton *_ensure;
}
@end

@implementation VRankVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // 选中标题更改通知
        self.MVArray = [NSArray array];
        _dataArr = [[NSMutableArray alloc] init];
        _yeahArr = [[NSArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectVRankIndexChange) name:kVRankSelectIndexChangeNotification object:nil];
        
    }
    return self;
}

- (void)selectVRankIndexChange
{
    [self loadMVData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self isOline]) {
        [self loadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_VList.png"];
    [self titleImageSet:navImg];
    
}



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
    _titleTableView.userInteractionEnabled = YES;
    _titleTableView.dataList = nameArr;
    _titleTableView.sourceData = self.ereasArray;
    [self.view addSubview:_titleTableView];
    [_titleTableView reloadData];
    
    // ----------- 打榜日期视图部分 -----------
    _publishDateView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleTableView.bottom, kScreenWidth, 38)];
    _publishDateView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"customBackground2"]];
    [self.view addSubview:_publishDateView];
    
    UIImageView *shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37, kScreenWidth, 5)];
    shadowImgView.image = [UIImage imageNamed:@"TitleViewShadow.png"];
    [_publishDateView addSubview:shadowImgView];

    
    
    UIImageView *lightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, kScreenWidth, 4)];
    lightImgView.image = [UIImage imageNamed:@"horizontalLine.png"];
    [_publishDateView addSubview:lightImgView];

    
    _leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(30, 0, 38, 38);
    [_leftButton setImage:[UIImage imageNamed:@"VList_Left.png"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"VList_Left_Sel.png"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_publishDateView addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(kScreenWidth - 68, 0, 38, 38);
    [_rightButton setImage:[UIImage imageNamed:@"VList_Right.png"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"VList_Right_Sel.png"] forState:UIControlStateHighlighted];
    [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_publishDateView addSubview:_rightButton];
    
    _publishDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _publishDateButton.frame = CGRectMake(70, 9, kScreenWidth - 140, 20);
    _publishDateButton.titleLabel.textColor = [UIColor whiteColor];
    _publishDateButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _publishDateButton.backgroundColor = [UIColor clearColor];
    _publishDateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_publishDateView addSubview:_publishDateButton];
    _publishDateView.userInteractionEnabled = YES;
    [_publishDateButton addTarget:self action:@selector(showSchedule) forControlEvents:UIControlEventTouchUpInside];
    
}

// 显示时间戳
- (void)showSchedule
{
    if (_pickerView) {
        _shadowView.hidden = NO;
    }
    [self loadDateData];
}

- (void)loadDateData
{
    NSMutableDictionary *jsonDict = [self loadJsonDict];

    [DataService requestWithURL:@"http://mapi.yytcdn.com/vchart/period.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        _yeahArr = result [@"years"];
        NSArray *arr = [result objectForKey:@"periods"];

        if (arr.count > 0)
        {
            for (int i = 0 ; i < _yeahArr.count; i++)
            {
                NSMutableArray *dataList = [NSMutableArray array];
                for (NSDictionary *dic in arr)
                {

                    PeriodsModel *model = [[PeriodsModel alloc] initWithDataDic:dic];
                    if ([model.year intValue] == [_yeahArr[i] intValue])
                    {
                        [dataList addObject:model];
                    }
                    
                }
                [_dataArr addObject:dataList];
                dataList = nil;
            }
            
        }
        if (self.dataArr.count > 0)
        {
            // 数据请求成功后再初始化视图
            [self initPickerView];
        }
        
    }];
    



}

- (void)initPickerView
{
    if (!_shadowView)
    {
        _shadowView = [[UIView alloc] initWithFrame: self.view.bounds];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.330];;
        [self.view addSubview:_shadowView];
    
    
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 200) / 2, kScreenWidth, 200)];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        [_shadowView addSubview:_pickerView];
        
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.frame = CGRectMake(20, _pickerView.bottom, 140, 30);
        [_cancel setImage:[UIImage imageNamed:@"AlertCancel.png"] forState:UIControlStateNormal];
        [_cancel setImage:[UIImage imageNamed:@"AlertCancel_Sel.png"] forState:UIControlStateHighlighted];
//        _cancel.backgroundColor = [UIColor whiteColor];
        [_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(cancelSelectDate) forControlEvents:UIControlEventTouchUpInside];
        [_shadowView addSubview:_cancel];
        
        _ensure = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensure.frame = CGRectMake(_cancel.right, _pickerView.bottom, 140, 30);
        [_ensure setImage:[UIImage imageNamed:@"AlertSure.png"] forState:UIControlStateNormal];
        [_ensure setImage:[UIImage imageNamed:@"AlertSure_Sel.png"] forState:UIControlStateHighlighted];
        [_ensure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_ensure addTarget:self action:@selector(ensureSelectDate) forControlEvents:UIControlEventTouchUpInside];
        [_shadowView addSubview:_ensure];
    }
    

}


- (void)cancelSelectDate
{
    _shadowView.hidden = YES;
}

- (void)ensureSelectDate
{
    if (self.periodsModel.dateCode) {
        NSMutableDictionary *jsonDict = [self loadJsonDict];
        //打榜日期
        [jsonDict setObject:[NSString stringWithFormat:@"%@", self.periodsModel.dateCode] forKey:@"datecode"];
        [self requestData:jsonDict];
    }
    _shadowView.hidden = YES;
}

- (void)initMvView
{
    if (!_mvTableView)
    {
        _mvTableView  = [[VRankTableView alloc] initWithFrame:CGRectMake(0, _publishDateView.bottom , kScreenWidth, kScreenHeight - 20 - 44 - 49 - 40 - 38) style:UITableViewStylePlain];
        _mvTableView.pagingEnabled = NO;
        [self.view addSubview:_mvTableView];
        
        _mvTableView.backgroundColor = [UIColor clearColor];
        _mvTableView.separatorColor = [UIColor clearColor];
        _mvTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    _mvTableView.showArr = _MVArray;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_mvTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_mvTableView reloadData];
}



- (void)loadData{
    self.view.userInteractionEnabled = NO;
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"]
    ;
    [jsonDict setObject:@"20" forKey:@"size"];
    [jsonDict setObject:@"0" forKey:@"offset"];
//    NSLog(@"%d", _ereasArray.count);
    if (!_ereasArray.count) {   //如果有数组了 就不在请求
        [DataService requestWithURL:@"http://mapi.yytcdn.com/vchart/get_vchart_areas.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
            self.ereasArray = result;
            if (self.ereasArray.count > 0)
            {
                // 数据请求成功后再初始化视图
                [self initTitleView];
                
                // 加载完标题后，再加载对应的mv表视图
                [self loadMVData];
                self.view.userInteractionEnabled = YES;
            }
        }];
        
    }
    [_pickerView selectRow:_lastSelectedRow inComponent:_lastSelectedComponent animated:YES];
}



- (void)loadMVData
{
    
    NSMutableDictionary *jsonDict = [self loadJsonDict];
    //    //打榜日期
    //    if (_rankModel.dateCode) {
    //        [jsonDict setObject:_rankModel.dateCode forKey:@"dateCode"];
    //    }
    //     [jsonDict setObject:@"20131007" forKey:@"dateCode"];
    [self requestData:jsonDict];
    
}

- (NSMutableDictionary *)loadJsonDict
{
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"]
    ;
    [jsonDict setObject:@"20" forKey:@"size"];
    [jsonDict setObject:@"0" forKey:@"offset"];
    _mvRequestParam = [self.ereasArray[_titleTableView.currentIndex] objectForKey:@"code"];
    //请求MV需要上面的 参数
    [jsonDict setObject:_mvRequestParam forKey:@"area"];
    return jsonDict;
}

- (void)requestData:(NSMutableDictionary *)jsonDict
{
    [DataService requestWithURL:@"http://mapi.yytcdn.com/vchart/show.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
//        NSLog(@"result:%@", result);
        NSArray *array = [result objectForKey:@"videos"];
        NSMutableArray *addArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            MVmodel *model = [[MVmodel alloc] initWithDataDic:dic];
            [addArray addObject:model];
        }
        
        self.MVArray = addArray;
        
        if (!_rankModel) {
            _rankModel = [[VRankModel alloc] initWithDataDic:result];
        }else
        {
            _rankModel = [[VRankModel alloc] initWithDataDic:result];
        }
        
//        _publishDateButton.titleLabel.text = [NSString stringWithFormat:@"%@年 %@期   ( %@ - %@ )", _rankModel.year, _rankModel.no, _rankModel.beginDateText, _rankModel.endDateText];
        [_publishDateButton setTitle:[NSString stringWithFormat:@"%@年 %@期   ( %@ - %@ )", _rankModel.year, _rankModel.no, _rankModel.beginDateText, _rankModel.endDateText] forState:UIControlStateNormal];
        
        // 判断按钮状态
        if ([_rankModel.nextDateCode intValue] != 0)
        {
            [_rightButton setEnabled:YES];
            _rightButton.alpha = 1.0;
        }else
        {
            [_rightButton setEnabled:NO];
            _rightButton.alpha = 0.5;
        }
        
        if (_rankModel.prevDateCode != 0)
        {
            [_leftButton setEnabled:YES];
            _leftButton.alpha = 1.0;
        }else
        {
            [_leftButton setEnabled:NO];
            _leftButton.alpha = 0.5;
        }
        
        if (self.MVArray.count > 0)
        {
            // 同样的，先确定数据已请求下来了
            [self initMvView];
        }
        
    }];
}

- (void)leftButtonAction
{
    NSMutableDictionary *jsonDict = [self loadJsonDict];
    //打榜日期
    [jsonDict setObject:_rankModel.prevDateCode forKey:@"datecode"];
    [self requestData:jsonDict];
}

- (void)rightButtonAction
{
    NSMutableDictionary *jsonDict = [self loadJsonDict];
    //打榜日期
    [jsonDict setObject:_rankModel.nextDateCode forKey:@"datecode"];
    [self requestData:jsonDict];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIPickerViewDataSource
//3.pickview有多少列
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//4.pickview每列有多少行
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _yeahArr.count;
    }else{
        //首选获取左边一列选中的row
        int leftSelectRow = [pickerView selectedRowInComponent:0];        
        return [_dataArr[leftSelectRow] count];
    }
}

#pragma mark - UIPickerViewDelegate
// returns width of column and height of row for each component.
//设置列宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 70;
    }else{
        return 250;
    }
}

//设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

//5.绘制每一行, 返回每一行的文字
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%@", _yeahArr[row]];
    }else{
        //首选获取左边一列选中的row
        int leftSelectRow = [pickerView selectedRowInComponent:0];
    
        PeriodsModel *model = _dataArr[leftSelectRow][row];
        return [NSString stringWithFormat:@"第%@期 (%@ - %@)", model.no, model.beginDateText, model.endDateText];
    }
}

//已经选中了某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        //刷新列
        [pickerView reloadComponent:1];
        
        //右边的列归0
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        
    }else{
        int leftSelectRow = [pickerView selectedRowInComponent:0];
        NSArray *dataList = _dataArr[leftSelectRow];
        self.periodsModel = dataList[row];
    }
    _lastSelectedComponent = component;
    _lastSelectedRow = row;
}

@end
