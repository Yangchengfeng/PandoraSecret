//
//  PSUserOrderAddressModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/14.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSUserOrderAddressModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, strong) NSString *defaultAddress;

+ (instancetype)orderAddressWithDict:(NSDictionary *)dict;

@end
