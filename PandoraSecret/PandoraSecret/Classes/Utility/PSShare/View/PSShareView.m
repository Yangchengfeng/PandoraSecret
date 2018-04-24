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
#import "PSShareCollectionViewCell.h"
#import "WeiboSDK.h"

static NSString *cellId = @"PSShareCollectionViewCell";

@interface PSShareView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout >

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containView; //背景View(包裹各种元素的view)
@property (nonatomic, weak) UIViewController *presentVC;

@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UICollectionView *shareCollectionView;
@property (nonatomic, strong) UICollectionView *functionCollectionView;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSArray *shareItems;
@property (nonatomic, strong) NSArray *functionItems;
@property (nonatomic, strong) NSDictionary *shareDict;
@property (nonatomic, strong) NSDictionary *functionDict;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation PSShareView

- (NSDictionary *)shareDict {
    if(!_shareDict) {
        _shareDict = @{
                       @"weibo": @"微博",
                       @"sms": @"短信",
                       @"QQ":@"QQ",
                       @"wechat": @"微信",
                       @"email": @"邮件",
                       @"renren": @"人人网",
                       @"facebook": @"Facebook",
                       };
    }
    return _shareDict;
}

- (NSDictionary *)functionDict {
    if(!_functionDict) {
        _functionDict = @{
                          @"copy": @"复制",
                          @"complaint": @"投诉",
                          @"collection": @"收藏",
                          };
    }
    return _functionDict;
}

- (instancetype)initWithshareViewFrame:(CGRect)frame ShareItems:(NSArray *)shareItems functionItems:(NSArray *)functionItems itemSize:(CGSize)itemSize {
    
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
        
        // 分享
        if(hasThirdpart) {
            UICollectionViewFlowLayout *shareLayout = [[UICollectionViewFlowLayout alloc] init];
            shareLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            shareLayout.itemSize = CGSizeMake(frame.size.width, itemSize.height);
            _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, itemsHeight) collectionViewLayout:shareLayout];
            _shareCollectionView.delegate = self;
            _shareCollectionView.dataSource = self;
            _shareCollectionView.showsVerticalScrollIndicator = NO;
            _shareCollectionView.showsHorizontalScrollIndicator = YES;
            _shareCollectionView.bounces = YES;
            _shareCollectionView.backgroundColor = [UIColor whiteColor];
            [_shareCollectionView registerClass:[PSShareCollectionViewCell class] forCellWithReuseIdentifier:cellId];
            [_containView addSubview:_shareCollectionView];
        }
        // 其他功能
        if(hasOtherFunction) {
            UICollectionViewFlowLayout *functionLayout = [[UICollectionViewFlowLayout alloc] init];
            functionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            functionLayout.itemSize = CGSizeMake(frame.size.width, itemSize.height);
            if(hasThirdpart) {
                _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, itemsHeight+lineViewH, frame.size.width, itemsHeight) collectionViewLayout:functionLayout];
            } else {
                _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, itemsHeight) collectionViewLayout:functionLayout];
            }
            _functionCollectionView.delegate = self;
            _functionCollectionView.dataSource = self;
            _functionCollectionView.showsVerticalScrollIndicator = NO;
            _functionCollectionView.showsHorizontalScrollIndicator = YES;
            _functionCollectionView.bounces = NO;
            _functionCollectionView.backgroundColor = [UIColor whiteColor];
            [_functionCollectionView registerClass:[PSShareCollectionViewCell class] forCellWithReuseIdentifier:cellId];
            [_containView addSubview:_functionCollectionView];
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
    PSShareCollectionViewCell *cell = (PSShareCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (collectionView == self.shareCollectionView) {
        [cell.itemImage setImage:[UIImage imageNamed:_shareItems[indexPath.item]]];
        cell.itemTitle.text = [self.shareDict objectForKey:_shareItems[indexPath.item]];
    } else {
        [cell.itemImage setImage:[UIImage imageNamed:_functionItems[indexPath.item]]];
        cell.itemTitle.text = [self.functionDict objectForKey:_functionItems[indexPath.item]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.shareCollectionView) {
        switch (indexPath.row) {
            case 0: {// 微博
//                BOOL isInstall = [WeiboSDK isWeiboAppInstalled];
                BOOL isInstall = [WeiboSDK openWeiboApp];
                if(!isInstall) {
                    [SVProgressHUD showErrorWithStatus:@"请先安装微博客户端!"];
                    return;
                }
                [self shareWithText:@"啦啦啦啦" desc:@"成双成对" image:[UIImage imageNamed:@"star"]];
            }
            default:
                [SVProgressHUD showImage:[UIImage imageNamed:@"sorry"] status:@"功能需要通过appStore审核才能使用"];
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                break;
                
            default:
                [SVProgressHUD showImage:[UIImage imageNamed:@"sorry"] status:@"小仙女正在紧急开发，请期待"];
                break;
        }
    }
}

- (void)shareWithText:(NSString *)text desc:(NSString *)desc image:(UIImage *)image{
        WBMessageObject *message = [WBMessageObject message];
        message.text = [NSString stringWithFormat:@"【PandoraSecret】好友分享：%@ - %@", text, desc];
    
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(image, 1.0); // 图片大小有要求
        message.imageObject = imageObject;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

@end
