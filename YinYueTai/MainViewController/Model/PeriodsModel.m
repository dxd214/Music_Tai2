//
//  PeriodsModel.m
//  YinYueTai
//
//  Created by Dick on 13-11-5.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "PeriodsModel.h"

@implementation PeriodsModel

- (void)dealloc{
    [_no release];
    [_year release];
    [_dateCode release];
    [_beginDateText release];
    [_endDateText release];
    [super dealloc];
}

@end
