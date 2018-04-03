//
//  PSUserPageHeaderView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/4.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageHeaderView.h"

@implementation PSUserPageHeaderView

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSUserPageHeaderView" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
