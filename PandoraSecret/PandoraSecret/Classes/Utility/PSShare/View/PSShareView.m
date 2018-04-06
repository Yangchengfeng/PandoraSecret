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

@property (nonatomic, strong) UIView *containView; //背景View(包裹各种元素的view)
@property (nonatomic, weak) UIViewController *presentVC;

@end

@implementation PSShareView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        UIControl *maskView = [[UIControl alloc] initWithFrame:frame];
        maskView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        maskView.tag = 100;
        [maskView addTarget:self action:@selector(maskViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:maskView];
        
        _containView = [[UIView alloc] init];
        _containView.userInteractionEnabled = YES;
        [self addSubview:_containView];
    }
    return self;
}

- (void)showOnController:(UIViewController *)controller{
    _presentVC = controller;
    [controller.view.window addSubview:self];
}

- (void)dismiss:(BOOL)animated{
    if (animated) {
        [self tappedCancel];
    }else{
        [self removeFromSuperview];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //计算总高度
    float height = 200;
    
    //动画前置控件位置
    if (_containView) {
        _containView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, height);
        _containView.backgroundColor = [UIColor redColor];
    }
    
    UIView *maskView = (UIView *)[self viewWithTag:100];
    maskView.alpha = 0;
    //执行动画
    [UIView animateWithDuration:0.25 animations:^{
        if (_containView) {
            _containView.frame = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
        }
        
        maskView.alpha = 0.6;
        
    } completion:nil];
    
}

- (void)maskViewClick:(UIControl *)sender {
    [self tappedCancel];
}

- (void)tappedCancel {
    [UIView animateWithDuration:0.25 animations:^{
        UIView *zhezhaoView = (UIView *)[self viewWithTag:100];
        zhezhaoView.alpha = 0;
        
        if (_containView) {
            _containView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _containView.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
