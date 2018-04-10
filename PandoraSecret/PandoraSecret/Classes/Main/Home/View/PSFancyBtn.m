//
//  PSFancyBtn.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/11.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSFancyBtn.h"

@implementation PSFancyBtn

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor title:(NSString *)title font:(CGFloat)font imageName:(NSString *)imageName {
    self = [super initWithFrame:frame];
    if(self) {
        self.layer.cornerRadius = frame.size.width/2.;
        self.backgroundColor = backgroundColor;
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        CGFloat imageW = self.imageView.frame.size.width;
        CGFloat imageH = self.imageView.frame.size.height;
        CGFloat titleW = self.titleLabel.frame.size.width;
        CGFloat titleH = self.titleLabel.frame.size.height;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, -imageH, 0.f)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-titleH, 0.f, 0.f, -titleW)];
    }
    return self;
}

@end
