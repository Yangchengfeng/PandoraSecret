//
//  PSMeOrderModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/18.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMeOrderModel.h"

@implementation PSMeOrderModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.orderId = dict[@"orderId"];
        self.price = dict[@"price"];
        self.num = dict[@"num"];
        self.image = dict[@"image"];
        self.createTime = dict[@"createTime"];
    }
    return self;
}

+ (instancetype)orderItemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
