//
//  PSButton.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/10.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSButton.h"

@implementation PSButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 0.2;
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
