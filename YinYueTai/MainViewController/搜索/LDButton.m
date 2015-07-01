//
//  LDButton.m
//  YinYueTai
//
//  Created by Dick on 13-10-30.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "LDButton.h"

@implementation LDButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [[UIColor clearColor] setFill];
    [rectanglePath fill];
    [[UIColor darkGrayColor] setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];
}


@end
