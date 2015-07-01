//
//  CellView.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-27.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "CellView.h"

@implementation CellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addButton];
    }
    return self;
}

- (void)addButton{
    UIButton *button = [[UIButton alloc] initWithFrame:self.frame];
    [button setImage:[UIImage imageNamed:@"customBackground3"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"customBackground3.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(aasssd) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button release];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bottom - 10, kScreenWidth, 10)];
//    imageView.image = [UIImage imageNamed:@"horizontalLine"];
    [self addSubview:imageView];
    [imageView release];
    
    
}

- (void)aasssd{
 
    int aa;
    
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
