//
//  ViewController.m
//  Hepburn
//
//  Created by 阳丞枫 on 2018/7/22.
//  Copyright © 2018年 阳丞枫. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILocalNotification *localNotification;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectHepburnEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectHepburnEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)detectHepburnEnterBackground {
    _localNotification = [[UILocalNotification alloc] init];
    _localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
    _localNotification.alertBody = @"快来记录你的蜜月之旅吧~";
    [[UIApplication sharedApplication] scheduleLocalNotification:_localNotification];
}

// 当用户在1分钟内打开应用则取消通知
- (void)detectHepburnEnterForeground {
    [[UIApplication sharedApplication] cancelLocalNotification:_localNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}


@end
