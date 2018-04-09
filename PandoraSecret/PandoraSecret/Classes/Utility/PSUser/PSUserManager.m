//
//  PSUserManager.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/9.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserManager.h"

@implementation PSUserManager

static PSUserManager *_manager = nil;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init] ;
    }) ;
    return _manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [PSUserManager shareManager] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [PSUserManager shareManager] ;
}

- (void)userManagerWithUserInformation:(NSDictionary *)userInfo {
    self.userName = userInfo[@"userName"];
    self.userVatcar = userInfo[@"image"];
    self.userDesc = userInfo[@"userDesc"];
    self.phoneNum = userInfo[@"phone"];
    self.uid = userInfo[@"id"];
    self.focusNum = userInfo[@"focus"];
    self.collectionNum = userInfo[@"collection"];
}

- (void)deleteUserInfo {
    self.userName = @"潘多拉的神秘人";
    self.userVatcar = @"head_icon_me";
    self.userDesc = @"潘多拉神秘人，尽情在背后施展魔法";
    self.phoneNum = @"";
    self.uid = @"";
    self.focusNum = @"暂无";
    self.collectionNum = @"暂无";
}

@end
