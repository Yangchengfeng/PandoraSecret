//
//  PSOrderDetailModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/18.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSOrderDetailModel.h"

@implementation PSOrderDetailModel

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.productName = dict[@"productName"];
        self.price = dict[@"price"];
        self.image = dict[@"image"];
        self.num = dict[@"num"];
    }
    return self;
}

+ (instancetype)orderDetailWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
@end
