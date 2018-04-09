//
//  PSUserManager.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/9.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSUserManager : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userVatcar;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userDesc;
@property (nonatomic, strong) NSString *focusNum;
@property (nonatomic, strong) NSString *collectionNum;

+ (instancetype)shareManager;
- (void)userManagerWithUserInformation:(NSDictionary *)userInfo;
- (void)deleteUserInfo;

@end
