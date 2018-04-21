//
//  PSShopCartModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShopCartModel.h"

@implementation PSShopCartModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.userListid = [dict[@"id"] integerValue];
        self.shopName = dict[@"shopName"];
        self.title = dict[@"title"];
        self.shopId = [dict[@"shopId"] integerValue];
        self.image = dict[@"image"];
        self.price = [dict[@"price"] integerValue];
        self.num = [dict[@"num"] integerValue];
        self.uid = [dict[@"uid"] integerValue];
        self.itemId = [dict[@"itemId"] integerValue];
    }
    return self;
}

+ (instancetype)shopCartListModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}


@end
