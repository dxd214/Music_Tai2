//
//  PlayListDetailViewController.m
//  YinYueTai
//
//  Created by Dick on 13-10-27.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "PlayListDetailViewController.h"
#import "WXApiObject.h"
#import "PlayVC.h"
@interface PlayListDetailViewController ()

@end

@implementation PlayListDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    // 请求数据
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_MVListDetail.png"];
    [self titleImageSet:navImg];

}

- (void)requestData
{
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"]
    ;
    
    [jsonDict setObject:@"10" forKey:@"size"];
    [jsonDict setObject:_mvId forKey:@"id"];
    
    [DataService requestWithURL:@"http://mapi.yytcdn.com/playlist/show.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        _playListModel = [[PlayListModel alloc] initWithDataDic:result];
        
        NSArray *array = [result objectForKey:@"videos"];
        
        NSMutableArray *arrayModel = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            MVmodel *model = [[MVmodel alloc] initWithDataDic:dic];
            [arrayModel addObject:model];
            [model release];
        }
        _data = [arrayModel retain];
        [self loadData];
        [self initMvView];
    }];

}

- (void)loadData
{
    _titleLabel.text = _playListModel.title;
    _mvNumLabel.text = [NSString stringWithFormat:@"%@", _playListModel.videoCount];
    
}

- (void)initMvView
{
    _headerTitleView.frame = CGRectMake(0, 0, kScreenWidth, 88);
    [self.view addSubview:_headerTitleView];
    UIImageView *shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 87, kScreenWidth, 5)];
    shadowImgView.image = [UIImage imageNamed:@"TitleViewShadow.png"];
    [_headerTitleView addSubview:shadowImgView];
    [shadowImgView release];
    
    if (!_mvTableView)
    {
        _mvTableView  = [[BaseTableView alloc] initWithFrame:CGRectMake(0, _headerTitleView.bottom, kScreenWidth, kScreenHeight - 20 - 44 - 88 - 57) style:UITableViewStylePlain];
        [self.view addSubview:_mvTableView];
        
        _mvTableView.backgroundColor = [UIColor clearColor];
        _mvTableView.separatorColor = [UIColor clearColor];
        _mvTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    _mvTableView.showArray = _data;
    [_mvTableView reloadData];
    
    _footerView.frame = CGRectMake(0, kScreenHeight - 65 - 60, kScreenWidth, 65);
    [self.view addSubview:_footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_titleLabel release];
    [_mvNumLabel release];
    [_mvModel release];
    [_homeModel release];
    [_data release];
    [_headerTitleView release];
    [_playListModel release];
    [_footerView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setMvNumLabel:nil];
    [self setHeaderTitleView:nil];
    [self setFooterView:nil];
    [super viewDidUnload];
}
- (IBAction)playButtonClick:(id)sender {
    
    PlayVC *play = [[PlayVC alloc] init];
    play.playListArray = _data;
    [self presentModalViewController:play animated:YES];
    [play release];
    
    
    
    
}

- (IBAction)collectAction:(id)sender {
}

- (IBAction)shareAction:(id)sender {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"About_Logo"  ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:_playListModel.description
                                       defaultContent:@"欢迎使用音悦台，在这里分享您喜欢的MV吧！"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"悦单分享"
                                                  url:@"http://www.sharesdk.cn"
                                          description:_playListModel.description
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

- (IBAction)weiXin:(id)sender {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
    [req release];
}

#pragma mark - weixin
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        [alert release];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
@end
