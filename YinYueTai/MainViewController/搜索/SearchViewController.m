//
//  SearchViewController.m
//  YinYueTai
//
//  Created by Dick on 13-10-29.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "SearchViewController.h"
#import "LDButton.h"
#import "SearchDetailViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _hotSearchArr = [[NSArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_hotSearchArr release];
    [_sumSizeArr release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_Search.png"];
    [self titleImageSet:navImg];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self isOline]) {
        [self requestData];
    }else
    {
        return;
    }
}

- (void)requestData
{
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"];
    
    [jsonDict setObject:@"20" forKey:@"size"];
    [jsonDict setObject:@"0" forKey:@"offset"];
    [DataService requestWithURL:@"http://mapi.yytcdn.com/search/top_keyword.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        _hotSearchArr = [result retain];
        if (_hotSearchArr.count > 0)
        {
            [self initViews];
        }
    }];

}

- (void)initViews
{
    // 背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"标签背景.png"]];
    [self.view addSubview:backgroundView];
    [backgroundView release];
    UIImageView *shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, backgroundView.bottom - 1, kScreenWidth, 5)];
    shadowImgView.image = [UIImage imageNamed:@"TitleViewShadow.png"];
    [backgroundView addSubview:shadowImgView];
    [shadowImgView release];
    
    // 搜索按钮
    UIButton *searchInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchInputButton.frame = CGRectMake((kScreenWidth - 225) / 2 , 7, 225, 34);
    [searchInputButton setImage:[UIImage imageNamed:@"SearchInputBackground.png"] forState:UIControlStateNormal];
    [searchInputButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:searchInputButton];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, backgroundView.bottom + 5, 80, 20)];
    title.font = [UIFont systemFontOfSize:14];
    [title setShadowColor:[UIColor blackColor]];
    [title setShadowOffset:CGSizeMake(2, 1)];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.text = @"热门搜索";
    [self.view addSubview:title];
    [title release];
    
    UIView *hotSearchView = [[UIView alloc] initWithFrame:CGRectMake(5, title.bottom + 5, 310, 126)];
    UIImage *img = [UIImage imageNamed:@"SearchLabelShadow.png"];
    [img stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    hotSearchView.contentMode = UIViewContentModeCenter;
    hotSearchView.backgroundColor = [UIColor colorWithPatternImage:img];
    [self.view addSubview:hotSearchView];
    [hotSearchView release];
    
    // 算出每行字符串的总长度
    _sumSizeArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _hotSearchArr.count; i++)
    {
        static float sumSize = 0;
        
        NSString *str = _hotSearchArr[i];
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = CGSizeMake(320,2000);
        CGSize buttonSize = [str sizeWithFont:font constrainedToSize:size];
        sumSize += buttonSize.width;
        if (i % 5 == 4)
        {
            NSNumber *num = [NSNumber numberWithFloat:sumSize];
            [_sumSizeArr addObject:num];
            sumSize = 0;
        }
    }
    
    static float sumSize = 0;
    static float lastButtonSize = 0;
    for (int i = 0; i < 4; i++)
    {
        sumSize = [_sumSizeArr[i] floatValue];
        
        // 算出每个button的间隙
        float interval = (kScreenWidth - sumSize) / 5;
        
        for (int j = 0; j < 5; j++)
        {
            LDButton *button = [LDButton buttonWithType:UIButtonTypeCustom];
            NSString *hotName = _hotSearchArr[j + 5 * i];
            [button setTitle:hotName forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(searchHotAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            UIFont *font = [UIFont systemFontOfSize:12];
            CGSize size = CGSizeMake(320,2000);
            CGSize buttonSize = [hotName sizeWithFont:font constrainedToSize:size];
            button.tag = 300 + j + 5 * i;
            button.frame = CGRectMake(lastButtonSize + 3, i * 30, buttonSize.width + interval - 3, 30);
            [hotSearchView addSubview:button];
            lastButtonSize += buttonSize.width + interval - 3;
        }
        sumSize = 0;
        lastButtonSize = 0;
    }
}


- (void)searchHotAction:(UIButton *)button
{
    if (button.tag != _selectedIndex && _selectedIndex != 0)
    {
        LDButton *button = (LDButton *)[self.view viewWithTag:_selectedIndex];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithRed:0.506 green:0.720 blue:0.132 alpha:1.000] forState:UIControlStateNormal];
    
    // 选中按钮变色
    _selectedIndex = button.tag;
    
    SearchDetailViewController *searchDetailVC = [[SearchDetailViewController alloc] init];
    searchDetailVC.keyWord = button.titleLabel.text;
    searchDetailVC.defaultSearchArr = _hotSearchArr;
    [self.navigationController pushViewController:searchDetailVC animated:YES];
    [searchDetailVC release];
}


- (void)searchAction
{
    SearchDetailViewController *searchDetailVC = [[SearchDetailViewController alloc] init];
    searchDetailVC.keyWord = nil;
//    searchDetailVC.defaultSearchArr = _hotSearchArr;
    [self.navigationController pushViewController:searchDetailVC animated:YES];
    [searchDetailVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
