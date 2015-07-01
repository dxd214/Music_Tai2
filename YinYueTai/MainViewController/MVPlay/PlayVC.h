//
//  PlayVC.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-28.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MVmodel.h"
#import "WXSlider.h"

#import "BsaeView.h"


@interface PlayVC : UIViewController<UIGestureRecognizerDelegate>{
    int sceondduration;
    WXSlider *_slider;
    int _playStyel;
}

//@property(nonatomic,retain)ReadyView *readyView;

#pragma mark - 播放 悦单

@property(nonatomic, retain)NSArray *locationArray; //本地视频

@property(nonatomic, retain)BsaeView *playListTable;

@property(nonatomic, retain)NSArray *playListArray;



@property(nonatomic,retain)MVmodel *model;
@property (nonatomic, retain)NSURL *url;
@property (nonatomic, retain)MPMoviePlayerController *mvPlayerCtrl;
@property (retain, nonatomic) IBOutlet UIView *readyView;
- (IBAction)returnAtion:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *mvName;
@property (retain, nonatomic) IBOutlet UILabel *artistName;

@property (retain, nonatomic) IBOutlet UIView *showView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet UILabel *progressTime;
@property (retain, nonatomic) IBOutlet UILabel *allTime;


@property (retain, nonatomic) IBOutlet UIView *switchView;

@property (retain, nonatomic) IBOutlet UIImageView *urlImageView;

@property (retain, nonatomic) IBOutlet UIImageView *hdurlImageView;

@property (retain, nonatomic) IBOutlet UIView *playListView;

@property (retain, nonatomic) IBOutlet UIButton *lastButton;
@property (retain, nonatomic) IBOutlet UIButton *playButton;

@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UIImageView *vilstBackImage;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityViweNet;
@property (retain, nonatomic) IBOutlet UIButton *switchButton;
@end