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
        self.tradeItemId = dict[@"tradeItemId"];
        self.name = dict[@"name"];
        self.title = dict[@"title"];
        self.productCategory = dict[@"category"];
        self.status = dict[@"status"];
        self.stock = dict[@"stock"];
        self.sale = dict[@"sale"];
        self.shopId = dict[@"shopId"];
        self.image = dict[@"image"];
        self.price = dict[@"price"];
    }
    return self;
}

+ (instancetype)homeProductListItemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
