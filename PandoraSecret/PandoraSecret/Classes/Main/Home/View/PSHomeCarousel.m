//
//  PSHomeCarousel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/9.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeCarousel.h"

@implementation PSHomeCarousel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSHomeCarousel" owner:nil options:nil].firstObject;
        [_hotSaleImageView setImage:[UIImage imageNamed:@"image_view_placeholder_large"]];
        _pageControl.numberOfPages = 5; // 设置五张
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = kPandoraSecretColor;
    }
    return self;
}

@end
