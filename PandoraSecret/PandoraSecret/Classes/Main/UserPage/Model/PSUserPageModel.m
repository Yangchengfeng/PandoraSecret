//
//  PSUserPageModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageModel.h"

@implementation PSUserPageModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.uid = [dict[@"id"] integerValue];
        self.userDesc = dict[@"userDesc"];
        self.userName = dict[@"userName"];
        self.isFocus = [dict[@"isFocus"] integerValue];
        self.phone = dict[@"phone"];
        self.image = dict[@"image"];
        for(NSDictionary *collect in dict[@"collection"]) {
            [self.collectionArr addObject:[PSCollectionModel collectionModelWithDict:collect]];
        }
        for(NSDictionary *collect in dict[@"focus"]) {
            [self.focusArr addObject:[PSFocusModel focusModelWithDict:collect]];
        }
        for(NSDictionary *collect in dict[@"topics"]) {
            [self.topicArr addObject:[PSShowGroundModel showWithDict:collect]];
        }
    }
    return self;
}

+ (instancetype)userPageModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
