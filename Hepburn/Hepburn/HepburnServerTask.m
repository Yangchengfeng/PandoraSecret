//
//  HepburnServerTask.m
//  Hepburn
//
//  Created by 阳丞枫 on 2018/8/27.
//  Copyright © 2018年 阳丞枫. All rights reserved.
//

#import "HepburnServerTask.h"

@implementation HepburnServerTask

+ (instancetype)sharedInstance {
    static HepburnServerTask *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HepburnServerTask alloc] init];
    });
    
    return instance;
}

- (void)detectServerTask {
    // create Server message
    
    // create local push
}

@end
