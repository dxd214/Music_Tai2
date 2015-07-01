//
//  HomeModel.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-24.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "WXBaseModel.h"

@interface HomeModel : WXBaseModel

@property(nonatomic, copy)NSString          *type;           // VIDEO
@property(nonatomic, retain)NSNumber        *MVID;           // MV的ID
@property(nonatomic, copy)NSString          *title;          // 浮生未歇 官方版
@property(nonatomic, copy)NSString          *description;    // 毕书尽
@property(nonatomic, copy)NSString          *posterPic;      // 海报图片
@property(nonatomic, copy)NSString          *thumbnailPic;   // 缩略图地址
@property(nonatomic, copy)NSString          *url;            // MP4
@property(nonatomic, copy)NSString          *hdUrl;          // flv 高清
@property(nonatomic, retain)NSNumber        *videoSize;      // MP4的大小
@property(nonatomic, retain)NSNumber        *hdVideoSize;    // 高清size
@property(nonatomic, retain)NSNumber        *uhdVideoSize;   // 0
@property(nonatomic, retain)NSNumber        *status;         // 200





//"type": "VIDEO",
//"id": 793164,
//"title": "浮生未歇 官方版",
//"description": "毕书尽",
//"posterPic": "http://img3.yytcdn.com/uploads/mobile_front_page/AA750141DE294429F9D0B97A05E2F092.jpg?t=20131022100101",
//"thumbnailPic": "http://img0.yytcdn.com/video/mv/131022/793164/1C720141DDE50847AF737FC6C0C4D5A5_120x67.jpeg",
//"url": "http://dd.yinyuetai.com/uploads/videos/common/19FD0141DDE8713C628FD5BDC63E3001.mp4?sc=a1e22fdb0715bf24&br=579&rd=iOS",
//"hdUrl": "http://hc.yinyuetai.com/uploads/videos/common/666C0141D9BB1B3C409C41FE26165BFF.flv?sc=d56413b524c7fbae&br=781&rd=iOS",
//"videoSize": 18380260,
//"hdVideoSize": 24780930,
//"uhdVideoSize": 0,
//"status": 200

@end
