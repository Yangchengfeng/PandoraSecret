//
//  PSShopHeaderView.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/23.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSShowGradeStarView.h"
#import "PSShopDetailModel.h"

@protocol PSShopHeaderViewDelegate <NSObject>

- (void)back;

@end

@interface PSShopHeaderView : UIView

@property (nonatomic, weak) id<PSShopHeaderViewDelegate> delegate;
@property (nonatomic, strong) PSShopDetailModel *shopHeaderModel;

@end
