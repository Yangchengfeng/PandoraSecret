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
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *decs;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@end

@implementation PSHomeGoodsCell

- (void)setProductListItem:(PSHomeProductListItem *)productListItem {
    _productListItem = productListItem;
    [_image sd_setImageWithURL:[NSURL URLWithString:productListItem.mainImage] placeholderImage:[UIImage imageNamed:@"image_view_placeholder_small"]];
    _decs.text = [NSString stringWithFormat:@"%@-%@", _productListItem.name, _productListItem.title];
    _saleLabel.text = [NSString stringWithFormat:@"%ld人付款", _productListItem.sale];
    _price.text = [NSString stringWithFormat:@"￥%ld", _productListItem.price];
}

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
    PSFancyBtn *likeBtn = [[PSFancyBtn alloc] initWithFrame:likeBtnFrame backgroundColor:kPandoraSecretColor title:@"心水品" font:10 imageName:@"home_like"];
    [likeBtn addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect dislikeBtnFrame = CGRectMake(cellW/2.-fancyBtnH/2., (cellH - 2*fancyBtnH)/3.*2+fancyBtnH, fancyBtnH, fancyBtnH);
    PSFancyBtn *dislikeBtn = [[PSFancyBtn alloc] initWithFrame:dislikeBtnFrame backgroundColor:kColorRGBA(18, 50, 219, 1) title:@"不喜欢" font:10 imageName:@"home_dislike"];
    [dislikeBtn addTarget:self action:@selector(dislike) forControlEvents:UIControlEventTouchUpInside];

    [_maskView addSubview:likeBtn];
    [_maskView addSubview:dislikeBtn];
}

- (void)like {
    // 保存喜欢进行智能推荐
    [_maskView removeFromSuperview];
}

- (void)dislike {
    // 保存不喜欢进行智能推荐
    [_maskView removeFromSuperview];
}

@end
