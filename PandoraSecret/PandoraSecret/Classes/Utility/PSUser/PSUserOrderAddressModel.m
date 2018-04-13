//
//  PSUserOrderAddressModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/14.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserOrderAddressModel.h"

@interface PSUserOrderAddressModel ()

@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger defaultAddress;

@end

@implementation PSUserOrderAddressModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.addressId = [dict[@"id"] integerValue];
        self.uname = dict[@"uname"];
        self.phone = dict[@"phone"];
        self.address = dict[@"address"];
        self.defaultAddress = [dict[@"defaultAddress"] integerValue];
    }
    return self;
}

+ (instancetype)orderAddressWithDict:(NSDictionary *)dict {
    if(dict == nil) {
        dict = @{@"id": @(-1),
                 @"uname": @"",
                 @"phone": @"",
                 @"address": @"",
                 @"defaultAddress": @(1)
                 };
    }
    return [[self alloc] initWithDict:dict];
}

@end
