//
//  PSMeHeaderTableViewCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/30.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMeHeaderTableViewCell.h"

@interface PSMeHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userVatcar;
@property (weak, nonatomic) IBOutlet UILabel *uName;
@property (weak, nonatomic) IBOutlet UILabel *userDesc;
@property (weak, nonatomic) IBOutlet UILabel *focusNum;
@property (weak, nonatomic) IBOutlet UILabel *collectionNum;

@end

@implementation PSMeHeaderTableViewCell

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSMeHeaderTableViewCell" owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)setHeaderModel:(PSMeHeaderModel *)headerModel {
    [self.userVatcar sd_setImageWithURL:[NSURL URLWithString:headerModel.userVatcar] placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
    self.uName.text = headerModel.uname;
    self.userDesc.text = headerModel.desc;
    self.focusNum.text = [NSString stringWithFormat:@"关注数：%ld", headerModel.focusNum];
    self.collectionNum.text = [NSString stringWithFormat:@"收藏数：%ld", headerModel.collectionNum];
}

@end
