//
//  PSUserManager.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/9.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSUserOrderAddressModel.h"
#import "PSMeHeaderModel.h"

@interface PSUserManager : NSObject

@property (nonatomic, assign, readonly) NSInteger uid;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *userDesc;
@property (nonatomic, strong) PSUserOrderAddressModel *address;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *userVatcar;
@property (nonatomic, assign, readonly) NSInteger focusNum;
@property (nonatomic, assign, readonly) NSInteger collectionNum;
@property (nonatomic, strong, readonly) NSDictionary *userInfo;
@property (nonatomic, strong, readonly) PSMeHeaderModel *myCenterHeaderModel;

+ (instancetype)shareManager;
- (void)saveUserInfo:(NSDictionary *)userInfo;
- (void)deleteUserInfo;
- (BOOL)hasLogin;

@end
