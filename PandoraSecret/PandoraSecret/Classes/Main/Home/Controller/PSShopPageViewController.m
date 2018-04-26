//
//  PSShopPageViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/23.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShopPageViewController.h"
#import "PSGoodsDetailViewController.h"
#import "PSHomeGoodsCell.h"
#import "PSHomeProductListItem.h"
#import "PSShopHeaderView.h"

static NSString *shopQuery = @"shop/query";
static NSString *goodsCell = @"goodsCell";

@interface PSShopPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, PSShopHeaderViewDelegate>

@property (nonatomic, strong) UICollectionView *shopListView;
@property (nonatomic, strong) PSShopHeaderView *shopHeaderView;
@property (nonatomic, assign) PSNoDataViewType noDataType;
@property (nonatomic, copy) NSMutableArray *goodsArr;

@end

@implementation PSShopPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shopHeaderView = [[NSBundle mainBundle] loadNibNamed:@"PSShopHeaderView" owner:nil options:nil].firstObject;
    _shopHeaderView.delegate = self;
    [self.view addSubview:_shopHeaderView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _shopListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_shopHeaderView.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(_shopHeaderView.frame)) collectionViewLayout:layout];
    _shopListView.delegate = self;
    _shopListView.backgroundColor = [UIColor whiteColor];
    _shopListView.showsVerticalScrollIndicator = YES;
    _shopListView.showsHorizontalScrollIndicator = NO;
    _shopListView.delegate = self;
    _shopListView.dataSource = self;
    [_shopListView registerClass:[PSHomeGoodsCell class] forCellWithReuseIdentifier:goodsCell];
    [self.view addSubview:_shopListView];
    
    [_shopListView bringSubviewToFront:_shopHeaderView];
    
    [self queryGoodsDetail];
}

- (void)queryGoodsDetail {
    _goodsArr = [NSMutableArray array];
    NSDictionary *param = @{@"shopId":@(_shopId)};
    [PSNetoperation getRequestWithConcretePartOfURL:shopQuery parameter:param success:^(id responseObject) {
        PSShopDetailModel *shopDetailModel = [PSShopDetailModel shopDetailWithDict:responseObject[@"data"]];
        for(NSDictionary *dict in responseObject[@"data"][@"pros"]) {
            [_goodsArr addObject:[PSHomeProductListItem homeProductListItemWithDict:dict]];
        }
        _shopHeaderView.shopHeaderModel = shopDetailModel;
        [_shopListView reloadData];
    } failure:^(id failure) {
        _noDataType = PSNoDataViewTypeFailure;
    } andError:^(NSError *error) {
        _noDataType = PSNoDataViewTypeError;
    }];
}

#pragma mark - 数据源设置
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _goodsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSHomeGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCell forIndexPath:indexPath];
    cell.fancyBtn.tag = indexPath.item;
    if(_goodsArr.count > 0) {
        cell.productListItem = _goodsArr[indexPath.item];
    } else {
        NSDictionary *dict = @{@"tradeItemId":@"-1",
                               @"name": @"errorlink",
                               @"title": @"暂无相关信息",
                               @"category": @"unknown",
                               @"status":@"-1",
                               @"stock":@"0",
                               @"sale":@"0",
                               @"shopId": @"0",
                               @"mainImage": @"",
                               @"price": @"0",
                               @"subImages":@[]
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PSGoodsDetailViewController *vc = [[PSGoodsDetailViewController alloc] init];
    PSHomeProductListItem *item = _goodsArr[indexPath.item];
    vc.tradeItemId = item.tradeItemId;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
