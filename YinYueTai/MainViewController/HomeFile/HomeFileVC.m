//
//  HomeFileVC.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-23.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "HomeFileVC.h"
#import "BaseNavController.h"
#import "HomeModel.h"
#import "DataService.h"
#import "NSObject+SBJson.h"
#import "PlayListDetailViewController.h"
#import "PlayVC.h"
#import "MVmodel.h"
#import "MVDetailViewController.h"
#import "ActivityWebViewController.h"

@interface HomeFileVC ()

@end

@implementation HomeFileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePage:) name:kPageChangeNotification object:nil];
        _data = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self isOline]) {
        [self loadData];
        if (_data.count > 0)
        {
            [self initViews];
        }
    }
    
    //    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(postPageChangeNotification:) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_First.png"];
    [self titleImageSet:navImg];
    
}

- (void)tapAction{
    [super tapAction];
    
    if ([self isOline]) {
        [self loadData];
        if (_data.count > 0)
        {
            [self initViews];
        }
    }
    
    
}

//- (void)postPageChangeNotification:(NSTimer *)timer
//{
//    NSNumber *pageNum = [NSNumber numberWithInt:_pageControl.currentPage + 1];
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:pageNum forKey:@"index"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kPageChangeNotification object:self userInfo:dic];
//}

- (void)initViews
{
    // 赋值给scrollView
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    for (HomeModel *model in self.data)
    {
        NSString *postPicUrl = model.posterPic;
        [imgArr addObject:postPicUrl];
    }
    _infiniteScorllerView = [[InfiniteScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44 - 70) ImageArray:imgArr];
    _infiniteScorllerView.delegate = self;
    [self.view addSubview:_infiniteScorllerView];
    _contentView.frame = CGRectMake(0, kScreenHeight - 70 - 44 - 75, kScreenWidth, 75);
    [self.view addSubview:_contentView];
    _pageControl.numberOfPages = imgArr.count;
    
    HomeModel *model = self.data[0];
    // 赋值
    _mvNameLabel.text = model.title;
    _singNameLabel.text = model.description;
    [self changeImgAction:model];
    

}



- (void)loadData{
  
    NSString *jsonRequest = [self.paramDic JSONRepresentation];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"]
    ;
    
    [jsonDict setObject:@"10" forKey:@"size"];
    
    [DataService requestWithURL:@"http://mapi.yytcdn.com/suggestions/front_page.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
        NSArray *array = result;
        
        NSMutableArray *arrayModel = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            HomeModel *model = [[HomeModel alloc] initWithDataDic:dic];
            [arrayModel addObject:model];
        }
        _data = arrayModel;
        [self initViews];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidUnload {
    [self setContentView:nil];
    [self setMovieStyleImgView:nil];
    [self setPageControl:nil];
    [self setMvNameLabel:nil];
    [self setSingNameLabel:nil];
    [self setInfiniteScorllerView:nil];
    [self setData:nil];
    [self setPlayButton:nil];
    [super viewDidUnload];
}

- (void)changePage:(NSNotification *)notication
{
    int index = [[notication.userInfo objectForKey:@"index"] intValue];
    _pageControl.currentPage = index;
    if (index >= 0 && index < self.data.count)
    {
        HomeModel *model = [_data objectAtIndex:index];
        if (model)
        {
            _mvNameLabel.text = model.title;
            _singNameLabel.text = model.description;
            
            [self changeImgAction:model];
        }
    }
    
    
}

- (void)changeImgAction:(HomeModel *)model
{
    if ([model.type isEqualToString:@"VIDEO"])
    {
        _movieStyleImgView.image = [UIImage imageNamed:@"HomePagePlay.png"];
        [_playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
    }else if ([model.type isEqualToString:@"PLAYLIST"])
    {
        _movieStyleImgView.image = [UIImage imageNamed:@"HomePagePlayList.png"];
        [_playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
    }else if ([model.type isEqualToString:@"ACTIVITY"])
    {
        _movieStyleImgView.image = [UIImage imageNamed:@"HomePageActivety.png"];
        [_playButton setImage:[UIImage imageNamed:@"HomePageReadDetail"] forState:UIControlStateNormal];
    }else
    {
        _movieStyleImgView.image = [UIImage imageNamed:@"HomePageAD.png"];
        [_playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - InfiniteScrollerViewDelegate
- (void)infiniteScrollerViewDidClicked:(NSUInteger)index
{  ;
//    NSLog(@"%i,%i ",index , _infiniteScorllerView.currentPageIndex);
    // 传过来的index是从1开始的,所以要减掉1
    HomeModel *model = self.data[index - 1];
    if ([model.type isEqualToString:@"PLAYLIST"])
    {
        PlayListDetailViewController *playListDetailVC = [[PlayListDetailViewController alloc] init];
        playListDetailVC.mvId = [model.MVID stringValue];
        //        CATransition* transition = [CATransition animation];
        //        transition.duration = 0.35;
        //        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //        transition.type = @"oglFlip"; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        //        transition.subtype = kCATransitionFromLeft;
        //        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        //        [[self navigationController] pushViewController:playListDetailVC animated:NO];
        //        [playListDetailVC release];
        
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.35];
        [self.navigationController pushViewController:playListDetailVC animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }else if ([model.type isEqualToString:@"VIDEO"]){
        MVDetailViewController *mvDetail = [[MVDetailViewController alloc] init];
       
        
        //model 设计时的失误
        MVmodel *mvModel = [[MVmodel alloc] init];
        
        //model 设计时的失误
        mvModel.MVID = model.MVID;
        mvModel.title = model.title;
        mvModel.description = model.description;
        mvModel.thumbnailPic =model.thumbnailPic;
        mvModel.url = model.url;
        mvModel.hdUrl = model.hdUrl;
        mvModel.videoSize = model.videoSize;
        mvModel.hdVideoSize = model.hdVideoSize;
        mvModel.uhdVideoSize = model.uhdVideoSize;
        mvModel.status = model.status;

        
        mvDetail.mvId = model.MVID;
        mvDetail.model = mvModel;
        [self.navigationController pushViewController:mvDetail animated:YES];
        
    }
}

- (void)collectPicture:(NSUInteger)index
{
    NSLog(@"%ld", index);
    HomeModel *model = self.data[index - 1];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setImageWithURL:[NSURL URLWithString:model.posterPic]];
    
    UIImageWriteToSavedPhotosAlbum([imgView image], nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储照片成功"
                                                    message:@"您已将照片存储于图片库中，打开照片程序即可查看。"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (IBAction)playAtion1:(id)sender {
    HomeModel *model = self.data[_infiniteScorllerView.currentPageIndex - 1];

    if ([model.type isEqualToString:@"PLAYLIST"])
    {
        PlayListDetailViewController *playListDetailVC = [[PlayListDetailViewController alloc] init];
        playListDetailVC.mvId = [model.MVID stringValue];
               
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.35];
        [self.navigationController pushViewController:playListDetailVC animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }else if ([model.type isEqualToString:@"VIDEO"]){
        PlayVC *playVc = [[PlayVC alloc] init];
        MVmodel *mvModel = [[MVmodel alloc] init];
        
        //model 设计时的失误
        mvModel.MVID = model.MVID;
        mvModel.title = model.title;
        mvModel.description = model.description;
        mvModel.thumbnailPic =model.thumbnailPic;
        mvModel.url = model.url;
        mvModel.hdUrl = model.hdUrl;
        mvModel.videoSize = model.videoSize;
        mvModel.hdVideoSize = model.hdVideoSize;
        mvModel.uhdVideoSize = model.uhdVideoSize;
        mvModel.status = model.status;
        
        
        playVc.model = mvModel;
        [self presentModalViewController:playVc animated:YES];
        
    }else if ([model.type isEqualToString:@"ACTIVITY"])
    {
        ActivityWebViewController *activityVC = [[ActivityWebViewController alloc] init];
        [self.navigationController pushViewController:activityVC animated:YES];
        
    }


    
}



@end
