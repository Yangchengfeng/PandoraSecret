//
//  PSShopDetailModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/23.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShopDetailModel.h"

@implementation PSShopDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.fans = [dict[@"fans"] integerValue];
        self.image = dict[@"image"];
        self.shopName = dict[@"shopName"];
        self.star = [dict[@"star"] integerValue];
        self.content = dict[@"content"];
    }
    return self;
}

+ (instancetype)shopDetailWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
