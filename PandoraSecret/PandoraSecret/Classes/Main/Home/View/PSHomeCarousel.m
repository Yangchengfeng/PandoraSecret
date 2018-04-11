//
//  PSHomeCarousel.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/9.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeCarousel.h"

@interface PSHomeCarousel ()

@property (weak, nonatomic) IBOutlet UIImageView *hotSaleImageView;

@end

@implementation PSHomeCarousel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSHomeCarousel" owner:nil options:nil].firstObject;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = kPandoraSecretColor;
    }
    return self;
}

- (void)setHomeCarouselItem:(PSHomeCarouselItem *)homeCarouselItem {
    if(!_homeCarouselItem) {
        _homeCarouselItem = homeCarouselItem;
    }
    if(homeCarouselItem.imagesUrl.length > 0) {
        [_hotSaleImageView sd_setImageWithURL:[NSURL URLWithString:homeCarouselItem.imagesUrl] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_large"]];
    } else {
        [_hotSaleImageView setImage:[UIImage imageNamed:@"image_view_placeholder_large"]];
    }
}


@end
