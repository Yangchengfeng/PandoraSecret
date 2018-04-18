//
//  PSUserOrderAddressModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/14.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserOrderAddressModel.h"

@implementation PSUserOrderAddressModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.addressId = [dict[@"id"] stringValue];
        self.uname = dict[@"uname"];
        self.phone = [dict[@"phone"] stringValue];
        self.address = dict[@"address"];
        self.detailAddress = dict[@"detailAddress"];
        self.defaultAddress = [dict[@"defaultAddress"] stringValue];
    }
    return self;
}

+ (instancetype)orderAddressWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.addressId = [aDecoder decodeObjectForKey:@"id"];
        self.uname = [aDecoder decodeObjectForKey:@"uname"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.detailAddress = [aDecoder decodeObjectForKey:@"detailAddress"];
        self.defaultAddress = [aDecoder decodeObjectForKey:@"defaultAddress"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.addressId forKey:@"id"];
    [aCoder encodeObject:self.uname forKey:@"uname"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.detailAddress forKey:@"detailAddress"];
    [aCoder encodeObject:self.defaultAddress forKey:@"defaultAddress"];
}

@end
