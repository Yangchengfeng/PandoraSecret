//
//  PSNoDataView.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/15.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PSNoDataViewTypeSuccess, // 成功但没数据
    PSNoDataViewTypeFailure, // 处理失败
    PSNoDataViewTypeError,   // 网络失败
} PSNoDataViewType;

@interface PSNoDataView : UIView

- (void)noDataViewWithFrame:(CGRect)frame andType:(PSNoDataViewType)type;

@end
