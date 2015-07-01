//
//  MVshowModel.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-27.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "WXBaseModel.h"

@interface MVshowModel : WXBaseModel
@property(nonatomic, retain)NSNumber        *MVID;           // 微博ID 4
@property(nonatomic, copy)NSString          *title;          // 浮生未歇 官方版 8
@property(nonatomic, copy)NSString          *description;    // SONY旗下歌姬藍井エイル将于11月1 2
@property(nonatomic, copy)NSString          *artistName;    // 毕书尽  1
@property(nonatomic, copy)NSString          *posterPic;      // 海报图片 5
@property(nonatomic, copy)NSString          *thumbnailPic;   // 缩略图地址  7
@property(nonatomic, copy)NSString          *url;            // MP4   9
@property(nonatomic, copy)NSString          *hdUrl;          // flv 高清 3
@property(nonatomic, retain)NSNumber        *videoSize;      // MP4的大小  13
@property(nonatomic, retain)NSNumber        *hdVideoSize;    // 高清size  14
@property(nonatomic, retain)NSNumber        *uhdVideoSize;   // 0   12
@property(nonatomic, retain)NSNumber        *status;         // 200  6

@property(nonatomic, retain)NSNumber        *totalComments;      // 评论数 10
@property(nonatomic, retain)NSNumber        *totalViews;      // 浏览数 11  relatedVideos



//NSString *jsonRequest = [self.paramDic JSONRepresentation];
//
//NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:jsonRequest forKey:@"deviceinfo"]
//;
//
//[jsonDict setObject:@"20" forKey:@"size"];
//[jsonDict setObject:@"0" forKey:@"offset"];
//[jsonDict setObject:@"794672" forKey:@"id"];
//[DataService requestWithURL:@"http://mapi.yytcdn.com/video/show.json" params:jsonDict httpMethod:@"POST" finishBlock:^(id result) {
//    NSDictionary *dic = result;
//    NSArray *array = [result objectForKey:@"videos"];
//    MVshowModel **model = [[MVshowModel alloc] initWithDataDic:result];


@end
