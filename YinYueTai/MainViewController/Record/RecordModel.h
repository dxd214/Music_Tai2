//
//  RecordModel.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-2.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVmodel.h"

@interface RecordModel : NSObject
@property(nonatomic, retain)MVmodel *model;
+(NSDictionary *)modeTodic:(MVmodel *)model;

+ (BOOL)archive:(NSDictionary *)dict withKey:(NSString *)key;
+ (NSDictionary *)unarchiveForKey:(NSString *)key;


+ (NSMutableArray *)userDefalutsArraywithString:(NSString *)key;
+ (BOOL)userDeafaultsetObject:(id)array forKey:(NSString *)key;

+(NSArray *)arrayForPathString:(NSArray *)array  subPath:(NSString *)crruent;
@end
