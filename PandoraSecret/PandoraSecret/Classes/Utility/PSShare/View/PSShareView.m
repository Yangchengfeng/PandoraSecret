//
//  PSShareView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/6.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//  选择功能框：
//  1、分享：QQ、微博、短信
//  2、其他功能：收藏、复制、投诉

#import "PSShareView.h"

@interface PSShareView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containView; //背景View(包裹各种元素的view)
@property (nonatomic, weak) UIViewController *presentVC;

@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation PSShareView

- (instancetype)initWithshareViewFrame:(CGRect)frame itemsHeight:(CGFloat)itemsHeight hasThirdpart:(BOOL)hasThirdpart andOtherFunction:(BOOL)hasOtherFunction {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat lineViewL = 15.f;
        CGFloat lineViewH = 1.f;
        CGFloat cancelBtnH = 44.f;
        CGFloat containViewH =  itemsHeight + lineViewH + cancelBtnH;
        if(hasThirdpart && hasOtherFunction) {
            containViewH = itemsHeight * 2 + lineViewH * 2 + cancelBtnH;
        }
        
        UIControl *backgroundView = [[UIControl alloc] initWithFrame:frame];
        backgroundView.backgroundColor = kPandoraSecretMaskColor;
        backgroundView.tag = 100;
        
        [backgroundView addTarget:self action:@selector(maskViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundView];
        
        _containView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-containViewH, kScreenWidth, containViewH)];
        _containView.userInteractionEnabled = YES;
        _containView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containView];
        
        // 分享
        
        // 其他功能
        
        _firstLineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewL, itemsHeight, frame.size.width-lineViewL*2, lineViewH)];
        _firstLineView.backgroundColor = kPandoraSecretLineColor;
        [_containView addSubview:_firstLineView];
        
        if(hasThirdpart && hasOtherFunction) {
            _secondLineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewL, itemsHeight*2+lineViewH, frame.size.width-lineViewL*2, lineViewH)];
            _secondLineView.backgroundColor = kPandoraSecretLineColor;
            [_containView addSubview:_secondLineView];
        }
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, containViewH-cancelBtnH, frame.size.width, cancelBtnH);
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kPandoraSecretColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
        [_containView addSubview:_cancelBtn];
        
    }
    return self;
}

- (void)showOnController:(UIViewController *)controller{
    _presentVC = controller;
    [controller.view.window addSubview:self];
}

- (void)maskViewClick:(UIControl *)sender {
    [self tappedCancel];
}

- (void)tappedCancel {
    [UIView animateWithDuration:0.15 animations:^{
        UIView *maskView = (UIView *)[self viewWithTag:100];
        maskView.alpha = 0;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
