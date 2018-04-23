//
//  PSGoodsDetailViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/22.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSGoodsDetailViewController.h"
#import "PSGoodsDetailCell.h"
#import "PSHomeProductListItem.h"
#import "PSShopPageViewController.h"

static NSString *goodsDetailQuery = @"product/detail";
static CGFloat tableFooterH = 44.f;

@interface PSGoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate, PSGoodsDetailCellDelegate>

@property (nonatomic, strong) UITableView *goodsDetailView;
@property (nonatomic, assign) PSNoDataViewType noDataType;
@property (nonatomic, copy) NSMutableArray *goodsDetailArr;

@end

@implementation PSGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _goodsDetailView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-tableFooterH) style:UITableViewStyleGrouped];
    _goodsDetailView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _goodsDetailView.delegate = self;
    _goodsDetailView.dataSource = self;
    [self.view addSubview:_goodsDetailView];
    
    UIButton *shopCartBtn = [UIButton new];
    shopCartBtn.backgroundColor = [UIColor whiteColor];
    [shopCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [shopCartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shopCartBtn addTarget:self action:@selector(addToShopCart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shopCartBtn];
    [shopCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    UIButton *payBtn = [[UIButton alloc] init];
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    payBtn.backgroundColor = kPandoraSecretColor;
    [payBtn setTitle:@"购买" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.and.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    [self queryGoodsDetail];
}

- (void)queryGoodsDetail {
    _goodsDetailArr = [NSMutableArray array];
    NSDictionary *param = @{@"tradeItemId":@(_tradeItemId)};
    [PSNetoperation getRequestWithConcretePartOfURL:goodsDetailQuery parameter:param success:^(id responseObject) {
        [_goodsDetailArr addObject:[PSHomeProductListItem homeProductListItemWithDict:responseObject[@"data"]]];
        [_goodsDetailView reloadData];
    } failure:^(id failure) {
        _noDataType = PSNoDataViewTypeFailure;
    } andError:^(NSError *error) {
        _noDataType = PSNoDataViewTypeError;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 520.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _goodsDetailArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSGoodsDetailCell *cell = [[PSGoodsDetailCell alloc] init];;
    cell.goodsDetailModel = _goodsDetailArr[indexPath.section];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)enterShopPageWithShopId:(NSInteger)shopId {
    PSShopPageViewController *shopPage = [[PSShopPageViewController alloc] init];
    shopPage.hidesBottomBarWhenPushed = YES;
    shopPage.shopId = shopId;
    [self.navigationController pushViewController:shopPage animated:YES];
}

- (void)pay {
    
}

- (void)addToShopCart {
    
}

@end
