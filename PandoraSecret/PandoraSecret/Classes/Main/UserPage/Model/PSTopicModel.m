//
//  PSTopicModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSTopicModel.h"

@implementation PSTopicModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {

    }
    return self;
}

+ (instancetype)topicModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
