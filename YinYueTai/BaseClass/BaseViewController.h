//
//  BaseViewController.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-23.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavController.h"
#import "Reachability.h"
#import "NSObject+SBJson.h"
#import "DataService.h"

@interface BaseViewController : UIViewController


//全局的标题图片
@property(nonatomic, retain)UIImage *title_Image;

//请求参数
@property(nonatomic, retain)NSMutableDictionary *paramDic;

- (void)titleImageSet:(UIImage *)image;

//判断是否有网络
- (NSInteger)isOline;

//没网时加的手势事件
- (void)tapAction;

@end
