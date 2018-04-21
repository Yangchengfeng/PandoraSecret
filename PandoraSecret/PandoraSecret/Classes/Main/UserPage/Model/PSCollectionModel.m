//
//  PSCollectionModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSCollectionModel.h"

@implementation PSCollectionModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.uid = [dict[@"id"] integerValue];
        self.title = dict[@"title"];
        self.name = dict[@"name"];
        self.image = dict[@"image"];
    }
    return self;
}

+ (instancetype)collectionModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
