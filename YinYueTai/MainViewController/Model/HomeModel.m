//
//  HomeModel.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-24.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    self.MVID = [dataDic objectForKey:@"id"];
}

- (void)dealloc
{
    [_type release];
    [_MVID release];
    [_title release];
//    [_description release];
    [_posterPic release];
    [_thumbnailPic release];
    [_url release]     ;
    [_hdUrl release];
    [_videoSize release];
    [_hdVideoSize release];
    [_uhdVideoSize release];
    [_status release]; // 20
    [super dealloc];
}

@end
