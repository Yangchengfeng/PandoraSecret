//
//  HepburnBackgroundTask.m
//  Hepburn
//
//  Created by 阳丞枫 on 2018/8/27.
//  Copyright © 2018年 阳丞枫. All rights reserved.
//

#import "HepburnBackgroundTask.h"
#import "AppDelegate.h"

@implementation HepburnBackgroundTask

+ (instancetype)sharedInstance {
    static HepburnBackgroundTask *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HepburnBackgroundTask alloc] init];
    });
    
    return instance;
}

- (void)beginBackgroundTask {
    // 启动后台任务
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            int remaintime = app.backgroundTimeRemaining;
            if(remaintime <= 5) {
                break;
            }
            NSLog(@"%ld", remaintime);
            [NSThread sleepForTimeInterval:1.0];
        }
//    });
  
    [app endBackgroundTask:taskId];
    taskId = UIBackgroundTaskInvalid;
}

@end
