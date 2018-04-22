//
//  PSGoodsDetailCell.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/22.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSHomeProductListItem.h"

@protocol PSGoodsDetailCellDelegate <NSObject>

- (void)enterShopPageWithShopId:(NSInteger)shopId;

@end

@interface PSGoodsDetailCell : UITableViewCell

@property (nonatomic, strong) PSHomeProductListItem *goodsDetailModel;
@property (nonatomic, strong) id<PSGoodsDetailCellDelegate> delegate;

@end
