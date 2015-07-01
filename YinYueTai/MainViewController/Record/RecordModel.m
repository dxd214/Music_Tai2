//
//  RecordModel.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-2.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "RecordModel.h"
#import "MVmodel.h"

@implementation RecordModel
+ (NSDictionary *)modeTodic:(MVmodel *)model{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    //    [_MVID release];
    //    [_title release];
    //    [_description release];
    //    [_posterPic release];
    //    [_thumbnailPic release];
    //    [_url release]     ;
    //    [_hdUrl release];
    //    [_videoSize release];
    //    [_hdVideoSize release];
    //    [_uhdVideoSize release];
    //    [_status release]; // 20
    
    [dic setObject:model.MVID forKey:@"id"];
    [dic setObject:model.title forKey:@"title"];
    [dic setObject:model.description forKey:@"description"];
    [dic setObject:model.posterPic forKey:@"posterPic"];
    [dic setObject:model.thumbnailPic forKey:@"thumbnailPic"];
    [dic setObject:model.url forKey:@"url"];
    [dic setObject:model.hdUrl forKey:@"hdUrl"];
    [dic setObject:model.videoSize forKey:@"videoSize"];
    [dic setObject:model.hdVideoSize forKey:@"hdVideoSize"];
    [dic setObject:model.uhdVideoSize forKey:@"uhdVideoSize"];
    [dic setObject:model.status forKey:@"status"];
    NSDictionary *dic1 = [NSDictionary dictionaryWithDictionary:dic];
    [dic release];
    return dic1;
    
}


+ (BOOL)archive:(NSDictionary *)dict withKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = nil;
    if (dict) {
        data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    }
    [defaults setObject:data forKey:key];
    return [defaults synchronize];
}

+ (NSDictionary *)unarchiveForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    NSDictionary *userDict = nil;
    if (data) {
        userDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return userDict;
}

+ (NSMutableArray *)userDefalutsArraywithString:(NSString *)key{
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    return mutableArray;
}

+(BOOL)userDeafaultsetObject:(id)array forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:key];
    return [userDefaults synchronize];
}

+(NSArray *)arrayForPathString:(NSArray *)array  subPath:(NSString *)crruent{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (id subPath in array) {
        NSString *path1 = [NSString stringWithFormat:@"%@/%@/%@.plist",path,crruent,subPath];
        MVmodel *  model =  [NSKeyedUnarchiver unarchiveObjectWithFile:path1];
        [modelArray addObject:model];
        
    }
    
    return modelArray;
}


@end
