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

static NSString *carouselId = @"homeCarouselId";
static NSString *goodsId = @"homeGoodsId";
static NSString *bannerQuery = @"banner/query";
static NSString *productList = @"product/list";
static CGFloat carouseH = 150.f;

@interface PSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *goodsCollectionView;
@property (strong, nonatomic) UICollectionView *homeCarousel;
@property (nonatomic, copy) NSMutableArray *homeCarouselArr;
@property (nonatomic, copy) NSMutableArray *productListArr;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PSHomeViewController

- (UICollectionView *)homeCarousel {
    if(!_homeCarousel) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _homeCarousel = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, carouseH) collectionViewLayout:layout];
        _homeCarousel.backgroundColor = [UIColor whiteColor];
        _homeCarousel.pagingEnabled = YES;
        _homeCarousel.showsVerticalScrollIndicator = NO;
        _homeCarousel.showsHorizontalScrollIndicator = NO;
        _homeCarousel.delegate = self;
        _homeCarousel.dataSource = self;
        [self.homeCarousel registerClass:[PSHomeCarousel class] forCellWithReuseIdentifier:carouselId];
    }
    return _homeCarousel;
}

- (UICollectionView *)goodsCollectionView {
    if(!_goodsCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - carouseH - 15 - 2) collectionViewLayout:layout];
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
         [_goodsCollectionView registerClass:[PSHomeGoodsCell class] forCellWithReuseIdentifier:goodsId];
    }
    return _goodsCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [self addTimer];

    [self loadBannerInfoWithBannerURL:bannerQuery];
    [self loadProductListWithProductListURL:productList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return carouseH;
    }
    return kScreenHeight-carouseH-15 - 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0.0;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    label.text = @"-> 猜你喜欢 <-";
    label.textColor = kPandoraSecretColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        NSString *cellId = @"carouselId";
        UITableViewCell *carouselCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(!carouselCell) {
           carouselCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        for (UIView *view in carouselCell.subviews) {
            [view removeFromSuperview];
        }
        [carouselCell addSubview:self.homeCarousel];
        return carouselCell;
    }
    NSString *cellId = @"productId";
    UITableViewCell *productCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!productCell) {
        productCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in productCell.subviews) {
        [view removeFromSuperview];
    }
    [productCell addSubview:self.goodsCollectionView];
    return productCell;
}


- (void)loadBannerInfoWithBannerURL:(NSString *)url{
    __weak typeof(self) weakSelf = self;
    _homeCarouselArr = [NSMutableArray array];
    [PSNetoperation getRequestWithConcretePartOfURL:url parameter:nil success:^(id responseObject) {
        NSArray *carouselGoods = responseObject[@"data"];
        for(NSDictionary *dict in carouselGoods) {
            PSHomeCarouselItem *homeCarouselItem = [PSHomeCarouselItem HomeCarouselWithDict:dict];
            [_homeCarouselArr addObject:homeCarouselItem];
            [weakSelf.homeCarousel reloadData];
        }
    } andError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载出错，请稍后再试~~~"];
    }];
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

//#pragma mark - 数据源设置
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _homeCarousel) {
        if(_homeCarouselArr.count>0) {
            return _homeCarouselArr.count;
        }
        return 5;
    }
    if(_productListArr.count>0) {
        return _productListArr.count;
    }
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == _homeCarousel) {
        PSHomeCarousel *homeCarouselCell = [collectionView dequeueReusableCellWithReuseIdentifier:carouselId forIndexPath:indexPath];
        if(_homeCarouselArr.count > 0) { // 容错处理
            homeCarouselCell.pageControl.numberOfPages = _homeCarouselArr.count;
            homeCarouselCell.homeCarouselItem = _homeCarouselArr[indexPath.item];
        } else {
            homeCarouselCell.pageControl.numberOfPages = 5;
            NSDictionary *dict = @{@"id":@"-1",
                                   @"link": @"errorlink",
                                   @"image": @"",
                                   @"category": @"unknown"
                                   };
            PSHomeCarouselItem *carouselItem = [PSHomeCarouselItem HomeCarouselWithDict:dict];
            homeCarouselCell.homeCarouselItem = carouselItem;
        }
        homeCarouselCell.pageControl.currentPage = indexPath.item;
        return homeCarouselCell;
    }
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
    if(collectionView == _homeCarousel) {
        return CGSizeMake(kScreenWidth, carouseH);
    }
    CGFloat goodsW = (kScreenWidth-30)/2.0;
    return CGSizeMake(goodsW, goodsW + 55.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(collectionView == _homeCarousel) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(2, 10, 2, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma mark - 添加计时器
- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage {
    NSIndexPath *currrentIndexPath = [[self.homeCarousel indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currrentIndexPath.item inSection:0];

    NSInteger nextItem = currentIndexPathReset.item + 1;
    if((_homeCarouselArr.count > 0 && nextItem == _homeCarouselArr.count) || (_homeCarouselArr.count <= 0 && nextItem == 5)) {
        nextItem = 0;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];

    [self.homeCarousel scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

#pragma mark - 去掉计时器
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

