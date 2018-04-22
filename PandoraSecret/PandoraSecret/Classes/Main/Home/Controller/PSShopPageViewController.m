//
//  PSShopPageViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/23.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShopPageViewController.h"
#import "PSShowGradeStarView.h"
#import "PSShopDetailModel.h"
#import "PSGoodsDetailViewController.h"
#import "PSHomeGoodsCell.h"

static NSString *headerView = @"headerView";
static NSString *shopQuery = @"shop/query";
static NSString *goodsCell = @"goodsCell";
static CGFloat titleFont = 12.F;

@interface PSShopHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet PSShowGradeStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopIntroLabel;

@property (nonatomic, copy) NSMutableDictionary *shopHeaderModel;

@end

@implementation PSShopHeaderView

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSShopHeaderView" owner:nil options:nil].firstObject;
    }
    return self;
}

@end

@interface PSShopPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *shopListView;
@property (nonatomic, strong) PSShopHeaderView *shopHeaderView;
@property (nonatomic, assign) PSNoDataViewType noDataType;
@property (nonatomic, copy) NSMutableArray *goodsArr;
@property (nonatomic, strong) PSShopDetailModel *shopDetailModel;

@end

@implementation PSShopPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _shopListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _shopListView.delegate = self;
    _shopListView.backgroundColor = [UIColor whiteColor];
    _shopListView.showsVerticalScrollIndicator = YES;
    _shopListView.showsHorizontalScrollIndicator = NO;
    _shopListView.delegate = self;
    _shopListView.dataSource = self;
    [_shopListView registerClass:[PSHomeGoodsCell class] forCellWithReuseIdentifier:goodsCell];
    [self.view addSubview:_shopListView];

//    [_shopListView registerNib:[UINib nibWithNibName:NSStringFromClass([PSShopHeaderView class]) bundle:nil]
//          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView];

    [self queryGoodsDetail];
}

- (void)queryGoodsDetail {
    _goodsArr = [NSMutableArray array];
    NSDictionary *param = @{@"shopId":@(_shopId)};
    [PSNetoperation getRequestWithConcretePartOfURL:shopQuery parameter:param success:^(id responseObject) {
        PSShopDetailModel *shopDetailModel = [PSShopDetailModel shopDetailWithDict:responseObject[@"data"]];
        _shopDetailModel = shopDetailModel;
        for(NSDictionary *dict in shopDetailModel.productItems) {
            [_goodsArr addObject:dict];
        }
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
    return CGSizeMake(goodsW, goodsW + 55.0);
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

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if (kind == UICollectionElementKindSectionHeader) {
//        PSShopHeaderView *shopHeader = (PSShopHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerView forIndexPath:indexPath];
//
//        return (UICollectionReusableView *)shopHeader;
//
//    } else {
//        return nil;
//    }
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    CGSize size = [self sizeWithText:_shopDetailModel.content maxWidth:kScreenWidth];
//    return CGSizeMake(ceil(size.width), ceil(size.height)+115);
//}
//
//- (CGSize)sizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth {
//    if(!text) {
//        return CGSizeMake(kScreenWidth, 115);
//    }
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineBreakMode = NSLineBreakByCharWrapping;
//    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
//                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFont],
//                                               NSParagraphStyleAttributeName:style
//                                               }
//                                     context:nil].size;
//    return CGSizeMake(ceil(size.width), ceil(size.height));
//}

@end
