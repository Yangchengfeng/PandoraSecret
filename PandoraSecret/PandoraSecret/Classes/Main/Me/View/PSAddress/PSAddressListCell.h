//
//  PSAddressListCell.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/16.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAddressListCell : UITableViewCell

@property (nonatomic, strong) PSUserOrderAddressModel *addressModel;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *delete;

@end
