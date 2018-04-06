//
//  PSThirdPartChooseView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/5.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSThirdPartChooseView.h"

@implementation PSThirdPartChooseView

// thirdparttype:share、pay
// items:QQ/短信/微博、 支付宝/微信
// imageName:XXXX

- (instancetype)initWithType:(NSInteger)type items:(NSDictionary *)items {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}


@end
