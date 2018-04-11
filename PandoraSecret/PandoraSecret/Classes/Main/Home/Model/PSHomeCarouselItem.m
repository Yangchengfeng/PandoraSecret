//
//  PSHomeCarouselItem.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/11.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeCarouselItem.h"

@implementation PSHomeCarouselItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.imageId = dict[@"id"]?:@"-1";
        self.link = dict[@"link"]?:@"errorlink";
        self.imagesUrl = dict[@"image"]?:@"";
        self.goodsCategory = dict[@"category"]?:@"unknown";
    }
    return self;
}

+ (instancetype)HomeCarouselWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
