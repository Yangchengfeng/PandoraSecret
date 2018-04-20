//
//  PSShowGradeStarView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/20.
//  Copyright © 2018年 chengfengYang. All rights reserved.
// 

#import "PSShowGradeStarView.h"

static NSInteger starBeginWithIdx = 0;

@interface PSShowGradeStarView ()

//@property (nonatomic, assign) NSInteger selectedStars;
//@property (nonatomic, assign) NSInteger totalStars;
//@property (nonatomic, assign) CGSize starSize;

@end

@implementation PSShowGradeStarView

- (id)initWithFrame:(CGRect)frame selectedStars:(NSInteger)selectedStars totalStars:(NSInteger)totalStars starSize:(CGSize)starSize optional:(BOOL)optional {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildStarsWithSelectedStars:selectedStars totalStars:totalStars starSize:starSize optional:optional];
    }
    return self;
}

- (void)buildStarsWithSelectedStars:(NSInteger)selectedStars totalStars:(NSInteger)totalStars starSize:(CGSize)starSize optional:(BOOL)optional {
    // 容错处理
    NSInteger viableSelectedStars = selectedStars%(totalStars+1);
    CGFloat starDistance = (self.frame.size.width - totalStars * starSize.width)/(totalStars - 1);
    CGFloat starW = starDistance>=0 ? starSize.width : self.frame.size.width/totalStars;
    CGFloat starY = (self.frame.size.height - starSize.height)/2.;
    // 星星设置
    for (int idx = 0; idx<totalStars; idx++) {
        UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [starBtn setFrame:CGRectMake((starSize.width+starDistance)*idx, starY, starW, starSize.height)];
        [starBtn setImage:[UIImage imageNamed:@"star_none_click"] forState:UIControlStateNormal];
        [starBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateSelected];
        if(idx<viableSelectedStars) {
            starBtn.selected = YES;
        } else {
            starBtn.selected = NO;
        }
        starBtn.userInteractionEnabled = optional;
        [self addSubview:starBtn];
    }
}

#pragma mark - 点击评分

- (id)initWithFrame:(CGRect)frame totalStars:(NSInteger)totalStars starSize:(CGSize)starSize optional:(BOOL)optional {
    return [self initWithFrame:frame selectedStars:0 totalStars:totalStars starSize:starSize optional:optional];
}

@end
