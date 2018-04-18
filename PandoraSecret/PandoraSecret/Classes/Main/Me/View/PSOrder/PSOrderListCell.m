//
//  PSOrderListCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/18.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSOrderListCell.h"

@interface PSOrderListCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceAndGoodsNum;

@end

@implementation PSOrderListCell

- (void)setOrderListModel:(PSMeOrderModel *)orderListModel {
    NSTimeInterval interval = [orderListModel.createTime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *createData = [formatter stringFromDate: date];
    _orderTime.text = [NSString stringWithFormat:@"下单时间：%@", createData];
    
    if(orderListModel.image) {
        NSInteger showImageNum = orderListModel.image.count;
        NSMutableArray *imageShowArr = [NSMutableArray array];
        if(showImageNum>3) {
            for (int i=0; i<3; i++) {
                [imageShowArr addObject:orderListModel.image[i]];
            }
        } else {
            for (NSString *imageStr in orderListModel.image) {
                [imageShowArr addObject:imageStr];
            }
        }
        CGFloat imageWidth = (kScreenWidth-30 - 10*2)/3.;
        for (int i=0; i<imageShowArr.count; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((imageWidth+10)*i, 0, imageWidth, 100)];
            [image sd_setImageWithURL:[NSURL URLWithString:orderListModel.image[0]] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
            [self.goodsImage addSubview:image];
        }
    }
    
    _orderPriceAndGoodsNum.text = [NSString stringWithFormat:@"实付：%@ 共%@件商品", orderListModel.price, orderListModel.num];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSOrderListCell" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
