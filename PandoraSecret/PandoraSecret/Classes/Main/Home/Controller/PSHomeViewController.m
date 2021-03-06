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
#import "PSWebViewController.h"

static NSString *headerId = @"homeHeaderId";
static NSString *goodsId = @"homeGoodsId";
static NSString *productList = @"product/list";
static NSString *homeBeginDrag = @"homeVCBeginDrag";
static NSString *homeEndDrag = @"homeVCEndDrag";
static NSString *homeVCBeginDragToRemove = @"homeVCBeginDragToRemove";
static CGFloat marginViewH = 38.f;

@interface PSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PSHomeHeaderViewDelegate>

@property (nonatomic, strong) UICollectionReusableView *homeHeaderView;
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, copy) NSMutableArray *productListArr;

@end

@implementation PSHomeViewController

- (UICollectionView *)goodsCollectionView {
    if(!_goodsCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.showsVerticalScrollIndicator = YES;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
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
    
    // 对用户选择进行保存
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"fancyBtnTag"];
    
    [self loadProductListWithProductListURL:productList];
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
    cell.fancyBtn.tag = indexPath.item;
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
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kScreenWidth/25.*14+marginViewH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PSGoodsDetailViewController *vc = [[PSGoodsDetailViewController alloc] init];
    PSHomeProductListItem *item = _productListArr[indexPath.item];
    vc.tradeItemId = item.tradeItemId;
    vc.view.backgroundColor = kColorRGBA(255, 255, 255, 0.98);
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PSHomeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        header.delegate = self;
        reusableView = header;
    }
    return reusableView;
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

#pragma mark - 轮播图跳转网页
- (void)enterWebView:(NSString *)webViewLink {
    PSWebViewController *vc = [[PSWebViewController alloc] init];
    vc.webLink = webViewLink;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 计时器添加与删除、去掉遮罩

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate { // 通知
    NSNotification *notification =[NSNotification notificationWithName:homeEndDrag object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSNotification *notification =[NSNotification notificationWithName:homeBeginDrag object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:homeVCBeginDragToRemove object:nil userInfo:nil]];
}

@end

