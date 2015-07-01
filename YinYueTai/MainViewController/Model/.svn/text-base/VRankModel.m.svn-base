//
//  VRankModel.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-26.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "VRankModel.h"


@implementation VRankModel

//*no;
//*year;
//*dateCode;    /
//*beginDateText;
//*endDateText;
//*prevDateCode;
//*nextDateCode;
//*model;

- (void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    
    self.model = [[MVmodel alloc] initWithDataDic:[dataDic objectForKey:@"program"]];
}

- (void)dealloc{
    [_no release];
    [_year release];
    [_dateCode release];
    [_beginDateText release];
    [_endDateText release];
    [_prevDateCode release];
    [_nextDateCode release];
//    [_model release];
    [super dealloc];
}

@end
