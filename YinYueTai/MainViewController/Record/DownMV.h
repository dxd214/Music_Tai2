//
//  DownMV.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

//typedef ^(progressBlock)(NSString *prorsess);
@interface DownMV : NSObject{
    
    
    
}

@property(nonatomic, assign)__block long long currentSize;

@property(nonatomic, retain)NSMutableArray *idArray;

@property(nonatomic, retain) ASINetworkQueue *queue;;
+(DownMV *)shareInstance;
- (void)downMvWithUrl:(NSString *)url mvName:(NSString *)title tag:(int)tag;
@end
