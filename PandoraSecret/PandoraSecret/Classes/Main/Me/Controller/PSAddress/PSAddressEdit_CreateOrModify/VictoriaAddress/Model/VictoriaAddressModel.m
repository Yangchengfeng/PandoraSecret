//
//  VictoriaAddressModel.m
//  Address
//
//  Created by 阳丞枫 on 2018/4/16.
//  Copyright © 2018年 CodingFire. All rights reserved.
//

#import "VictoriaAddressModel.h"

@implementation VictoriaAddressModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
