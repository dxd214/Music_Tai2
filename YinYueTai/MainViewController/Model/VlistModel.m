//
//  VlistModel.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-27.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "VlistModel.h"

@implementation VlistModel


- (void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    self.vlistId = [dataDic objectForKey:@"id"];
 
}

- (void)dealloc{
    [_vlistId release];
    [_thumbnailPic release];
    [_title release];
    [_videoCount release];
    [super dealloc];
}
@end
