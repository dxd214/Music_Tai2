//
//  PeriodsModel.h
//  YinYueTai
//
//  Created by Dick on 13-11-5.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "WXBaseModel.h"

@interface PeriodsModel : WXBaseModel

@property(nonatomic, retain)NSNumber        *no;           // 排榜期数
@property(nonatomic, retain)NSNumber        *year;          // 年份
@property(nonatomic, retain)NSNumber        *dateCode;    // 时间
@property(nonatomic, copy)NSString          *beginDateText;    // 开始时间
@property(nonatomic, copy)NSString          *endDateText;      // 结束时间


@end
