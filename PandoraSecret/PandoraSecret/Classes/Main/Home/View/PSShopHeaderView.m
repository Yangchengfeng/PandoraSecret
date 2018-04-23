//
//  PSShopHeaderView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/23.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShopHeaderView.h"


@interface PSShopHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet PSShowGradeStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopIntroLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maskView;

@end

@implementation PSShopHeaderView

- (void)setShopHeaderModel:(PSShopDetailModel *)shopHeaderModel {
    _shopHeaderModel = shopHeaderModel;
    
    [_maskView sd_setImageWithURL:[NSURL URLWithString:_shopHeaderModel.image] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:_shopHeaderModel.image] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
    _shopNameLabel.text = _shopHeaderModel.shopName;
    _starView.selectedStars = _shopHeaderModel.star;
    _fansNumLabel.text = [NSString stringWithFormat:@"粉丝数:%ld", _shopHeaderModel.fans];
    _shopIntroLabel.text = _shopHeaderModel.content;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSShopHeaderView" owner:nil options:nil].firstObject;
        [_starView buildStarsWithSelectedStars:0 totalStars:5 starSize:CGSizeMake(15, 15) optional:NO];
    }
    return self;
}

- (IBAction)back:(id)sender {
    if([self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}
@end
