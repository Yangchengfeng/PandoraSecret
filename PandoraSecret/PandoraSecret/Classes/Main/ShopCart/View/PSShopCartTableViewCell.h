//
//  PSShopCartTableViewCell.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/1.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSShopCartModel.h"

@interface PSShopCartTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) PSShopCartModel *shopCartModel;
- (instancetype)initWithParam:(BOOL)isHeader;

@end
