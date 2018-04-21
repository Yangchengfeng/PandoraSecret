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
        _collectionArr = [NSMutableArray array];
        _topicArr = [NSMutableArray array];
        _focusArr = [NSMutableArray array];
        self.uid = [dict[@"id"] integerValue];
        self.userDesc = dict[@"userDesc"];
        self.userName = dict[@"userName"];
        self.isFocus = [dict[@"isFocus"] integerValue];
        self.phone = dict[@"phone"];
        self.image = dict[@"image"];
        for(NSDictionary *collect in dict[@"collection"]) {
            [_collectionArr addObject:[PSCollectionModel collectionModelWithDict:collect]];
        }
        for(NSDictionary *focus in dict[@"focus"]) {
             [_focusArr addObject:[PSFocusModel focusModelWithDict:focus]];
        }
        for(NSDictionary *topics in dict[@"topics"]) {
            [_topicArr addObject:[PSShowGroundModel showWithDict:topics]];
        }
    }
    return self;
}

+ (instancetype)userPageModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
