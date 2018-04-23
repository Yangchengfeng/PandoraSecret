//
//  PSHomeViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/10.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeViewController.h"
#import "PSHomeCarousel.h"
#import "PSHomeGoodsCell.h"
#import "PSHomeCarouselItem.h"
#import "PSHomeProductListItem.h"
#import "PSGoodsDetailViewController.h"
#import "PSHomeHeaderView.h"

static NSString *headerId = @"homeHeaderId";
static NSString *goodsId = @"homeGoodsId";
static NSString *productList = @"product/list";
static CGFloat carouseH = 150.f;
static CGFloat marginLabelH = 15.f;

@interface PSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionReusableView *homeHeaderView;
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, copy) NSMutableArray *productListArr;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PSHomeViewController

- (UICollectionView *)goodsCollectionView {
    if(!_goodsCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = YES;
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        [_goodsCollectionView registerClass:[PSHomeGoodsCell class] forCellWithReuseIdentifier:goodsId];
        [_goodsCollectionView registerClass:[PSHomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    }
    return _goodsCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.goodsCollectionView];
    
    [self loadProductListWithProductListURL:productList];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PSHomeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        reusableView = header;
    }
    return reusableView;
}

- (void)loadProductListWithProductListURL:(NSString *)url {
    __weak typeof(self) weakSelf = self;
    _productListArr = [NSMutableArray array];
    NSDictionary *param = @{@"page":@1,
                            @"pageSize":@10
                            };
    [PSNetoperation getRequestWithConcretePartOfURL:url parameter:param success:^(id responseObject) {
        NSDictionary *goodsInfo = responseObject[@"data"];
        NSArray *productList = goodsInfo[@"list"];
        for(NSDictionary *dict in productList) {
            PSHomeProductListItem *homeProductListItem = [PSHomeProductListItem homeProductListItemWithDict:dict];
            [_productListArr addObject:homeProductListItem];
            [weakSelf.goodsCollectionView reloadData];
        }
    } andError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载出错，请稍后再试~~~"];
    }];
}

#pragma mark - 数据源设置
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _productListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSHomeGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsId forIndexPath:indexPath];
    if(_productListArr.count > 0) {
        cell.productListItem = _productListArr[indexPath.item];
    } else {
        NSDictionary *dict = @{@"tradeItemId":@"-1",
                               @"name": @"errorlink",
                               @"title": @"暂无相关信息",
                               @"category": @"unknown",
                               @"status":@"-1",
                               @"stock":@"0",
                               @"sale":@"0",
                               @"shopId": @"0",
                               @"image": @"",
                               @"price": @"0",
                               };
        PSHomeProductListItem *homeProductItem = [PSHomeProductListItem homeProductListItemWithDict:dict];
        cell.productListItem = homeProductItem;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat goodsW = (kScreenWidth-30)/2.0;
    return CGSizeMake(goodsW, goodsW + 60.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 10, 2, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, carouseH+marginLabelH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PSGoodsDetailViewController *vc = [[PSGoodsDetailViewController alloc] init];
    PSHomeProductListItem *item = _productListArr[indexPath.item];
    vc.tradeItemId = item.tradeItemId;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end

