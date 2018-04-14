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

#pragma mark - 保存

// 单项修改：用户头像、昵称、地址、手机号
- (void)setUname:(NSString *)uname {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:uname forKey:@"uname"];
}

- (void)setUserVatcar:(NSString *)userVatcar {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userVatcar forKey:@"userVatcar"];
}

- (void)setAddress:(PSUserOrderAddressModel *)address {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *addressData = [NSKeyedArchiver archivedDataWithRootObject:address];
    [user setObject:addressData forKey:@"address"];
}

- (void)setPhoneNum:(NSString *)phoneNum {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:phoneNum forKey:@"phoneNum"];
}

// 全部保存
- (void)saveUserInfo:(NSDictionary *)userInfo {
    PSUserOrderAddressModel *address = [PSUserOrderAddressModel orderAddressWithDict:userInfo[@"address"]];
    NSData *addressData = [NSKeyedArchiver archivedDataWithRootObject:address];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:[userInfo[@"id"] integerValue] forKey:@"uid"];
    [user setObject:(userInfo[@"userName"]?:@"潘多拉的神秘人") forKey:@"uname"];
    [user setObject:addressData forKey:@"address"];
    [user setObject:(userInfo[@"userDesc"]?:@"潘多拉的神秘人，尽情施展你的魔法吧！") forKey:@"userDesc"];
    [user setObject:userInfo[@"phone"] forKey:@"phoneNum"];
    [user setObject:(userInfo[@"image"]?:@"head_icon_me") forKey:@"userVatcar"];
    [user setObject:userInfo[@"collection"] forKey:@"collectionNum"];
    [user setObject:userInfo[@"focus"] forKey:@"focusNum"];
}

#pragma mark - 获取用户信息
// 单项
- (NSInteger)uid {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user integerForKey:@"uid"];
}

- (NSString *)uname {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"uname"];
}

- (NSString *)userVatcar {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userVatcar"];
}

- (NSString *)userDesc {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userDesc"];
}

- (PSUserOrderAddressModel *)address {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *addressData = [user objectForKey:@"address"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:addressData];
}

- (NSString *)phoneNum {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"phoneNum"];
}

- (NSInteger)focusNum {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user integerForKey:@"focusNum"];
}

- (NSInteger)collectionNum {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user integerForKey:@"collectionNum"];
}

// 全部
- (NSDictionary *)userInfo {
    NSDictionary *info = @{@"uname":self.uname,
                           @"uid":@(self.uid),
                           @"phoneNum":self.phoneNum,
                           @"userVatcar":self.userVatcar,
                           @"address":self.address,
                           @"focusNum":@(self.focusNum),
                           @"collectionNum":@(self.collectionNum)
                           };
    return info;
}

#pragma mark - 获取个人中心头部信息
- (PSMeHeaderModel *)myCenterHeaderModel {
    NSDictionary *info = @{@"uname":self.uname,
                           @"phoneNum":self.phoneNum,
                           @"userDesc":self.userDesc,
                           @"userVatcar":self.userVatcar,
                           @"focusNum":@(self.focusNum),
                           @"collectionNum":@(self.collectionNum)
                           };
    return [PSMeHeaderModel myCenterHeaderWithDict:info];
}

#pragma mark - 删除用户信息
- (void)deleteUserInfo {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

#pragma mark - 判断是否登录
- (BOOL)hasLogin {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [user integerForKey:@"uid"];
    BOOL hasLogin = NO;
    if(uid) {
        hasLogin = YES;
    }
    return hasLogin;
}

@end
