//
//  VRCell.m
//  YinYueTai
//
//  Created by Dick on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "VRCell.h"
#import "UIImageView+WebCache.h"
#import "MVDetailViewController.h"
#import "UIView+Additions.h"
#import "PlayVC.h"

@implementation VRCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setModel:(MVmodel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
        [self initView];
    }
}

- (void)initView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageButton.width, _imageButton.height)];
    imageView.layer.cornerRadius = 5;
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:@"mvImage.png"];
    NSURL *url = [NSURL URLWithString:_model.thumbnailPic];
    [imageView setImageWithURL:url];
    [_imageButton addSubview:imageView];
    [imageView release];
    //  NSLog(@"%@",  _model.artistName);
    _MVname.text = _model.title;
    _authorName.text = _model.artistName;
    _authorName.textColor = [UIColor colorWithRed:0.537 green:0.799 blue:0.275 alpha:1.000];
    _rankNum.textAlignment = NSTextAlignmentCenter;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_rankNum release];
    [_flagImgView release];
    [_authorName release];
    [_MVname release];
    [_imageButton release];
    [_bottomView release];
    [super dealloc];
}
- (IBAction)buttonAction:(UIButton *)sender {
    int tag = sender.tag;
    switch (tag) {
        case 101:{
            //点图片
            PlayVC *play = [[PlayVC alloc] init];
            play.model = _model;
            [self.viewController presentModalViewController:play animated:YES];
            [play release];
            
        }
            
            break;
            
        case 102:{
            //点小按钮
            
            
            
        }
            
            break;
//        case 103:{
//            //
//            
//            MVDetailViewController *MVDetailVC = [[MVDetailViewController alloc] init];
//            MVDetailVC.mvId = _model.MVID;
//            [self.viewController.navigationController pushViewController:MVDetailVC animated:NO];
//            
//            
//            [UIView  beginAnimations:nil context:NULL];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            [UIView setAnimationDuration:0.35];
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.viewController.navigationController.view cache:NO];
//            [UIView commitAnimations];
//            [MVDetailVC release];
//            
//            
//        }
//            
//            break;
//            
        default:
            break;
    }
}
@end
