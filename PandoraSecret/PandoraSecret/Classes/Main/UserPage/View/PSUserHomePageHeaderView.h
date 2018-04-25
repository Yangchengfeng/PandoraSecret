//
//  PSUserHomePageHeaderView.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/25.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat underlineWidthConstraint = 44.f;

@protocol PSUserPageHeaderViewDelegate <NSObject>

- (void)shareThisPeople;
- (void)followThisPeople;
- (void)moveToFollowList;
- (void)moveToCollectionList;
- (void)goBackToShowGround;

@end

@interface PSUserHomePageHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userVatcar;
@property (weak, nonatomic) IBOutlet UILabel *userDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlinViewLeftConstraint;
@property (nonatomic, copy) NSMutableDictionary *headerDict;
@property (nonatomic, weak) id<PSUserPageHeaderViewDelegate> headerDelegate;

@end
