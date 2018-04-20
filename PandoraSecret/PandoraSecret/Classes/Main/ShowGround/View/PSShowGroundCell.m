//
//  PSShowGroundCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/2.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShowGroundCell.h"
#import "UIButton+WebCache.h"

@interface PSShowGroundCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userVatcarImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *goodsDecs;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopOrGoodsName;

@end

@implementation PSShowGroundCell

- (void)setShowGroundModel:(PSShowGroundModel *)showGroundModel {
    _userName.text = showGroundModel.userName;
    [_userVatcarImage sd_setImageWithURL:[NSURL URLWithString:showGroundModel.userImage] placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
    _goodsDecs.text = showGroundModel.content;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:showGroundModel.topicImage] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
    _gradeLabel.text = [NSString stringWithFormat:@"%ld分", showGroundModel.likeNum];
    _shopOrGoodsName.text = showGroundModel.shopName;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSShowGroundCell" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
