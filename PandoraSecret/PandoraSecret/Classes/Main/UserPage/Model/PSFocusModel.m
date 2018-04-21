//
//  PSFocusModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSFocusModel.h"

@implementation PSFocusModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.uid = [dict[@"id"] integerValue];
        self.userDesc = dict[@"userDesc"];
        self.userName = dict[@"userName"];
        self.image = dict[@"image"];
        self.isFocus = [dict[@"isFocus"] integerValue];
    }
    return self;
}

+ (instancetype)focusModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}


@end
