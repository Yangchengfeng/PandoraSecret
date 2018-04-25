//
//  AppDelegate.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/29.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@protocol WeiboDelegate <NSObject>

-(void)weiboLoginByResponse:(WBBaseResponse *)response;
-(void)weiboShareSuccessCode:(NSInteger)shareResultCode;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) id<WeiboDelegate> sinaDelegate;

@end

