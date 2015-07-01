//
//  DownMV.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "DownMV.h"


@implementation DownMV



+(DownMV *)shareInstance{
    static DownMV *instance = nil;
    @synchronized(self){
        if (instance == nil) {
            instance = [[DownMV alloc] init];
            
        }
    }
    return instance;
    
}

- (id)init{
    [super init];
    if (self) {
        _queue = [[ASINetworkQueue alloc] init];
        [_queue setShowAccurateProgress:YES];
        self.idArray = [NSMutableArray array];
    }
    return self;
}


- (void)downMvWithUrl:(NSString *)url mvName:(NSString *)title tag:(int)tag{
    //    [sender setTitle:@"下载中" forState:UIControlStateNormal];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.tag = tag;
    //定义下载路径
    NSNumber *num = [NSNumber numberWithInt:tag];
    if ([_idArray containsObject:num]) {
        //有就不加
    }else{
        if (_idArray.count > 0) {
            [_idArray insertObject:num atIndex:0];
        }else{
            [_idArray addObject:num];
        }
    }
    
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MV"];
    NSString *temp = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tempPath"];
    NSString *downloadPath = [NSString stringWithFormat:@"%@/%@.mp4",path,title];
    NSString *tempPath = [NSString stringWithFormat:@"%@/%@.mp4",temp,title];
    [request setDownloadDestinationPath:downloadPath];
    
    //设置缓存路径
    
    
    [request setTemporaryFileDownloadPath:tempPath];
    //设置支持断点续传
    [request setAllowResumeForFileDownloads:YES];

    [request setShouldContinueWhenAppEntersBackground:YES];
    
    //该了类方法
    //    [_queue addOperation:request];
    //    [_queue go];
    
    
    
    //设置下载的进度条
    //    [request setDownloadProgressDelegate:self.progressView];
    
    //设置下载完成的回调
    [request setCompletionBlock:^{
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [sender setTitle:@"下载" forState:UIControlStateNormal];
        //            self.progressLabel.text = @"下载完成";
        //        });
    }];
    
    
    //第一种方法
    //计算百分比
    __block long long receiveSize = 0;
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        
        receiveSize += size;
        _currentSize = receiveSize;
        float progress = (float)receiveSize/total;
        NSLog(@"value %f",progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            //     self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%", progress*100];
        });
    }];
    //发送异步请求
    [request startAsynchronous];
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id value = [change objectForKey:@"new"];
    float a = [value floatValue]*100;
    NSLog(@"value %f",a);
    //    self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%", [value floatValue]*100];
}

@end
