//
//  PSShowGroundCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/2.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShowGroundCell.h"

@implementation PSShowGroundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSShowGroundCell" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
