//
//  HepburnPushHandler.m
//  Hepburn
//
//  Created by 阳丞枫 on 2018/8/27.
//  Copyright © 2018年 阳丞枫. All rights reserved.
//

#import "HepburnPushHandler.h"

@implementation HepburnPushHandler

+ (instancetype)sharedInstance {
    static HepburnPushHandler *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HepburnPushHandler alloc] init];
    });
    
    return instance;
}

- (void)hepburnPushHandler:(NSDictionary *)info {
    // 对应操作
    NSLog(@"%@", info);
    
    NSDictionary *customInfo = info[@"aps"][@"custom"];
    NSString *j = customInfo[@"j"];
    NSString *p = customInfo[@"p"];
    
    NSLog(@"%@ *** %@", j, p);
}

@end
