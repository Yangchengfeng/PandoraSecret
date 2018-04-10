//
//  PSHomeViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/10.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeViewController.h"
#import "PSHomeCarousel.h"

static NSString *carouselId = @"homeCarouselId";
static NSString *goodsId = @"homeGoodsId";
static CGFloat carouseH = 150.f;
static CGFloat goodsH = 150.f;

@interface PSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *homeCarousel;

@end

@implementation PSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _homeCarousel.collectionViewLayout = layout;
    _homeCarousel.backgroundColor = [UIColor whiteColor];
    _homeCarousel.pagingEnabled = YES;
    _homeCarousel.showsVerticalScrollIndicator = NO;
    _homeCarousel.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_homeCarousel];
    
    _homeCarousel.delegate = self;
    _homeCarousel.dataSource = self;
    _goodsCollectionView.delegate = self;
    _goodsCollectionView.dataSource = self;
    
    [self.homeCarousel registerClass:[PSHomeCarousel class] forCellWithReuseIdentifier:carouselId];
    [_goodsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:goodsId];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _homeCarousel) {
        return 5;
    }
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == _homeCarousel) {
        PSHomeCarousel *homeCarouselCell = [collectionView dequeueReusableCellWithReuseIdentifier:carouselId forIndexPath:indexPath];
        homeCarouselCell.pageControl.currentPage = indexPath.item;
        return homeCarouselCell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsId forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == _homeCarousel) {
        return CGSizeMake(kScreenWidth, carouseH);
    }
    return CGSizeMake((kScreenWidth-15)/2.0, goodsH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

@end
