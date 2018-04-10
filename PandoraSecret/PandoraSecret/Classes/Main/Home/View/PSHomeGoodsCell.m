//
//  PSHomeGoodsCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/11.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeGoodsCell.h"
#import "PSFancyBtn.h"

static CGFloat fancyBtnH = 50.f;

@interface PSHomeGoodsCell ()

@property (nonatomic, strong) UIView *maskView;

@end

@implementation PSHomeGoodsCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSHomeGoodsCell" owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)userFancy:(id)sender {
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = kPandoraSecretMaskColor;
    
    [self addFancyBtn];
    
    [self addSubview:_maskView];
}

- (void)addFancyBtn {
    CGFloat cellW = self.frame.size.width;
    CGFloat cellH = self.frame.size.height;
    CGRect likeBtnFrame = CGRectMake(cellW/2.-fancyBtnH/2., (cellH - 2*fancyBtnH)/3., fancyBtnH, fancyBtnH);
    PSFancyBtn *likeBtn = [[PSFancyBtn alloc] initWithFrame:likeBtnFrame backgroundColor:kPandoraSecretColor title:@"心水品" font:8 imageName:@"home_like"];
    CGRect dislikeBtnFrame = CGRectMake(cellW/2.-fancyBtnH/2., (cellH - 2*fancyBtnH)/3.*2+fancyBtnH, fancyBtnH, fancyBtnH);
    PSFancyBtn *dislikeBtn = [[PSFancyBtn alloc] initWithFrame:dislikeBtnFrame backgroundColor:kColorRGBA(18, 50, 219, 1) title:@"不喜欢" font:10 imageName:@"home_dislike"];

    [_maskView addSubview:likeBtn];
    [_maskView addSubview:dislikeBtn];
}

@end
