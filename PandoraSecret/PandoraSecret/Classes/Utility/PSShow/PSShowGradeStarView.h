//
//  PSShowGradeStarView.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/20.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSShowGradeStarViewDelegate <NSObject>

- (void)finalGradeWithSelectedStarIdx:(NSInteger)starsIdx;

@end

@interface PSShowGradeStarView : UIView

@property (nonatomic, assign) NSInteger selectedStars;
@property (nonatomic, assign) id<PSShowGradeStarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame selectedStars:(NSInteger)selectedStars totalStars:(NSInteger)totalStars starSize:(CGSize)starSize optional:(BOOL)optional;
- (void)buildStarsWithSelectedStars:(NSInteger)selectedStars totalStars:(NSInteger)totalStars starSize:(CGSize)starSize optional:(BOOL)optional;

@end
