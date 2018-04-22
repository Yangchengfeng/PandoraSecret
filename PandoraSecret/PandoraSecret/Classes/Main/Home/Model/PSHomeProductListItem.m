//
//  PSHomeProductListItem.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/11.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeProductListItem.h"

@implementation PSHomeProductListItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.tradeItemId = [dict[@"tradeItemId"] integerValue];
        self.name = dict[@"name"];
        self.title = dict[@"title"];
        self.productCategory = dict[@"category"];
        self.status = [dict[@"status"] integerValue];
        self.stock = [dict[@"stock"] integerValue];
        self.sale = [dict[@"sale"] integerValue];
        self.shopId = [dict[@"shopId"] integerValue];
        self.mainImage = dict[@"mainImage"];
        self.price = [dict[@"price"] integerValue];
        self.shopName = dict[@"shopName"];
        self.subImages = dict[@"subImages"];
    }
    return self;
}

+ (instancetype)homeProductListItemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
