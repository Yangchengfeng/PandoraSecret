//
//  PSShowGroundModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/20.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShowGroundModel.h"

@implementation PSShowGroundModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.showId = [dict[@"id"] integerValue];
        self.userId = [dict[@"userId"] integerValue];
        self.userName = dict[@"userName"];
        self.userImage = dict[@"userImage"];
        self.content = dict[@"content"];
        self.topicImage = dict[@"topicImage"];
        self.anonymous = [dict[@"anonymous"] boolValue];
        self.width = [dict[@"width"] floatValue];
        self.height = [dict[@"height"] floatValue];
        self.likeNum = [dict[@"likeNum"] integerValue];
        self.shopName = dict[@"shopName"];
    }
    return self;
}

+ (instancetype)showWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
