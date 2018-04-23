//
//  PSShopCartTableViewCell.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/1.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSShopCartModel.h"

@protocol PSShopCartTableViewCellDelegate<NSObject>

- (void)shopCartToEnterDetailPageWithId:(NSInteger)detailPageId andIsHeader:(BOOL)isHeader;

@end

@interface PSShopCartTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, strong) PSShopCartModel *shopCartModel;
@property (nonatomic, assign) id<PSShopCartTableViewCellDelegate>shopCartDelegate;

- (instancetype)initWithParam:(BOOL)isHeader;

@end
