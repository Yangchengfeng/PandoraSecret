//
//  PSUserHomePageHeaderView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/25.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserHomePageHeaderView.h"

@implementation PSUserHomePageHeaderView

- (void)setHeaderDict:(NSMutableDictionary *)headerDict {
//    if(_userPageModel.userName.length>0) {
//        header.userNameLabel.text = _userPageModel.userName;
//    } else {
//        header.userNameLabel.text = @"潘多拉的秘密社会人";
//    }
//    if(_userPageModel.userDesc.length>0) {
//        header.userDescLabel.text = _userPageModel.userDesc;
//    } else {
//        header.userDescLabel.text = @"我只是潘多拉的秘密里的社会人";
//    }
//    [header.userVatcarImageView sd_setImageWithURL:[NSURL URLWithString:_userPageModel.image] placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
//    if(_userPageModel.isFocus==-1) {
//        header.focusBtn.hidden = YES;
//    } else {
//        header.focusBtn.hidden = NO;
//        if(_userPageModel.isFocus == 0) {
//            header.focusBtn.selected = NO;
//        } else {
//            header.focusBtn.selected = YES;
//        }
//    }
//    if(_userPageModel.uid == [PSUserManager shareManager].uid) {
//        header.focusBtn.hidden = YES;
//    } else {
//        header.focusBtn.hidden = NO;
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _userVatcar.layer.cornerRadius = 34.5;
    _userVatcar.layer.masksToBounds = YES;
    // 下划线位置
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
    
    // unfollow_button
    [_focusBtn setImage:[UIImage imageNamed:@"follow_button"] forState:UIControlStateNormal];
    [_focusBtn setImage:[UIImage imageNamed:@"unfollow_button"] forState:UIControlStateSelected];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPageListScrollToFollow) name:@"userPageScrollFollow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPageListScrollToCollection) name:@"userPageScrollFoCollection" object:nil];
}

- (IBAction)chooseListBtn:(UIButton *)sender {
    if(sender.tag == 10) {
        [self userPageListScrollToFollow];
        if([self.headerDelegate respondsToSelector:@selector(moveToFollowList)]) {
            [self.headerDelegate moveToFollowList];
        }
    }
    if(sender.tag == 11){
        [self userPageListScrollToCollection];
        if([self.headerDelegate respondsToSelector:@selector(moveToCollectionList)]) {
            [self.headerDelegate moveToCollectionList];
        }
    }
}

- (IBAction)focus:(id)sender {
    if([self.headerDelegate respondsToSelector:@selector(followThisPeople)]) {
        [self.headerDelegate followThisPeople];
    }
}

- (IBAction)share:(id)sender {
    if([self.headerDelegate respondsToSelector:@selector(shareThisPeople)]) {
        [self.headerDelegate shareThisPeople];
    }
}

- (IBAction)backToShowGround:(id)sender {
    if([self.headerDelegate respondsToSelector:@selector(goBackToShowGround)]) {
        [self.headerDelegate goBackToShowGround];
    }
}

- (void)userPageListScrollToFollow {
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
}

- (void)userPageListScrollToCollection {
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0 + kScreenWidth/2.+1;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userPageScrollFollow" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userPageScrollFoCollection" object:nil];
}


@end
