//
//  ActivityWebViewController.h
//  YinYueTai
//
//  Created by Dick on 13-11-5.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseViewController.h"

@interface ActivityWebViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_actView; // 风火轮
}
@end
