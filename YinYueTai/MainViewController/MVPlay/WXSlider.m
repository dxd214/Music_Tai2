//
//  WXSlider.m
//  WXMovie
//
//  Created by JayWon on 13-8-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXSlider.h"

#define kThumbSize  44

@implementation WXSlider

- (void)dealloc
{
    [_playAbleView release];
    [_minView release];
    [_maxView release];
    [_thumbView release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews
{
    _value = 0.0f;
    _minimumValue = 0.0f;
    _maximumValue = 1.0f;
    _continuous = YES;
//    self.backgroundColor = [UIColor yellowColor];
    
    _minView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _minView.contentMode = UIViewContentModeScaleToFill;
    _minView.backgroundColor = [UIColor blueColor];
    
    _playAbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
     _playAbleView.contentMode = UIViewContentModeScaleToFill;
     _playAbleView.backgroundColor = [UIColor blueColor];
    
    _maxView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _maxView.contentMode = UIViewContentModeScaleToFill;
    _maxView.backgroundColor = [UIColor lightTextColor];
    
    _thumbView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _thumbView.backgroundColor = [UIColor orangeColor];
    
    
    
    UIImage *minImg = [UIImage imageNamed:@"progress_blue_bar"];
    minImg = [minImg resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 2, 2)];
    UIImage *maxImg = [UIImage imageNamed:@"line"];
    maxImg = [maxImg resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
    
    [self setMinimumImage:minImg];
    [self setMaximumImage:maxImg];
    [self setThumbImage:[UIImage imageNamed:@"point"]];
    
    //注意 先后
    
    
    [self addSubview:_maxView];
    [self addSubview:_playAbleView];
    [self addSubview:_minView];
    [self addSubview:_thumbView];
}

-(void)setMinimumImage:(UIImage *)minimumImage
{
    if (_minimumImage != minimumImage) {
        [_minimumImage release];
        _minimumImage = [minimumImage retain];
        
        
        _minView.backgroundColor = [UIColor clearColor];
        _minView.image = minimumImage;
    }
}

- (void)setPlayAbleImage:(UIImage *)playAbleImage{
    if (_playAbleImage != playAbleImage) {
        [_playAbleImage release];
        _playAbleImage = [playAbleImage retain];
        
        _playAbleView.backgroundColor = [UIColor clearColor];
        _playAbleView.image = playAbleImage;
    }
}

-(void)setMaximumImage:(UIImage *)maximumImage
{
    if (_maximumImage != maximumImage) {
        [_maximumImage release];
        _maximumImage = [maximumImage retain];
        
        
        _maxView.backgroundColor = [UIColor clearColor];
        _maxView.image = maximumImage;
    }
}

-(void)setThumbImage:(UIImage *)thumbImage
{
    if (_thumbImage != thumbImage) {
        [_thumbImage release];
        _thumbImage = [thumbImage retain];
        
        _thumbView.backgroundColor = [UIColor clearColor];
        _thumbView.image = thumbImage;
    }
}

-(void)setMinimumValue:(float)minimumValue {
	_minimumValue = MIN(1.0,MAX(0,minimumValue));
}

-(void)setMaximumValue:(float)maximumValue {
	_maximumValue = MIN(1.0,MAX(0,maximumValue));
}

-(void)setValue:(float)value
{
    _value = MIN(MAX(_minimumValue, value), _maximumValue);
    
    [self setNeedsLayout];
}

-(void)resetValueWithTouchPoint:(CGPoint)touchPoint
{
    int startX = _thumbImage.size.width/2;
    int totalLen = self.bounds.size.width-_thumbImage.size.width;
    
    if (touchPoint.x < startX) {
        touchPoint.x = startX;
    }
    if (touchPoint.x > self.bounds.size.width-startX) {
        touchPoint.x = self.bounds.size.width-startX;
    }
    
    self.value = (touchPoint.x-startX)/totalLen;
}

#pragma mark
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int startX = _thumbImage.size.width/2;
    int startY = (self.bounds.size.height-_minimumImage.size.height)/2;
    int totalLen = self.bounds.size.width-_thumbImage.size.width;
    
    _minView.frame = CGRectMake(startX, startY, totalLen*_value, 12);
    _maxView.frame = CGRectMake(startX+totalLen*_value, startY, totalLen-totalLen*_value, 12);
    if (_playAbvleValue > _value) { //切换高清时 这里会蹦  才加的判断
        _playAbleView.frame = CGRectMake(startX, startY, totalLen *_playAbvleValue, 12);

    }else{
        _playAbleView.frame = CGRectMake(startX, startY, totalLen *_value, 12);
    }

       
    _thumbView.frame = CGRectMake(0, 0, _thumbImage.size.width, _thumbImage.size.height);
    _thumbView.center = CGPointMake(startX+totalLen * _value, self.bounds.size.height/2 -  5.5);
}

#pragma mark Touch tracking

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    CGPoint firstTouch = [touch locationInView:self];

    if ( CGRectContainsPoint(_thumbView.frame, firstTouch))  {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    [self resetValueWithTouchPoint:touchPoint];
    
    if (_continuous) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
	return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    [self resetValueWithTouchPoint:touchPoint];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
