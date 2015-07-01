//
//  KSTabBarController.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-23.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "KSTabBarController.h"
#import "BaseNavController.h"
#import "HomeFileVC.h"
#import "VRankVC.h"
#import "MVFileVC.h"
#import "MoreVC.h"
#import "CollectionVC.h"

@interface KSTabBarController (){
    UIImageView *_tabbarView;
    UIImageView *_badgeView;
}
@end

@implementation KSTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.VCArray = [NSArray array];
        self.tabBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initMainVC];
    [self initTabbarView];
}

#pragma mark - 初始化viewControllers
- (void)initMainVC{
    
    HomeFileVC *home = [[HomeFileVC alloc] init];
    MVFileVC *mv = [[MVFileVC alloc] init];
    VRankVC *rank = [[VRankVC alloc] init];
    CollectionVC *collect = [[CollectionVC alloc] init];
    MoreVC *more = [[MoreVC alloc] init];
    NSArray *ctrls = @[home, mv,rank, collect, more];
    

    NSMutableArray *navCtrls = [[NSMutableArray alloc] initWithCapacity:ctrls.count];
    
    //NAV上面的图片
    NSArray *imageArray = @[@"Title_First.png", @"Title_MV.png", @"Title_VList.png", @"Title_VlistGood.png", @"Title_More.png"];
    //每个viewController 
    for (int i = 0; i < ctrls.count; i++) {
        
            BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:ctrls[i]]; 
        //NAV上面的图片
         
            UIImage *image = [UIImage imageNamed:imageArray[i]];
        
           nav.titleImage.frame = CGRectMake((kScreenWidth - image.size.width) / 2, (44 - image.size.height) / 2 , image.size.width, image.size.height);
            nav.titleImage.image = image;
            
            
        
            nav.delegate = self;
            [navCtrls addObject:nav];
        
    }
   self.viewControllers = navCtrls;
    self.VCArray = navCtrls;

}

-(void)initTabbarView
{
    float itemWidth = kScreenWidth/5;
    
    //背景图片
    _tabbarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-57, kScreenWidth, 57)];
//    _tabbarView.image = [UIImage imageNamed:@"BottomBar_Icon.png"];
    _tabbarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabbarView];
    
  
 
    
    //5个item
  NSArray *array = @[@"Bottom_First.png", @"Bottom_MV.png", @"Bottom_VList.png", @"Bottom_MVList.png", @"Bottom_More.png"];
    
    for (int i=0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        btn.tag = i + 100;
        btn.frame = CGRectMake(i*itemWidth, 0, itemWidth,57);
       
        [btn setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        if (i == 0) {
        [btn setImage:[UIImage imageNamed:@"Bottom_First_Sel.png"] forState:UIControlStateNormal];
           
        }
        [btn addTarget:self action:@selector(selectTabbar:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:btn];

            }
}

-(void)selectTabbar:(UIButton *)btn
{
    _select2 = btn.tag - 100;
    int a;
    if (_select2 == _select1) {
        
    }else{
        
        a = _select2;
        _select2 = _select1;
        _select1 = a;
        
    self.selectedIndex = _select1;
        
     NSArray *imgArr = @[@"Bottom_First_Sel.png", @"Bottom_MV_Sel.png", @"Bottom_VList_Sel.png", @"Bottom_MVList_Sel.png", @"Bottom_More_Sel.png"];
        
   NSArray *arr = @[@"Bottom_First.png", @"Bottom_MV.png", @"Bottom_VList.png", @"Bottom_MVList.png", @"Bottom_More.png"];
        
        UIButton *but1 = (UIButton *)[_tabbarView viewWithTag:_select2 + 100];
      
    [UIView animateWithDuration:0.2 animations:^{
        [btn setImage:[UIImage imageNamed:imgArr[_select1]] forState:UIControlStateNormal];
        
        [but1 setImage:[UIImage imageNamed:arr[_select2]] forState:UIControlStateNormal];
        
        
        

    }];
        
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

//     int count =  [navigationController.viewControllers indexOfObject:viewController];
//    BaseNavController *nav =
    
    BaseNavController *nav = (BaseNavController *)navigationController;
    nav.navView.hidden = YES;
    int a = navigationController.viewControllers.count;
    if (a > 1) {
         nav.navView.hidden = YES;
        [self hiddeCustomTar:YES];
    }else{
         nav.navView.hidden = NO;
        [self hiddeCustomTar:NO];
            }
}

- (void)hiddeCustomTar:(BOOL)hidden{
    _tabbarView.hidden = hidden;
}



@end
