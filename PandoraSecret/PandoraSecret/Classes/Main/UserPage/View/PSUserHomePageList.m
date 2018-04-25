//
//  PSUserHomePageList.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/25.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserHomePageList.h"

@implementation PSUserHomePageList

- (instancetype)initWithFrame:(CGRect)frame andListType:(PSUserPageListType)listType {
    self = [super initWithFrame:frame];
    if(self) {
        if(listType == PSUserPageListTypeFollow) {
            self.backgroundColor = [UIColor blueColor];
        } else {
            self.backgroundColor = [UIColor redColor];
        }
    }
    return self;
}


@end
