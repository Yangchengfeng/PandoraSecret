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

@interface PSShareView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containView; //背景View(包裹各种元素的view)
@property (nonatomic, weak) UIViewController *presentVC;

@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UICollectionView *shareCollectionView;
@property (nonatomic, strong) UICollectionView *functionCollectionView;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSDictionary *shareItems;
@property (nonatomic, strong) NSDictionary *functionItems;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation PSShareView

- (instancetype)initWithshareViewFrame:(CGRect)frame ShareItems:(NSDictionary *)shareItems functionItems:(NSDictionary *)functionItems itemSize:(CGSize)itemSize {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.shareItems = shareItems;
        self.functionItems = functionItems;
        self.itemSize = itemSize;
        
        BOOL hasThirdpart = (shareItems.count>0) ? YES : NO;
        BOOL hasOtherFunction = (functionItems.count>0) ? YES : NO;
        
        CGFloat lineViewL = 15.f;
        CGFloat lineViewH = 1.f;
        CGFloat cancelBtnH = 44.f;
        CGFloat itemsHeight = itemSize.height;
        CGFloat containViewH =  itemsHeight + lineViewH + cancelBtnH; // 默认最少有一项
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
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = itemSize;
        
        // 分享
        if(hasThirdpart) {
            _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, itemsHeight) collectionViewLayout:flowLayout];
            _shareCollectionView.delegate = self;
            _shareCollectionView.dataSource = self;
            _shareCollectionView.showsVerticalScrollIndicator = NO;
            _shareCollectionView.showsHorizontalScrollIndicator = YES;
            _shareCollectionView.bounces = NO;
            _shareCollectionView.backgroundColor = [UIColor clearColor];
            [_shareCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
            [_containView addSubview:_shareCollectionView];
        }
        // 其他功能
        if(hasOtherFunction) {
            if(hasThirdpart) {
                _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, itemsHeight+lineViewH, frame.size.width, itemsHeight) collectionViewLayout:flowLayout];
            } else {
                _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, itemsHeight) collectionViewLayout:flowLayout];
            }
            _functionCollectionView.delegate = self;
            _functionCollectionView.dataSource = self;
            _functionCollectionView.showsVerticalScrollIndicator = NO;
            _functionCollectionView.showsHorizontalScrollIndicator = YES;
            _functionCollectionView.bounces = NO;
            _functionCollectionView.backgroundColor = [UIColor clearColor];
            [_functionCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
            [_functionCollectionView addSubview:_shareCollectionView];
        }
        
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

- (void)dismiss:(BOOL)animated{
    if (animated) {
        [self tappedCancel];
    }else{
        [self removeFromSuperview];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.shareCollectionView) {
        return self.shareItems.count;
    }
    if (collectionView == self.functionCollectionView) {
        return self.functionItems.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss:YES];
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

@end
