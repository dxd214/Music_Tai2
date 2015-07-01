//
//  DataService.m
//  WXHL_Weibo_08
//
//  Created by JayWon on 13-10-18.
//  Copyright (c) 2013年 JayWon. All rights reserved.
//

#import "DataService.h"

#define Base_url    @"https://open.weibo.cn/2/"

@implementation DataService

+(ASIHTTPRequest *)requestWithURL:(NSString *)url
                           params:(NSMutableDictionary *)params
                       httpMethod:(NSString *)httpMethod
                      finishBlock:(FinishLoadHandle)block
{
    //1.获取本地的授权令牌
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
//    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
//    if (accessToken.length == 0) {
//        return nil;
//    }
//    
//    //2.拼接url
//    //https://open.weibo.cn/2/remind/unread_count.json?access_token=2.00TSa6WDrow3fD2d1326c0764aBiKD
//    NSString *urlString = [NSString stringWithFormat:@"%@%@?access_token=%@", Base_url, url, accessToken];
    
    
    //3.GET请求
    NSComparisonResult compResult1 =[httpMethod caseInsensitiveCompare:@"GET"];
    if (compResult1 == NSOrderedSame) {
        NSMutableString *paramsString = [NSMutableString string];
        
        //如果是get请求,则将参数拼接在url后面
        NSArray *allkeys = [params allKeys];
        for (NSString *key in allkeys) {
            NSString *value = [params objectForKey:key];
            
            [paramsString appendFormat:@"&%@=%@", key, value];
        }
        
        if (paramsString.length > 0) {
            url = [url stringByAppendingString:paramsString];
        }
    }

    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:httpMethod];
    [request setTimeOutSeconds:60];


    //4.POST请求
    NSComparisonResult compResult2 =[httpMethod caseInsensitiveCompare:@"POST"];
    if (compResult2 == NSOrderedSame) {
        //如果是get请求,则将参数拼接在url后面
        NSArray *allkeys = [params allKeys];
        for (NSString *key in allkeys) {
            id value = [params objectForKey:key];
            
            //判断是否上传文件
            if([value isKindOfClass:[NSData class]])
            {
                [request addData:value forKey:key];
            }else{
                [request addPostValue:value forKey:key];
            }
        }
    }
   
    //request 持有 block
    //block 持有 request
    [request setCompletionBlock:^{
        //解析json
        NSData *responseData = request.responseData;
        id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        
        //block传值
        if(block){
            block(result);
            
        }
    }];

    [request setFailedBlock:^{
        NSLog(@"请求失败:%@", request.error);
    }];

    //发异步请求
    [request startAsynchronous];

    return request;
}

@end
