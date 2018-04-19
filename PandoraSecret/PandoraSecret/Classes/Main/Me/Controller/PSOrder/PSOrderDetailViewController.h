//
//  PSOrderDetailViewController.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/19.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSBaseViewController.h"

@interface PSOrderDetailViewController : PSBaseViewController

- (void)requestOrderDetailWithOrderId:(NSString *)orderId;

@end
