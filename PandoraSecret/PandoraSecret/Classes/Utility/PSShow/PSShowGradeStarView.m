//
//  PSShowGradeStarView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/20.
//  Copyright © 2018年 chengfengYang. All rights reserved.
// 

#import "PSShowGradeStarView.h"

@implementation PSShowGradeStarView

- (void)setSelectedStars:(NSInteger)selectedStars {
    for(UIButton *btn in self.subviews) {
        if(btn.tag < selectedStars) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

- (id)initWithFrame:(CGRect)frame selectedStars:(NSInteger)selectedStars totalStars:(NSInteger)totalStars starSize:(CGSize)starSize optional:(BOOL)optional {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildStarsWithSelectedStars:selectedStars totalStars:totalStars starSize:starSize optional:optional];
    }
    return self;
}

// 不传frame创建方式：xib等
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
        starBtn.tag = idx;
        starBtn.userInteractionEnabled = optional;
        if(optional) {
            [starBtn addTarget:self action:@selector(clickStarBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:starBtn];
    }
}


- (void)clickStarBtn:(UIButton *)selectedStar{
    for(UIButton *btn in self.subviews) {
        if(btn.tag < selectedStar.tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(finalGradeWithSelectedStarIdx:)]) {
        [self.delegate finalGradeWithSelectedStarIdx:selectedStar.tag];
    }
}

@end
