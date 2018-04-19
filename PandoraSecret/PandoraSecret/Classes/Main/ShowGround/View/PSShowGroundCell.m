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

@property (weak, nonatomic) IBOutlet UIButton *userVatcarImage;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *goodsDecs;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@end

@implementation PSShowGroundCell

- (void)setShowGroundModel:(PSShowGroundModel *)showGroundModel {
    _userName.text = showGroundModel.userName;
    [_userVatcarImage sd_setImageWithURL:[NSURL URLWithString:showGroundModel.userImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
    _goodsDecs.text = showGroundModel.content;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:showGroundModel.topicImage] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSShowGroundCell" owner:nil options:nil].firstObject;
    }
    return self;
}

@end
