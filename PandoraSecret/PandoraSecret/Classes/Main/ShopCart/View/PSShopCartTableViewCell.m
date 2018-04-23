//
//  PSShopCartTableViewCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/1.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//  商店cell + 商品cell 

#import "PSShopCartTableViewCell.h"

@interface PSShopCartTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *chooseGoodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseShopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIButton *shopNameBtn;

@end

@implementation PSShopCartTableViewCell

- (void)setShopName:(NSString *)shopName {
    _shopName = shopName;
    [_shopNameBtn setTitle:_shopName forState:UIControlStateNormal];
}

- (void)setShopId:(NSInteger)shopId {
    _shopId = shopId;
}

- (void)setShopCartModel:(PSShopCartModel *)shopCartModel {
    _shopCartModel = shopCartModel;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_shopCartModel.image] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
    _goodsTitle.text = _shopCartModel.title;
    _price.text = [NSString stringWithFormat:@"%ld", _shopCartModel.price];
    _num.text = [NSString stringWithFormat:@"%ld件", _shopCartModel.num];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置选中按钮
    [_chooseShopBtn setImage:[UIImage imageNamed:@"choose_none_line"] forState:UIControlStateNormal];
    [_chooseShopBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    
    [_chooseGoodsBtn setImage:[UIImage imageNamed:@"choose_none_line"] forState:UIControlStateNormal];
    [_chooseGoodsBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
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

- (IBAction)chooseAllGoodsInThisShop:(UIButton *)sender {
    NSLog(@"选中该商店所有商品");
    if(sender.isSelected) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
}

- (IBAction)enterShopHome:(id)sender {
    NSLog(@"进入该商店首页");
    if([self.shopCartDelegate respondsToSelector:@selector(shopCartToEnterDetailPageWithId:andIsHeader:)]) {
        [self.shopCartDelegate shopCartToEnterDetailPageWithId:self.shopId andIsHeader:YES];
    }
}

- (IBAction)chooseThisGoods:(UIButton *)sender {
    NSLog(@"选中该商品");
    if(sender.isSelected) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
}

- (IBAction)enterGoodsDetail:(id)sender {
     NSLog(@"查看该商品详情");
    if([self.shopCartDelegate respondsToSelector:@selector(shopCartToEnterDetailPageWithId:andIsHeader:)]) {
        [self.shopCartDelegate shopCartToEnterDetailPageWithId:_shopCartModel.itemId andIsHeader:NO];
    }
}



@end
