//
//  PSMeHeaderModel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/14.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMeHeaderModel.h"

@implementation PSMeHeaderModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.uname = dict[@"uname"];
        self.desc = dict[@"userDesc"];
        self.userVatcar = dict[@"image"];
        self.collectionNum = [dict[@"collection"] integerValue];
        self.focusNum = [dict[@"focus"] integerValue];
    }
    return self;
}

+ (instancetype)myCenterHeaderWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
