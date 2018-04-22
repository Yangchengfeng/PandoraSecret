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

@interface PSGoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate, PSGoodsDetailCellDelegate>

@property (nonatomic, strong) UITableView *goodsDetailView;
@property (nonatomic, assign) PSNoDataViewType noDataType;
@property (nonatomic, copy) NSMutableArray *goodsDetailArr;

@end

@implementation PSGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _goodsDetailView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20) style:UITableViewStyleGrouped];
    _goodsDetailView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _goodsDetailView.delegate = self;
    _goodsDetailView.dataSource = self;
    [self.view addSubview:_goodsDetailView];
    
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
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
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

@end
