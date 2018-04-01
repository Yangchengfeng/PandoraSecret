//
//  PSShopCartTableViewCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/1.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//  商店cell + 商品cell 

#import "PSShopCartTableViewCell.h"

@implementation PSShopCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithParam:(BOOL)isHeader {
    self = [super init];
    if(self) {
        if(isHeader) {
            self = [[NSBundle mainBundle] loadNibNamed:@"PSShopCartTableViewCell" owner:nil options:nil].firstObject;
        } else {
            self = [[NSBundle mainBundle] loadNibNamed:@"PSShopCartTableViewCell" owner:nil options:nil].lastObject;
        }
    }
    return self;
}

@end
