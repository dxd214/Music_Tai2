//
//  DataService.h
//  WXHL_Weibo_08
//
//  Created by JayWon on 13-10-18.
//  Copyright (c) 2013年 JayWon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^FinishLoadHandle) (id result);

@interface DataService : NSObject

+(ASIHTTPRequest *)requestWithURL:(NSString *)url
                              params:(NSMutableDictionary *)params
                          httpMethod:(NSString *)httpMethod
                         finishBlock:(FinishLoadHandle)block;

@end
