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

static NSString *carouselId = @"homeCarouselId";
static NSString *goodsId = @"homeGoodsId";
static CGFloat carouseH = 150.f;
static NSString *bannerQuery = @"banner/query";

@interface PSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *goodsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *homeCarousel;
@property (nonatomic, copy) NSMutableArray *homeCarouselArr;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadBannerInfoWithBannerURL:bannerQuery];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _homeCarousel.collectionViewLayout = layout;
    _homeCarousel.backgroundColor = [UIColor whiteColor];
    _homeCarousel.pagingEnabled = YES;
    _homeCarousel.showsVerticalScrollIndicator = NO;
    _homeCarousel.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_homeCarousel];
    
    _homeCarousel.delegate = self;
    _homeCarousel.dataSource = self;
    _goodsCollectionView.delegate = self;
    _goodsCollectionView.dataSource = self;
    
    [self.homeCarousel registerClass:[PSHomeCarousel class] forCellWithReuseIdentifier:carouselId];
    [_goodsCollectionView registerClass:[PSHomeGoodsCell class] forCellWithReuseIdentifier:goodsId];
    
    [self addTimer];
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

#pragma mark - 数据源设置

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
    return 20;
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
    return UIEdgeInsetsMake(2,10, 2, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - 添加计时器
- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage {
    NSIndexPath *currrentIndexPath = [[_homeCarousel indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currrentIndexPath.item inSection:0];

    NSInteger nextItem = currentIndexPathReset.item + 1;
    if(nextItem == _homeCarouselArr.count) {
        nextItem = 0;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
    
    [_homeCarousel scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
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


@end
