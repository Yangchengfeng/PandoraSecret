//
//  PSUserPageListFollowCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/4.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageListFollowCell.h"

@interface PSUserPageListFollowCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userVatcarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@end

@implementation PSUserPageListFollowCell

- (void)setFocusModel:(PSFocusModel *)focusModel {
    _focusModel = focusModel;
    
    [_userVatcarImageView sd_setImageWithURL:[NSURL URLWithString:_focusModel.image] placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
    _userDescLabel.text = _focusModel.userDesc;
    _userNameLabel.text = _focusModel.userName;
    if(_focusModel.isFocus == -1) {
        _focusBtn.hidden = YES;
    } else {
        _focusBtn.hidden = NO;
        if(_focusModel.isFocus == 0) {
            _focusBtn.selected = NO;
        } else {
            _focusBtn.selected = YES;
        }
    }
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSUserPageListFollowCell" owner:nil options:nil].firstObject;
        [_focusBtn setImage:[UIImage imageNamed:@"follow_button"] forState:UIControlStateNormal];
        [_focusBtn setImage:[UIImage imageNamed:@"unfollow_button"] forState:UIControlStateSelected];
    }
    return self;
}

@end
