//
//  PlayListModel.m
//  YinYueTai
//
//  Created by Dick on 13-10-27.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "PlayListModel.h"

@implementation PlayListModel
- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    self.mvID = [dataDic objectForKey:@"id"];
}

- (void)dealloc
{
    [_mvID release];
    [_title release];
//    [_description release];
    [_thumbnailPic release];
    [_videoCount release];
    [_category release];
    [super dealloc];
}

@end
