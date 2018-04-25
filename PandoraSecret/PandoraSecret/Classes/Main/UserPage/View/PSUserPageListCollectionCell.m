//
//  PSUserPageListCollectionCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/25.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageListCollectionCell.h"

@interface PSUserPageListCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *collectionName;
@property (weak, nonatomic) IBOutlet UILabel *collectionDesc;
@property (weak, nonatomic) IBOutlet UIImageView *collectionGoodsImage;
@property (weak, nonatomic) IBOutlet UIImageView *collectionUserImage;

@end

@implementation PSUserPageListCollectionCell

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSUserPageListCollectionCell" owner:nil options:nil].firstObject;
        [self.collectionUserImage removeFromSuperview];
    }
    return self;
}

- (void)setTopicModel:(PSShowGroundModel *)topicModel {
    self.collectionName.text = topicModel.shopName;
    self.collectionDesc.text = topicModel.content;
    [self.collectionGoodsImage sd_setImageWithURL:[NSURL URLWithString:topicModel.topicImage] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
    [self.collectionUserImage sd_setImageWithURL:[NSURL URLWithString:topicModel.userImage] placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
}

- (void)setCollectionModel:(PSCollectionModel *)collectionModel {
    self.collectionName.text = collectionModel.name;
    self.collectionDesc.text = collectionModel.title;
    [self.collectionGoodsImage sd_setImageWithURL:[NSURL URLWithString:collectionModel.image] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
}

@end
