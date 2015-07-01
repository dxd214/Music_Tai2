//
//  MVmodel.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-25.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "MVmodel.h"

@implementation MVmodel

- (void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    self.MVID = [dataDic objectForKey:@"id"];
}

- (void)dealloc
{
    
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


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.MVID forKey:@"MVID"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.posterPic forKey:@"posterPic"];
    [aCoder encodeObject:self.thumbnailPic forKey:@"thumbnailPic"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.hdUrl forKey:@"hdUrl"];
    [aCoder encodeObject:self.videoSize forKey:@"videoSize"];
    [aCoder encodeObject:self.hdVideoSize forKey:@"hdVideoSize"];
    [aCoder encodeObject:self.uhdVideoSize forKey:@"uhdVideoSize"];
    [aCoder encodeObject:self.status forKey:@"status"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self != nil) {
        self.MVID = [aDecoder decodeObjectForKey:@"MVID"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.description= [aDecoder decodeObjectForKey:@"description"];
        self.posterPic = [aDecoder decodeObjectForKey:@"posterPic"];
        self.thumbnailPic = [aDecoder decodeObjectForKey:@"thumbnailPic"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.hdUrl = [aDecoder decodeObjectForKey:@"hdUrl"];
        self.videoSize = [aDecoder decodeObjectForKey:@"videoSize"];
        self.hdVideoSize = [aDecoder decodeObjectForKey:@"hdVideoSize"];
        self.uhdVideoSize = [aDecoder decodeObjectForKey:@"uhdVideoSize"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        
    }
    return self;
}



@end
