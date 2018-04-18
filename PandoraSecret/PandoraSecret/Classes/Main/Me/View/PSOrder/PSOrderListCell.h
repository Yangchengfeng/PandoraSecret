//
//  PSOrderListCell.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/18.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSMeOrderModel.h"

@interface PSOrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *goodsImage;
@property (nonatomic, strong) PSMeOrderModel *orderListModel;

@end
