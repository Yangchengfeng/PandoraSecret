//
//  PSShareView.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/6.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSShareView : UIView

- (instancetype)initWithshareViewFrame:(CGRect)frame ShareItems:(NSDictionary *)shareItems functionItems:(NSDictionary *)functionItems itemSize:(CGSize)itemSize;
- (void)showOnController:(UIViewController *)controller;

@end
