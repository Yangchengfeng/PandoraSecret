//
//  PSOrderDetailCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/18.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSOrderDetailCell.h"

@interface PSOrderDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation PSOrderDetailCell

- (void)setOrderDetailModel:(PSOrderDetailModel *)orderDetailModel {
    self.productName.text = orderDetailModel.productName;
    self.num.text = [NSString stringWithFormat:@"数量：%@", orderDetailModel.num];
    self.price.text = [NSString stringWithFormat:@"单价：￥%@", orderDetailModel.price];
    [self.image sd_setImageWithURL:[NSURL URLWithString:orderDetailModel.image] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
}

- (instancetype)init {
    self = [super init];
    if(self) {
         self = [[NSBundle mainBundle] loadNibNamed:@"PSOrderDetailCell" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
