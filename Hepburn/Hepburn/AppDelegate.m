//
//  AppDelegate.m
//  Hepburn
//
//  Created by 阳丞枫 on 2018/7/22.
//  Copyright © 2018年 阳丞枫. All rights reserved.
//

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0")

#import "AppDelegate.h"
#import "HepburnBackgroundTask.h"
#import "HepburnPushHandler.h"
#import <PushKit/PKPushRegistry.h>

#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#define kNotification_Action_Follow_ID @"Notification_Action_Follow_ID"
#define kNotification_Action_Cancel_ID @"Notification_Action_Cancel_ID"

@interface AppDelegate () <UNUserNotificationCenterDelegate, PKPushRegistryDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIMutableUserNotificationAction *actionFollow = [[UIMutableUserNotificationAction alloc] init];
    actionFollow.identifier = @"Notification_Action_Follow_ID";
    actionFollow.activationMode = UIUserNotificationActivationModeBackground;
    actionFollow.title = @"关注";
    actionFollow.destructive = false;
    [actionFollow setAuthenticationRequired:false];
    
    UIMutableUserNotificationAction *actionCancel = [[UIMutableUserNotificationAction alloc] init];
    actionCancel.identifier = @"Notification_Action_Cancel_ID";
    actionCancel.activationMode = UIUserNotificationActivationModeBackground;
    actionCancel.title = @"取消";
    actionCancel.destructive = true;
    [actionCancel setAuthenticationRequired:false];
    
    UIMutableUserNotificationCategory *categoryFollow = [[UIMutableUserNotificationCategory alloc] init];
    categoryFollow.identifier = @"Notification_Category_Follow";
    [categoryFollow setActions:@[actionFollow, actionCancel] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObjects:categoryFollow, nil];
    
    if(@available(iOS 10.0, *)) {
        // registerAPN
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center setNotificationCategories:[NSSet setWithObjects:[self createCatrgory], nil]];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted && !error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            }
        }];
        
    } else {
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound categories:categories];
            [UIApplication.sharedApplication registerUserNotificationSettings:settings]; // 如果用户选择允许我们push的话这就会收到的回调didRegisterUserNotificationSettings
        } else {
            [UIApplication.sharedApplication registerForRemoteNotificationTypes:
             UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeSound];
        }
    }
    
    return YES;
}


- (UNNotificationCategory *)createCatrgory  API_AVAILABLE(ios(10.0)){

    UNTextInputNotificationAction *textInputAction = [UNTextInputNotificationAction actionWithIdentifier:@"textInputAction" title:@"请输入信息" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"输入" textInputPlaceholder:@"还有多少话要说……"];
    
    UNNotificationAction *followAction = [UNNotificationAction actionWithIdentifier:kNotification_Action_Follow_ID title:@"关注" options:UNNotificationActionOptionForeground];
    UNNotificationAction *cancelAction = [UNNotificationAction actionWithIdentifier:kNotification_Action_Cancel_ID title:@"取消" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"category" actions:@[textInputAction, followAction, cancelAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    return category;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications]; // 向苹果服务器申请app的token，对应回调如下didRegisterForRemoteNotificationsWithDeviceToken、didFailToRegisterForRemoteNotificationsWithError
}

// 成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceId = [NSString stringWithFormat:@"%@", deviceToken];
    deviceId = [deviceId substringWithRange:NSMakeRange(1, deviceId.length - 2)];
    deviceId = [deviceId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // upload tokenStr to server
}

// 失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[HepburnBackgroundTask sharedInstance] beginBackgroundTask];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[HepburnPushHandler sharedInstance] hepburnPushHandler:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 开始下载
    [self downloadSomethingFromServer];
    
    // 下载结束
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)downloadSomethingFromServer {
    
}

#pragma mark - VOIP push
- (void)registerVOIPPush {
    PKPushRegistry *reg = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    reg.delegate = self;
    reg.desiredPushTypes = [NSSet setWithObjects:PKPushTypeVoIP, nil];
    
    if(@available(iOS 10.0, *)) {
        // registerAPN
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted && !error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
        
    } else {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound categories:nil];
            [UIApplication.sharedApplication registerUserNotificationSettings:settings]; // 如果用户选择允许我们push的话这就会收到的回调didRegisterUserNotificationSettings
        } else {
            [UIApplication.sharedApplication registerForRemoteNotificationTypes:
             UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeSound];
        }
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    if([identifier isEqualToString:kNotification_Action_Follow_ID]) {
        
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion {
    // 收到voip push执行后台逻辑，并生成localpush
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)pushCredentials forType:(PKPushType)type {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
