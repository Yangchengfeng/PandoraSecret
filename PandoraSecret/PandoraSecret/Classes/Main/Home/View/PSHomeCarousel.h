//
//  PSHomeCarousel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/9.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSHomeCarouselItem.h"

@interface PSHomeCarousel : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) PSHomeCarouselItem *homeCarouselItem;

@end
