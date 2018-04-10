//
//  PSHomeCarousel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/9.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeCarousel.h"

@implementation PSHomeCarousel

- (instancetype)init{
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSHomeCarousel" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
