//
//  VictoriaAddressEditViewController.h
//  Address
//
//  Created by 阳丞枫 on 2018/4/16.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSUserOrderAddressModel.h"
#import "PSBaseViewController.h"

typedef enum {
    VictoriaAddressEditTypeNew,   //新增
    VictoriaAddressEditTypeModify // 编辑
} VictoriaAddressEditType;

@interface VictoriaAddressEditViewController : PSBaseViewController

@property (nonatomic, strong) PSUserOrderAddressModel *addressModel;
- (void)enterAddressEditVCWithType:(VictoriaAddressEditType)editType;

@end
