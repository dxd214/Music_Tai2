//
//  MVDetailViewController.m
//  YinYueTai
//
//  Created by Dick on 13-10-27.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "MVDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "PlayVC.h"
#import "DownMV.h"
#import "RecordModel.h"

@interface MVDetailViewController ()
{
    UIImageView *_shadowImgView;
}
@end

@implementation MVDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.userInteractionEnabled = YES;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [button setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"return_Sel.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
        
        [button release];
        [backItem release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"customBackground1@2x.png"]];
    _contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"customBackground1@2x.png"]];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_MVDetail.png"];
    [self titleImageSet:navImg];

}



- (void)setMvId:(NSNumber *)mvId
{
    if (_mvId != mvId)
    {
        [_mvId release];
        _mvId = [mvId retain];
        
        // 请求数据
        [self requestData];
    }
}

- (void)requestData
{
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"];
    
    [jsonDict setObject:@"20" forKey:@"size"];
    [jsonDict setObject:@"0" forKey:@"offset"];
    NSString *idStr = [NSString stringWithFormat:@"%@", _mvId];
    [jsonDict setObject:idStr forKey:@"id"];
    
    [DataService requestWithURL:@"http://mapi.yytcdn.com/video/show.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        _mvShowModel = [[MVshowModel alloc] initWithDataDic:result];
        NSArray *array = [result objectForKey:@"relatedVideos"];
        //
        NSMutableArray *arrayModel = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            MVshowModel *model = [[MVshowModel alloc] initWithDataDic:dic];
            [arrayModel addObject:model];
            [model release];
        }
        _relatedVideos = [arrayModel retain];
        
        if (_relatedVideos.count > 0)
        {
            // 请求完毕后， 初始化视图
            [self initViews];
        }
    }];
    
}

- (void)initViews
{
    _tableHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    [_tableHead addSubview:_headerView];
    
    // 给字体加阴影
    _mvNameLabel.shadowColor = [UIColor blackColor];
    _mvNameLabel.shadowOffset = CGSizeMake(2, 1);
    
    _ActorNameLabel.shadowColor = [UIColor blackColor];
    _ActorNameLabel.shadowOffset = CGSizeMake(2, 1);
    
    _textLabel.shadowColor = [UIColor blackColor];
    _textLabel.shadowOffset = CGSizeMake(2, 1);
    
    _foldTextLabel.shadowColor = [UIColor blackColor];
    _foldTextLabel.shadowOffset = CGSizeMake(2, 1);
    
    _bigImgView.layer.cornerRadius = 5;
    _bigImgView.layer.borderColor = [UIColor blackColor].CGColor;
    _bigImgView.layer.borderWidth = 0.5;
    _bigImgView.layer.masksToBounds = YES;
    
    // 设置textLabel默认行数
    _textLabel.numberOfLines = 3;
    
    // 增加展开 收起手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foldTapAction:)];
    _foldCtrlView.frame = CGRectMake(240, _textLabel.bottom, 80, 20);
    [_foldCtrlView addGestureRecognizer:tap];
    [tap release];
    _contentView.frame = CGRectMake(0, _headerView.bottom, kScreenWidth, 80);
    [_tableHead addSubview:_contentView];
    
    _shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _foldCtrlView.bottom, kScreenWidth, 5)];
    _shadowImgView.image = [UIImage imageNamed:@"TitleViewShadow.png"];
    [_contentView addSubview:_shadowImgView];
    
    UIImageView *lightShadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _headerView.height - 1, kScreenWidth, 4)];
    lightShadowImgView.image = [UIImage imageNamed:@"TitleViewShadow.png"];
    [_headerView addSubview:lightShadowImgView];
    [lightShadowImgView release];
    
    // 赋值
    [self loadData];
    
    _mvTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 -44 - 57) style:UITableViewStylePlain];
    _tableHead.height = _headerView.height + _contentView.height ;
   // [_tableHead sizeToFit];//不管用
    _mvTableView.tableHeaderView = _tableHead;
    _mvTableView.showArray = _relatedVideos;
    _mvTableView.backgroundColor = [UIColor clearColor];
    _mvTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mvTableView reloadInputViews];
    [self.view addSubview:_mvTableView];
  
    
    // 尾视图
    _footerView.frame = CGRectMake(0, kScreenHeight - 65 - 60, kScreenWidth, 65);
    [self.view addSubview:_footerView];
}

- (void)loadData
{
    [_bigImgView setImageWithURL:[NSURL URLWithString:_mvShowModel.posterPic]];
    _mvNameLabel.text = _mvShowModel.title;
    _ActorNameLabel.text = _mvShowModel.artistName;
    _textLabel.text = [NSString stringWithFormat:@"MV描述：%@", _mvShowModel.description];
    
}

- (void)foldTapAction:(UITapGestureRecognizer *)tap
{
    if (_isFold)
    {
        _foldTextLabel.text = @"展开全部";
        _foldImgView.image = [UIImage imageNamed:@"unfold@2x.png"];
        _textLabel.numberOfLines = 3;
        _contentView.frame = CGRectMake(0, _headerView.bottom, kScreenWidth, 80);
        _foldCtrlView.frame = CGRectMake(240, _textLabel.bottom, 80, 20);
        _shadowImgView.top = _foldCtrlView.bottom;
       
        _mvTableView.tableHeaderView.height = _headerView.height + _contentView.height ;
        
//             _tableHead.height = _headerView.height + _contentView.height;
        _tableHead.frame = CGRectMake(0, 0, kScreenWidth, _headerView.height + _contentView.height);
        [UIView animateWithDuration:0.3 animations:^{
            [_mvTableView beginUpdates];
            [_mvTableView setTableHeaderView:_tableHead];
            [_mvTableView endUpdates];
            
        }];

//        [_mvTableView reloadData];

        [self.view setNeedsLayout];
        
    }else
    {
        
        _foldTextLabel.text = @"收起";
        _foldImgView.image = [UIImage imageNamed:@"regain@2x.png"];
        _textLabel.numberOfLines = 0;
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        CGSize size = [_mvShowModel.description sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 1000)];
        _contentView.frame = CGRectMake(0, _headerView.bottom, kScreenWidth, size.height + 30);
        _foldCtrlView.frame = CGRectMake(240, _textLabel.bottom, 80, 20);
        _shadowImgView.top = _foldCtrlView.bottom;
//         _mvTableView.tableHeaderView.height = _headerView.height + _contentView.height;
//        _tableHead.height = _headerView.height + _contentView.height;
      
        _tableHead.frame = CGRectMake(0, 0, kScreenWidth, _headerView.height + _contentView.height);
        [UIView animateWithDuration:0.3 animations:^{
            [_mvTableView beginUpdates];
            [_mvTableView setTableHeaderView:_tableHead];
            [_mvTableView endUpdates];

        }];
       
//        [_mvTableView reloadData];

        [self.view setNeedsLayout];
//         [_mvTableView reloadData];
    }


    _isFold = !_isFold;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_tableHead release];
    [_mvTableView release];
    [_headerView release];
    [_bigImgView release];
    [_mvNameLabel release];
    [_ActorNameLabel release];
    [_contentView release];
    [_foldCtrlView release];
    [_foldImgView release];
    [_foldTextLabel release];
    [_mvShowModel release];
    [_mvId release];
    [_relatedVideos release];
    [_textLabel release];
    [_shadowImgView release];
    [_footerView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHeaderView:nil];
    [self setBigImgView:nil];
    [self setMvNameLabel:nil];
    [self setActorNameLabel:nil];
    [self setContentView:nil];
    [self setTextLabel:nil];
    [self setFoldCtrlView:nil];
    [self setFoldImgView:nil];
    [self setFoldTextLabel:nil];
    [self setTextLabel:nil];
    [self setFooterView:nil];
    [super viewDidUnload];
}

- (IBAction)playMVAction:(id)sender
{
    PlayVC *playVC = [[PlayVC alloc] init];
    playVC.model = _model;
    [self presentModalViewController:playVC animated:YES];
    [playVC release];
    
}
- (IBAction)footButtonClickAction:(UIButton *)sender {
    
    switch (sender.tag)
    {
            
        case 500:
            // ------------- 添加到悦单 --------------
            break;
        case 501:
            // --------------- 收藏 ------------------
            break;
        case 502:{
            // --------------- 下载 ------------------
            DownMV  *downMV = [DownMV shareInstance];
            NSMutableArray *recodArray = [RecordModel userDefalutsArraywithString:@"DownRecord"];
            
            [downMV downMvWithUrl:_model.url mvName:_model.title tag:[_model.MVID  integerValue]];
            
            
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/DownRecord"];
            NSString *patha = [NSString stringWithFormat:@"%@/%@.plist",path,_model.MVID];
            
            if (recodArray.count > 0) {
                [recodArray insertObject:_model.MVID atIndex:0];
            }else{
                [recodArray addObject:_model.MVID];
            }
            
            [RecordModel userDeafaultsetObject:recodArray forKey:@"DownRecord"];
            [NSKeyedArchiver archiveRootObject:_model toFile:patha];
            
            
        }
            break;
        case 503:
        {
            // --------------- 分享 ------------------
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"About_Logo"  ofType:@"png"];
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:_mvShowModel.description
                                               defaultContent:@"欢迎使用音悦台，在这里分享您喜欢的MV吧！"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"悦单分享"
                                                          url:@"http://www.sharesdk.cn"
                                                  description:_mvShowModel.description
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSPublishContentStateSuccess)
                                        {
                                            NSLog(@"分享成功");
                                        }
                                        else if (state == SSPublishContentStateFail)
                                        {
                                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                        }
                                    }];
        }
            break;
            
      
        default:
            // --------------- 微信 ---------------
            break;
    }
}
@end
