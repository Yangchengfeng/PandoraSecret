//
//  PSShowGroundCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/2.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShowGroundCell.h"
#import "PSShowGradeStarView.h"

static NSInteger totalStars = 5;

@interface PSShowGroundCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userVatcarImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *goodsDecs;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet PSShowGradeStarView *showGradeStarView;
@property (weak, nonatomic) IBOutlet UILabel *shopOrGoodsName;

@end

@implementation PSShowGroundCell

- (void)setShowGroundModel:(PSShowGroundModel *)showGroundModel {
    _showGroundModel = showGroundModel;
    _userName.text = showGroundModel.userName;
    [_userVatcarImage sd_setImageWithURL:[NSURL URLWithString:showGroundModel.userImage] placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
    _goodsDecs.text = showGroundModel.content;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:showGroundModel.topicImage] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
    
    [_showGradeStarView buildStarsWithSelectedStars:showGroundModel.likeNum totalStars:totalStars starSize:CGSizeMake(20, 20) optional:NO];
    _shopOrGoodsName.text = showGroundModel.shopName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEnterUserPage)];
    self.userVatcarImage.userInteractionEnabled = YES;
    [self.userVatcarImage addGestureRecognizer:tap];
    self.userVatcarImage.layer.cornerRadius = 20.f;
    self.userVatcarImage.layer.masksToBounds = YES;
}

- (void)tapToEnterUserPage {
    if([self.delegate respondsToSelector:@selector(enterUserPageWithUid:)]) {
        [self.delegate enterUserPageWithUid:_showGroundModel.userId];
    }
}

@end
