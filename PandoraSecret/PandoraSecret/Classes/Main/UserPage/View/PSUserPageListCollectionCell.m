//
//  PSUserPageListCollectionCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/25.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageListCollectionCell.h"

@implementation PSUserPageListCollectionCell

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSUserPageListCollectionCell" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
