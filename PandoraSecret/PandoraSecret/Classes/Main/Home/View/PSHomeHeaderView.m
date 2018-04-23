//
//  PSHomeHeaderView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/23.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSHomeHeaderView.h"
#import "PSHomeCarousel.h"
#import "PSHomeCarouselItem.h"

static NSString *carouselId = @"homeCarouselId";
static NSString *bannerQuery = @"banner/query";
static NSString *homeBeginDrag = @"homeVCBeginDrag";
static NSString *homeEndDrag = @"homeVCEndDrag";
static CGFloat marginViewH = 38.f;

#define kCarouseH kScreenWidth/25.*14

@interface PSHomeHeaderView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *homeCarousel;
@property (nonatomic, strong) UIView *marginView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSMutableArray *homeCarouselArr;

@end

@implementation PSHomeHeaderView

- (UICollectionView *)homeCarousel {
    if(!_homeCarousel) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _homeCarousel = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCarouseH) collectionViewLayout:layout];
        _homeCarousel.backgroundColor = [UIColor whiteColor];
        _homeCarousel.pagingEnabled = YES;
        _homeCarousel.showsVerticalScrollIndicator = NO;
        _homeCarousel.showsHorizontalScrollIndicator = NO;
        _homeCarousel.delegate = self;
        _homeCarousel.dataSource = self;
        [_homeCarousel registerClass:[PSHomeCarousel class] forCellWithReuseIdentifier:carouselId];
    }
    return _homeCarousel;
}

- (UIView *)marginView {
    if(!_marginView) {
        _marginView = [[UIView alloc] initWithFrame:CGRectMake(0, kCarouseH, kScreenWidth, marginViewH)];
        _marginView.backgroundColor = [UIColor whiteColor];
        
        UIView *marginSubView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
        marginSubView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_marginView addSubview:marginSubView];
        
        UIButton *marginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, kScreenWidth, 30)];
        marginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [marginBtn setTitle:@"猜你喜欢" forState:UIControlStateNormal];
        [marginBtn setImage:[UIImage imageNamed:@"guessUlike"] forState:UIControlStateNormal];
        [marginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        [marginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [marginBtn setTitleColor:kPandoraSecretColor forState:UIControlStateNormal];
        [_marginView addSubview:marginBtn];
    }
    return _marginView;
}

- (NSMutableArray *)homeCarouselArr {
    if(!_homeCarouselArr) {
        _homeCarouselArr = [NSMutableArray array];
    }
    return _homeCarouselArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        [self addTimer];
        [self addSubview:self.homeCarousel];
        [self addSubview:self.marginView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTimer) name:@"homeVCBeginDrag" object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTimer) name:@"homeVCEndDrag" object:nil];
        
        [self loadBannerInfoWithBannerURL:bannerQuery];
    }
    return self;
}

- (void)loadBannerInfoWithBannerURL:(NSString *)url{
    __weak typeof(self) weakSelf = self;
    [PSNetoperation getRequestWithConcretePartOfURL:url parameter:nil success:^(id responseObject) {
        NSArray *carouselGoods = responseObject[@"data"];
        for(NSDictionary *dict in carouselGoods) {
            PSHomeCarouselItem *homeCarouselItem = [PSHomeCarouselItem HomeCarouselWithDict:dict];
            [self.homeCarouselArr addObject:homeCarouselItem];
        }
        [weakSelf.homeCarousel reloadData];
    } andError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载出错，请稍后再试~~~"];
    }];
}

#pragma mark - 数据源设置
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    if(self.homeCarouselArr.count>0) {
        return self.homeCarouselArr.count;
    }
    return 5;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, kCarouseH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PSHomeCarouselItem *item = _homeCarouselArr[indexPath.item];
    if([self.delegate respondsToSelector:@selector(enterWebView:)]) {
        [self.delegate enterWebView:item.link];
    }
}

#pragma mark - 计时器

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

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

@end
