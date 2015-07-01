//
//  PlayVC.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-28.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "PlayVC.h"
#import "DownMV.h"
#import "RecordModel.h"

@interface PlayVC ()

@end

@implementation PlayVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        self.view.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(durationAvailableAction)
                                                     name:MPMovieDurationAvailableNotification
                                                   object:nil];
        
        //播放状态改变
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playStateDidChange:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMpMovie];
    
    
    
    
    
}

- (void)initMpMovie{
    
    MPMoviePlayerController *moviePlayerCtrl = [[MPMoviePlayerController alloc] init];
    self.mvPlayerCtrl = moviePlayerCtrl;
    [moviePlayerCtrl release];
    
    self.mvPlayerCtrl.view.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    // 设置播放样式
    self.mvPlayerCtrl.controlStyle = MPMovieControlStyleNone;
    _mvPlayerCtrl.movieSourceType = MPMovieSourceTypeUnknown;
    
    // 设置背景颜色
    self.mvPlayerCtrl.view.backgroundColor = [UIColor clearColor];
    
    
    
    if (_model) {
        _nextButton.hidden = YES;
        _lastButton.hidden = YES;
        NSURL *url = [NSURL URLWithString:_model.url];
        self.mvPlayerCtrl.contentURL = url;
        _playListView.hidden = YES;
    }
    
    
    if (_playListArray.count > 0 || _locationArray.count > 0) {
        
        _lastButton.frame = _playButton.frame;
        _playButton.left = _lastButton.right + 30;
        _nextButton.left = _playButton.right + 30;
        
        _playListTable = [[BsaeView alloc] initWithFrame:CGRectMake(10, 10, kScreenHeight - 30,80) style:UITableViewStylePlain];
        //        _playListTable.autoresizesSubviews = YES;
        _playListTable.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        //        UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
        //        UIViewAutoresizingFlexibleWidth        = 1 << 1,
        //        UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
        //        UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
        //        UIViewAutoresizingFlexibleHeight       = 1 << 4,
        //        UIViewAutoresizingFlexibleBottomMargin = 1 << 5
        
        //        _playListTable.UIViewContentModeBottom;
        //        _playListTable.UIViewContentMode = UIViewContentModeBottom;
        
        
        
        if (_playListArray.count > 0) {
            _playListTable.modeArray = _playListArray;
            [_playListView addSubview:_playListTable];
            MVmodel *model = _playListArray[0];
            NSURL *url = [NSURL URLWithString:model.url];
            self.mvPlayerCtrl.contentURL = url;
        }else{
            _switchButton.hidden = YES;
            _playListTable.modeArray = _locationArray;
            [_playListView addSubview:_playListTable];
            
//            MVmodel *model = _locationArray[0];
            _playListTable.mark = 1; //标记
            self.mvPlayerCtrl.contentURL = _url;
  
        }
        
       
        
        
    }
    
    
    
    
    // 创建并初始化moviePlayerCtrl
    
    // 加载到view
    [self.view addSubview:_mvPlayerCtrl.view];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    button.backgroundColor = [UIColor clearColor];
    [_showView insertSubview:button atIndex:0];
    button.tag = 316;
    [button addTarget:self action:@selector(hiddenShow) forControlEvents:UIControlEventTouchUpInside];
    [button release];
    
    
    [self.mvPlayerCtrl prepareToPlay];
    self.mvPlayerCtrl.shouldAutoplay = YES;
    
    _slider = [[WXSlider alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
    _slider.continuous = NO;
    [_slider addTarget:self action:@selector(playProgressChangeAction:) forControlEvents:UIControlEventValueChanged];
    _slider.thumbImage = [UIImage imageNamed:@"thumbImage"];
    _slider.maximumImage = [UIImage imageNamed:@"NewmaximumtrackImage"];
    _slider.minimumImage = [UIImage imageNamed:@"NewminimumtrackImage"];
    _slider.playAbleImage = [UIImage imageNamed:@"NewprogressBuffer"];
    
    
    _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_bottomView addSubview:_slider];
    [_slider release];
    
    //    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShow)];
    //    gesture.delegate = self;
    //    [_showView addGestureRecognizer:gesture];
    //    [gesture release];
    
    [self.view addSubview:_showView];
    NSString *message = [NSString string];
    if (_model.artistName) {
       message  = [NSString stringWithFormat:@"%@   %@",_model.title,_model.artistName];
    }else{
        message = _model.title;
    }
   
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = CGSizeMake(320,2000);
    CGSize buttonSize = [message sizeWithFont:font constrainedToSize:size];

    _mvName.width =  buttonSize.width;
    _mvName.text = message;
    
//    _artistName.right = 191 + _mvName.width + 15;
//    NSString *str1 = _model.title;
//    UIFont *font1 = [UIFont systemFontOfSize:14];
//    CGSize size1 = CGSizeMake(320,2000);
//    CGSize buttonSize1 = [str1 sizeWithFont:font1 constrainedToSize:size1];
//    _artistName.width = _model.artistName.length * 14;
//    _artistName.text = _model.artistName;
    [self.view addSubview:_readyView];
    
    
    _readyView.hidden = NO;
    _activityViweNet.color = CommentColor;
    [_activityViweNet startAnimating];
    
    
    
}

#pragma mark - 获得可以播放的时间
- (void)durationAvailableAction{
    _readyView.hidden = YES;
    [_activityViweNet stopAnimating];
    //    _progressTime.text =
    //    _allTime.text =  _mvPlayerCtrl.duration;
    _allTime.text = [self formatPlayTime:_mvPlayerCtrl.duration];
    _allTime.textColor = CommentColor;
    _allTime.hidden = NO;
    
    
    
    
    NSMutableArray *recodArray = [RecordModel userDefalutsArraywithString:@"watchRecord"];
    if (_locationArray.count > 0) {
        
    }else{
        
   
    if (_playListArray.count > 0) {
        MVmodel *mode = _playListArray[_playListTable.index1];
        if ([recodArray containsObject:mode.MVID]) {
            //不写进
        }else{
            //            NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Model"];
            
            
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Model"];
            
            
            
            NSString *patha = [NSString stringWithFormat:@"%@/%@.plist",path,mode.MVID];
            [recodArray addObject:mode.MVID];
            BOOL y =[RecordModel userDeafaultsetObject:recodArray forKey:@"watchRecord"];
            BOOL ye =  [NSKeyedArchiver archiveRootObject:mode toFile:patha];
            int a;
        }
        
        
    }else{
        if ([recodArray containsObject:_model.MVID]) {
            //不写进
        }else{
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Model"];
            NSString *patha = [NSString stringWithFormat:@"%@/%@.plist",path,_model.MVID];
            [recodArray addObject:_model.MVID];
            BOOL y =[RecordModel userDeafaultsetObject:recodArray forKey:@"watchRecord"];
            BOOL ye =  [NSKeyedArchiver archiveRootObject:_model toFile:patha];
        }
        
    }
    }
    
}

-(NSString *)formatPlayTime:(NSTimeInterval) duration
{
    
    int minute = 0, hour = 0, second = duration;
    hour = second/3600;
    minute = (second%3600)/60;
    second = second%60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    
}


//跟踪播放进度
-(void)movieProgressDutationAction
{
    
    //判断自动切换
    if (_mvPlayerCtrl.currentPlaybackTime == _mvPlayerCtrl.duration ) {
        
        if (_playStyel == 1) {
            
        }
        
        
        if (_playListArray.count > 0 || _locationArray.count > 0) {
            if (_playListArray.count > 0) {
                
                if (_playListTable.index1 == _playListArray.count - 1) {
                    
                }else{
                    
                    MVmodel *model = _playListArray[_playListTable.index1 + 1];
                    _playListTable.index1 += 1;
                    _mvPlayerCtrl.contentURL = [NSURL URLWithString:model.url];
                    [_mvPlayerCtrl shouldAutoplay];
                    [_mvPlayerCtrl play];
                    _progressTime.hidden = YES;
                    _allTime.hidden = YES;
                }
                
            }else{
                
                if (_playListTable.index1 == _locationArray.count - 1) {
                    
                }else{
             
                    
                    MVmodel *model = _locationArray[_playListTable.index1 + 1];
                    _playListTable.index1 += 1;
                    _mvPlayerCtrl.contentURL = [self loactionUrl:model.title];
                    [_mvPlayerCtrl shouldAutoplay];
                    [_mvPlayerCtrl play];
                    _progressTime.hidden = YES;
                    _allTime.hidden = YES;
                    
                    
                }
               
                
                
                
                
                
            }
           
            
        }else{
            [_mvPlayerCtrl pause];
            _slider.value = 0;
            _mvPlayerCtrl.currentPlaybackTime = 0;
            _progressTime.text = [self formatPlayTime:0];
            [_mvPlayerCtrl play];
            
        }
        
        
    }
    
    _progressTime.text = [self formatPlayTime:_mvPlayerCtrl.currentPlaybackTime];
    _progressTime.textColor = CommentColor;
    
    if (_mvPlayerCtrl.playableDuration > 0) {
        _progressTime.hidden = NO;
    }
    
    _slider.value = _mvPlayerCtrl.currentPlaybackTime/_mvPlayerCtrl.duration;
    _slider.playAbvleValue = _mvPlayerCtrl.playableDuration/_mvPlayerCtrl.duration;
    
    //    NSLog(@"dutation");
    [self performSelector:@selector(movieProgressDutationAction) withObject:nil afterDelay:1];
}

#pragma mark- 拖拽进度条
//拖拽进度条
- (void)playProgressChangeAction:(WXSlider *)sender{
    
    NSTimeInterval duration = sender.value*_mvPlayerCtrl.duration;
    [_mvPlayerCtrl setCurrentPlaybackTime:duration];
    _progressTime.text = [self formatPlayTime:duration];
}

#pragma mark- 播放状态改变

- (void)playStateDidChange:(NSNotification *)notification
{
    
    //之前显示  能播放就隐藏
    _progressTime.hidden = NO;
    UIButton *button = (UIButton *) [_showView viewWithTag:307];
    if (_mvPlayerCtrl.playbackState == MPMoviePlaybackStatePlaying || _mvPlayerCtrl.playbackState == MPMoviePlaybackStateInterrupted ){
        [self performSelector:@selector(movieProgressDutationAction) withObject:nil afterDelay:0.1];
        [button setImage:[UIImage imageNamed:@"PlayStop.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"PlayStopHight"] forState:UIControlStateHighlighted];
        
    }else {
        //        NSLog(@"pause");
        //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieProgressDutationAction) object:nil];
        
        
        [button setImage:[UIImage imageNamed:@"PlayMovie"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"PlayMovieHight"] forState:UIControlStateHighlighted];
        
        
    }
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__FUNCTION__);
    [_model release];
    [_readyView release];
    
    [_mvName release];
    [_artistName release];
    [_showView release];
    [_progressTime release];
    [_allTime release];
    [_bottomView release];
    [_headView release];
    [_switchView release];
    [_urlImageView release];
    [_hdurlImageView release];
    [_playListView release];
    [_lastButton release];
    [_nextButton release];
    [_vilstBackImage release];
    [_playButton release];
    [_activityViweNet release];
    [_switchButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setReadyView:nil];
    [self setMvName:nil];
    [self setArtistName:nil];
    [self setShowView:nil];
    [self setProgressTime:nil];
    [self setAllTime:nil];
    [self setBottomView:nil];
    [self setHeadView:nil];
    [self setSwitchView:nil];
    [self setUrlImageView:nil];
    [self setHdurlImageView:nil];
    [self setPlayListView:nil];
    [self setLastButton:nil];
    [self setNextButton:nil];
    [self setVilstBackImage:nil];
    [self setPlayButton:nil];
    [self setActivityViweNet:nil];
    [self setSwitchButton:nil];
    [super viewDidUnload];
}
- (IBAction)returnAtion:(UIButton *)sender {
    int tag = sender.tag;
    switch (tag) {
        case 301:{
            [self dismissModalViewControllerAnimated:YES];
        }
            break;
        case 302:{
            [self dismissModalViewControllerAnimated:YES];
        }
        case 303:{
            
        }
            
            break;
        case 304:{
            
            DownMV *downMV = [DownMV shareInstance];
           
            NSMutableArray *recodArray = [RecordModel userDefalutsArraywithString:@"DownRecord"];
            
            if (_playListArray.count > 0) {
                MVmodel *mode = _playListArray[_playListTable.index1];
                if ([recodArray containsObject:mode.MVID]) {
                    //不写进
                }else{
                    
                    [downMV downMvWithUrl:mode.url mvName:mode.title tag:[mode.MVID integerValue]];
                    
                    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DownRecord"];
                    
                    
                    
                    NSString *patha = [NSString stringWithFormat:@"%@/%@.plist",path,mode.MVID];
                    
                    if (recodArray.count > 0) {
                        [recodArray insertObject:mode.MVID atIndex:0];
                    }else{
                        [recodArray addObject:mode.MVID];
                    }
                    
                    
                    [RecordModel userDeafaultsetObject:recodArray forKey:@"DownRecord"];
                    [NSKeyedArchiver archiveRootObject:mode toFile:patha];
                    
                }
                
                
            }else{
                if ([recodArray containsObject:_model.MVID]) {
                    //不写进
                }else{
                    
                   
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
                
            }
            
            
            
            
            
            
        }
            
            break;
        case 305:{
            
        }
            
            break;
        case 306:{
            if (_mvPlayerCtrl.scalingMode == MPMovieScalingModeAspectFill) {
                _mvPlayerCtrl.scalingMode = MPMovieScalingModeAspectFit;
                
                [sender setImage:[UIImage imageNamed:@"FullScreen.png"] forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"FullScreenHight.png"] forState:UIControlStateHighlighted];
                
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                [_mvPlayerCtrl setFullscreen:NO animated:YES];
            }else if (  _mvPlayerCtrl.scalingMode == MPMovieScalingModeAspectFit){
                
                _mvPlayerCtrl.scalingMode = MPMovieScalingModeAspectFill;
                
                
                [sender setImage:[UIImage imageNamed:@"Screen.png"] forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"ScreenHight.png"] forState:UIControlStateHighlighted];
                
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                
                
                
                
            }
            
        }
            
            break;
        case 307:{
            //            MPMoviePlaybackStateStopped,
            //            MPMoviePlaybackStatePlaying,
            //            MPMoviePlaybackStatePaused,
            //            MPMoviePlaybackStateInterrupted,
            //            MPMoviePlaybackStateSeekingForward,
            //            MPMoviePlaybackStateSeekingBackward
            //            [_mvPlayerCtrl.playbackState
            int playState = _mvPlayerCtrl.playbackState;
            
            
            switch (playState) {
                case 0:
                    
                    [_mvPlayerCtrl play];
                    break;
                case 1:
                    
                    [_mvPlayerCtrl pause];
                    break;
                case 2:
                    
                    [_mvPlayerCtrl play];
                    break;
                case 3:
                    
                    [_mvPlayerCtrl pause];
                    break;
                case 4:
                    
                    [_mvPlayerCtrl play];
                    break;
                case 5:
                    
                    [_mvPlayerCtrl play];
                    break;
                    
                    
                    
                    
                    
                default:
                    
                    break;
            }
        }
            
            break;
        case 308:{
            
            if (_playStyel == 3) {
                _playStyel = 0;
            }else{
                _playStyel++;
                
            }
            
            switch (_playStyel) {
                case 0:{
                    
                    [sender setImage:[UIImage imageNamed:@"OrderPlay"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"OrderPlayHight"] forState:UIControlStateSelected];
                    
                    
                    
                    
                }
                    
                    break;
                case 1:{
                    [sender setImage:[UIImage imageNamed:@"repeatPlayList.png"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"repeatPlayHight"] forState:UIControlStateSelected];
                }
                    
                    break;
                case 2:{
                    [sender setImage:[UIImage imageNamed:@"repeatPlay"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"repeatPlayHight"] forState:UIControlStateSelected];
                }
                    
                    break;
                case 3:{
                    [sender setImage:[UIImage imageNamed:@"RandomPlay"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"RandomPlayHight"] forState:UIControlStateSelected];
                }
                    
                    break;
                    
                default:
                    break;
            }
            
            
            
        }
            
            break;
        case 309:{
            //选择按钮 视频清晰度
            
            if (_switchView.hidden) {
                _switchView.hidden = !_switchView.hidden;
            }else{
                _switchView.hidden = !_switchView.hidden;
            }
        }
            
            break;
        case 310:{
            //高清
            [UIView animateWithDuration:0.3 animations:^{
                [sender setImage:[UIImage imageNamed:@"HD_Swithch_Sel"] forState:UIControlStateNormal];
                UIButton *button = (UIButton *)[_switchView viewWithTag:311];
                [button setImage:[UIImage imageNamed:@"SD"] forState:UIControlStateNormal];
                
                if (_playListArray.count > 0) {
                    
                    MVmodel *mode = _playListArray[_playListTable.index1];
                    if ([_mvPlayerCtrl.contentURL isEqual:[NSURL URLWithString:mode.hdUrl]]) {
                        
                    }else{
                        
                        _hdurlImageView.image = [UIImage imageNamed:@"HD_Definition_Sel"];
                        _hdurlImageView.hidden = NO;
                        [_mvPlayerCtrl setContentURL:[NSURL URLWithString:mode.hdUrl]];
                        [_mvPlayerCtrl shouldAutoplay];
                        [_mvPlayerCtrl play];
                        _progressTime.hidden = YES;
                        _slider.playAbvleValue = 0;
                        _slider.value = 0;
                        _urlImageView.hidden = YES;
                        
                        
                        
                        [_switchButton setImage:[UIImage imageNamed:@"HD"] forState:UIControlStateNormal];
                        [_switchButton setImage:[UIImage imageNamed:@"HD_Sel"] forState:UIControlStateSelected];
                        
                        
                    }
                    
                    
                    
                    
                }else{
                    
                    
                    if ([_mvPlayerCtrl.contentURL isEqual:[NSURL URLWithString:_model.hdUrl]]) {
                        
                        
                    }else{
                        _hdurlImageView.image = [UIImage imageNamed:@"HD_Definition_Sel"];
                        _hdurlImageView.hidden = NO;
                        [_mvPlayerCtrl setContentURL:[NSURL URLWithString:_model.hdUrl]];
                        [_mvPlayerCtrl shouldAutoplay];
                        [_mvPlayerCtrl play];
                        _progressTime.hidden = YES;
                        _slider.playAbvleValue = 0;
                        _slider.value = 0;
                        _urlImageView.hidden = YES;
                        
                        
                        
                        [_switchButton setImage:[UIImage imageNamed:@"HD"] forState:UIControlStateNormal];
                        [_switchButton setImage:[UIImage imageNamed:@"HD_Sel"] forState:UIControlStateSelected];
                        
                        
                    }
                    
                }
                
                
            } completion:^(BOOL finished) {
                
                _switchView.hidden = YES;
                
            }];
            
            
        }
            
            break;
        case 311:{
            //标清
            [UIView animateWithDuration:0.3 animations:^{
                
                [sender setImage:[UIImage imageNamed:@"SD_Switch_Sel"] forState:UIControlStateNormal];
                UIButton *button = (UIButton *)[_switchView viewWithTag:310];
                [button setImage:[UIImage imageNamed:@"HD"] forState:UIControlStateNormal];
                
                
                if (_playListArray.count > 0) {
                    MVmodel *mode = _playListArray[_playListTable.index1];
                    if ([_mvPlayerCtrl.contentURL isEqual:[NSURL URLWithString:mode.url]]) {
                        
                    }else{
                        
                        _mvPlayerCtrl.contentURL = [NSURL URLWithString:mode.url];
                        [_mvPlayerCtrl shouldAutoplay];
                        [_mvPlayerCtrl play];
                        
                        _slider.playAbvleValue = 0;
                        _slider.value = 0;
                        _progressTime.hidden = YES;
                        _hdurlImageView.hidden = YES;
                        _urlImageView.hidden = NO;
                        _urlImageView.image = [UIImage imageNamed:@"SD_Definition_Sel"];
                        [_switchButton setImage:[UIImage imageNamed:@"SD"] forState:UIControlStateNormal];
                        [_switchButton setImage:[UIImage imageNamed:@"SD_Sel"] forState:UIControlStateSelected];
                        
                        
                        
                    }
                    
                    
                    
                }else{
                    NSURL *url = _mvPlayerCtrl.contentURL;
                    
                    if ([_mvPlayerCtrl.contentURL isEqual:[NSURL URLWithString:_model.url]]) {
                        
                    }else{
                        [_mvPlayerCtrl setContentURL:[NSURL URLWithString:_model.url]];
                        [_mvPlayerCtrl shouldAutoplay];
                        [_mvPlayerCtrl play];
                        _slider.playAbvleValue = 0;
                        _slider.value = 0;
                        _progressTime.hidden = YES;
                        _hdurlImageView.hidden = YES;
                        _urlImageView.hidden = NO;
                        _urlImageView.image = [UIImage imageNamed:@"SD_Definition_Sel"];
                        
                        
                        UIButton *button = (UIButton *)[self.view viewWithTag:309];
                        [_switchButton setImage:[UIImage imageNamed:@"SD"] forState:UIControlStateNormal];
                        [_switchButton setImage:[UIImage imageNamed:@"SD_Sel"] forState:UIControlStateSelected];
                        
                    }
                    
                    
                    
                }
                
                
            } completion:^(BOOL finished) {
                _switchView.hidden = YES;
                
            }];
            
        }
            
            break;
            
        case 312:{
            //悦单的选择
            if (_bottomView.hidden) {
                
            }else{
                if (_vilstBackImage.hidden) {
                    [sender setImage:[UIImage imageNamed:@"DownMvList"] forState:UIControlStateNormal];
                    _vilstBackImage.hidden = NO;
                    _playListTable.hidden = NO;
                    sender.enabled = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        _playListView.top = _playListView.top - 85;
                    } completion:^(BOOL finished) {
                        sender.enabled = YES;
                    }];
                    
                }else{
                    [sender setImage:[UIImage imageNamed:@"UPMvlist"] forState:UIControlStateNormal];
                    sender.enabled = NO;
                    [UIView animateWithDuration:0.3 animations:^{
                        _playListView.top = _playListView.top + 85;
                    } completion:^(BOOL finished) {
                        _vilstBackImage.hidden = YES;
                        _playListTable.hidden = YES;
                        sender.enabled = YES;
                    }];
                    
                }
                
            }
            
        }
            
            break;
        case 313:{
            //last
            
            if (_playListArray.count > 0) {
                if (_playListTable.index1 == 0) {
                    
                }else{
                    
                    MVmodel *mode = _playListArray[_playListTable.index1 - 1];
                    int a1 = _playListTable.index1;
                    _playListTable.index1  = a1 - 1;
                    
                    
                    _mvPlayerCtrl.contentURL = [NSURL URLWithString:mode.url];
                    _progressTime.hidden = YES;
                    _allTime.hidden = YES;
                    
                    [_mvPlayerCtrl shouldAutoplay];
                    [_mvPlayerCtrl play];
                    
                }

            }else{
                
              
                    if (_playListTable.index1 == 0) {
                        
                    }else{
                MVmodel *mode = _locationArray[_playListTable.index1 - 1];
                int a1 = _playListTable.index1;
                _playListTable.index1  = a1 - 1;
                
                
                _mvPlayerCtrl.contentURL = [self loactionUrl:mode.title];
                _progressTime.hidden = YES;
                _allTime.hidden = YES;
                
                [_mvPlayerCtrl shouldAutoplay];
                [_mvPlayerCtrl play];
                    }

            }
            
        }
            
            break;
        case 314:{
            //next
            //全局都用 这个index
            if (_playListArray.count > 0) {
                if (_playListTable.index1 == _playListArray.count - 1) {
                    
                }else{
                    
                    MVmodel *mode = _playListArray[_playListTable.index1 + 1];
                    _playListTable.index1 = _playListTable.index1 + 1;
                    _mvPlayerCtrl.contentURL = [NSURL URLWithString:mode.url];
                    _progressTime.hidden = YES;
                    _allTime.hidden = YES;
                    [_mvPlayerCtrl shouldAutoplay];
                    [_mvPlayerCtrl play];
                    
                }

            }else{
                
                
                if (_playListTable.index1 == _locationArray.count - 1) {
                    
                    int a = _playListTable.index1;
                    
                }else{
                    int a = _playListTable.index1;
                    int b= _locationArray.count;

                    MVmodel *mode = _locationArray[_playListTable.index1 + 1];
                    _playListTable.index1 = _playListTable.index1 + 1;
                    _mvPlayerCtrl.contentURL = [self loactionUrl:mode.title];
                    _progressTime.hidden = YES;
                    _allTime.hidden = YES;
                    [_mvPlayerCtrl shouldAutoplay];
                    [_mvPlayerCtrl play];
                }
                
            }
            
        }
            
            break;
            
        case 315:{
            //手势 总是先响应
            [self hiddenShow];
        }
            
            break;
            
        case 316:{
            //手势 总是先响应
            [self hiddenShow];
        }
            
            break;
            
        default:
            break;
    }
    
}

//隐藏界面
- (void)hiddenShow{
    _switchView.hidden = YES;
    if (_headView.hidden) {
        _headView.hidden = NO;
        _bottomView.hidden = NO;
        if (_playListArray.count > 0 || _locationArray.count > 0) {
            _playListView.hidden = NO;
            
        }
        
        
    }else{
        _headView.hidden = YES;
        _bottomView.hidden = YES;
        
        _playListView.hidden = YES;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        return YES;
    }
    return NO;
}

#pragma mrak - 手势的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isMemberOfClass:[_playListTable class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - 每次换url 都会调
- (void)playDidFinish:(NSNotification *)notification
{
    
    if (_playStyel == 2) {
        _slider.value = 0;
        _mvPlayerCtrl.currentPlaybackTime = 0;
        _progressTime.text = [self formatPlayTime:0];
        [_mvPlayerCtrl play];
        
    }
    
}


- (NSURL *)loactionUrl:(NSString *)title{
    
              NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MV"];
               NSString *downloadPath = [NSString stringWithFormat:@"%@/%@.mp4",path,title];
             NSURL *url = [NSURL fileURLWithPath:downloadPath];
    return url;
}


@end
