//
//  WXSlider.h
//  WXMovie
//
//  自定义UISlider, 左右边界能到达Thumb的中心点
//
//  Created by JayWon on 13-8-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXSlider : UIControl
{
    UIImageView *_thumbView;
    UIImageView *_minView;
    UIImageView *_maxView;
    UIImageView *_playAbleView;

}

@property(nonatomic) float value;
@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property(nonatomic) float playAbvleValue;
@property(nonatomic) BOOL continuous;

@property(nonatomic,retain) UIImage* thumbImage;
@property(nonatomic,retain) UIImage* minimumImage;
@property(nonatomic,retain) UIImage* maximumImage;
@property(nonatomic,retain) UIImage* playAbleImage;


@end
