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

- (IBAction)chooseAllGoodsInThisShop:(id)sender {
    NSLog(@"选中该商店所有商品");
}

- (IBAction)enterShopHome:(id)sender {
    NSLog(@"进入该商店首页");
}

- (IBAction)chooseThisGoods:(id)sender {
    NSLog(@"选中该商品");
}

- (IBAction)enterGoodsDetail:(id)sender {
     NSLog(@"查看该商品详情");
}

@end
