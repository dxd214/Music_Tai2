//
//  VRankModel.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-26.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "WXBaseModel.h"
#import "MVmodel.h"

@interface VRankModel : WXBaseModel

@property(nonatomic, retain)NSNumber        *no;           // 排榜期数
@property(nonatomic, retain)NSNumber        *year;          // 浮生未歇 官方版
@property(nonatomic, retain)NSNumber        *dateCode;    // SONY旗下歌姬藍井エイル将于11月13日发行第5张单曲
@property(nonatomic, copy)NSString          *beginDateText;    // 毕书尽
@property(nonatomic, copy)NSString          *endDateText;      // 海报图片
@property(nonatomic, copy)NSNumber          *prevDateCode;          // 浮生未歇 官方版
@property(nonatomic, copy)NSNumber          *nextDateCode;    // SONY旗下歌姬藍
@property(nonatomic, retain)MVmodel           *model;          // flv 高清


//"no": 42,
//"year": 2013,
//"dateCode": 20131014,
//"beginDateText": "10.14",
//"endDateText": "10.20",
//"prevDateCode": 20131007,
//"nextDateCode": 0

//program": {
//"id": 795382,
//"title": "2013年音悦V榜第42期 - 内地篇",
//"description": "本周内地V榜又迎来了一批朝气蓬勃的新竞争者。尚雯婕化身自然女神陪你一起看星光灿烂，刘心变身心理医生帮你找到新自己，还有刘忻为亲爱的他浅唱低吟。怎么？以为旁白君说错了人名？不是！此刘心非彼刘忻，看完节目你就能分清楚啦~",
//"artistName": "音悦V榜 & 华语群星",
//"posterPic": "http://img2.yytcdn.com/video/mv/131024/795382/94310141EA302E1D3C6D9FDA4592AA41_240x135.jpeg",
//"thumbnailPic": "http://img2.yytcdn.com/video/mv/131024/795382/94310141EA302E1D3C6D9FDA4592AA41_240x135.jpeg",
//"url": "http://dd.yinyuetai.com/uploads/videos/common/38E90141EA3B59F415E98EF7D41232AC.mp4?sc=aece2d03a1ed41e9&br=577&rd=iOS",
//"hdUrl": "http://hc.yinyuetai.com/uploads/videos/common/2A600141E971046B8B2B32FBA6B5737E.flv?sc=edf78ab3175bc15a&br=778&rd=iOS",
//"videoSize": 64974055,
//"hdVideoSize": 87610472,
//"uhdVideoSize": 0,
//"status": 0
//},

@end
