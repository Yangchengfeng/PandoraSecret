//
//  PSShareCollectionViewCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/6.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShareCollectionViewCell.h"

@implementation PSShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSShareCollectionViewCell" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
