//
//  PSGoodsDetailCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/22.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSGoodsDetailCell.h"

static CGFloat scrollImageViewW = 135;
static CGFloat scrollImageViewH = 95;
static CGFloat scrollImageViewMargin = 2.5;

@interface PSGoodsDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIView *shopBackView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIScrollView *subImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subImageConstraintH;
@property (weak, nonatomic) IBOutlet UILabel *subImageTitle;

@end

@implementation PSGoodsDetailCell

- (void)setGoodsDetailModel:(PSHomeProductListItem *)goodsDetailModel {
    _goodsDetailModel = goodsDetailModel;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodsDetailModel.mainImage] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_large"]];
    _goodsDescLabel.text = _goodsDetailModel.title;
    _priceLabel.text = [NSString stringWithFormat:@"￥%ld", _goodsDetailModel.price];
    _shopName.text = _goodsDetailModel.shopName;
    _goodsName.text = _goodsDetailModel.name;
    _stockLabel.text = [NSString stringWithFormat:@"库存数：%ld件", _goodsDetailModel.stock];
    if(_goodsDetailModel.status == 1) {
        _statusLabel.text = @"热卖中";
    } else {
        _statusLabel.text = @"卖光了";
    }
    _saleLabel.text = [NSString stringWithFormat:@"销量：%ld件", _goodsDetailModel.sale];
    
    NSMutableArray *subPic = [NSMutableArray array];
    [subPic addObject:_goodsDetailModel.mainImage];
    for(NSString *str in _goodsDetailModel.subImages) {
        [subPic addObject:str];
    }
    if(subPic.count > 0) {
        _subImage.contentSize = CGSizeMake(subPic.count*scrollImageViewW + scrollImageViewMargin*(subPic.count-1), scrollImageViewH);
        for(int i = 0; i<subPic.count; i++) {
            UIImageView *sub = [[UIImageView alloc] initWithFrame:CGRectMake((scrollImageViewW+scrollImageViewMargin)*i, scrollImageViewMargin, scrollImageViewW, scrollImageViewH)];
            [sub sd_setImageWithURL:[NSURL URLWithString:subPic[i]] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
            [_subImage addSubview:sub];
        }
        _subImageConstraintH.constant = 95;
        _subImageTitle.text = @"与该商品相关图片";
    } else {
        _subImageConstraintH.constant = 0;
        _subImageTitle.text = @"暂无相关图片";
    }
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSGoodsDetailCell" owner:nil options:nil].firstObject;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEnterShopPage)];
        self.shopBackView.userInteractionEnabled = YES;
        [self.shopBackView addGestureRecognizer:tap];
        
        _subImage.pagingEnabled = NO;
        _subImage.showsVerticalScrollIndicator = NO;
        _subImage.showsHorizontalScrollIndicator = YES;
        _subImage.scrollEnabled = YES;
    }
    return self;
}

- (void)tapToEnterShopPage {
    if([self.delegate respondsToSelector:@selector(enterShopPageWithShopId:)]) {
        [self.delegate enterShopPageWithShopId:_goodsDetailModel.shopId];
    }
}

@end
