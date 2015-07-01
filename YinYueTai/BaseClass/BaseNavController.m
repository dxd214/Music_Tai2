//
//  BaseNavController.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-23.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseNavController.h"
#import "SearchViewController.h"
#import "MyMVViewController.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

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
    
//    [self.navigationBar setBackgroundColor:[UIColor blackColor]];

    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleView.png"] forBarMetrics: UIBarMetricsDefault];
    [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 44)];
    
    _navView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"titleView.png"]];
    
    [self.navigationBar addSubview:_navView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"Search.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"MyMusicIcon.png"] forState:UIControlStateNormal];
     [leftButton setImage:[UIImage imageNamed:@"MyMusicIcon_Sel.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:leftButton];
    
//    UIImage *image = [UIImage imageNamed:@"Title_First.png"];
//    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - image.size.width) / 2, (44 - image.size.height) / 2 , image.size.width, image.size.height)];
//    imagev.image = image;
//    [navView addSubview:imagev];

    
      _titleImage2 = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self.navigationBar addSubview:_titleImage2];

    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
       rightButton.frame = CGRectMake(kScreenWidth - 44, 0, 44, 44);
    [rightButton setImage:[UIImage imageNamed:@"Search.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:rightButton];
    
    
    _titleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.navigationBar addSubview:_titleImage];

    
    
    
       
    
    
}

- (void)leftAction{
    MyMVViewController *myMVVC = [[MyMVViewController alloc] init];
    [self pushViewController:myMVVC animated:YES];
}

- (void)rightAction
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self pushViewController:searchVC animated:YES];
}



@end
