//
//  ActivityWebViewController.m
//  YinYueTai
//
//  Created by Dick on 13-11-5.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "ActivityWebViewController.h"

@interface ActivityWebViewController ()

@end

@implementation ActivityWebViewController

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
	// Do any additional setup after loading the view.
    [self initViews];
}

- (void)initViews
{
    //实例化一个WEBVIEW
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 - 44)];
    _webView.delegate = self;

    [self loadData];
    
    
    [self.view addSubview:_webView];
    
    //实例化风火轮
    _actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //停止旋转
    [_actView stopAnimating];
    _actView.frame = CGRectMake(0, 0, 20, 20);
    
    //创建导航按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_actView];
    self.navigationItem.rightBarButtonItem = [rightBarButtonItem autorelease];
}


//初始化数据
- (void)loadData
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://spread.mobile.yinyuetai.com/fs/index.jsp?unikey=dde9dc4213e545ec84ef9f1bb999270e"]];
    [_webView loadRequest:request];
    
}

#pragma mark - UIWebView delegate
//开始加载完成调用的协议方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
//    [self showHUD:@"正在加载..."];
    //    NSLog(@"开始加载");
    [_actView startAnimating];
}

//加载完成调用的协议方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self hideHUD];
    //    NSLog(@"加载完成");
    [_actView stopAnimating];
}

//监听页面跳转事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /*
     click:http://img31.mtime.cn/CMS/News/2013/08/31/142737.60622977.jpg;
     http://img31.mtime.cn/CMS/News/2013/08/31/142737.60622977.jpg;
     http://img31.mtime.cn/CMS/News/2013/08/31/142834.54337748.jpg;
     http://img31.mtime.cn/CMS/News/2013/08/31/142735.22446758.jpg;
     http://img31.mtime.cn/CMS/News/2013/08/31/142738.86649567.jpg;
     http://img31.mtime.cn/CMS/News/2013/08/31/142856.73878839.jpg;
     http://img31.mtime.cn/CMS/News/2013/08/31/142739.89615182.jpg
     */
    

    return YES;
}

- (void)dealloc
{
    [_webView release];
    _webView = nil;
    [_actView release]; // 风火轮
    _actView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
