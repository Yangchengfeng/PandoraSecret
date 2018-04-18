//
//  PSOrderListViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/18.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSOrderListViewController.h"
#import "PSOrderListCell.h"
#import "PSMeOrderModel.h"

static NSString *orderQuery = @"order/list/query";

@interface PSOrderListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderListView;
@property (nonatomic, copy) NSMutableArray *orderListArr;
@property (nonatomic, assign) PSNoDataViewType noDataType;

@end

@implementation PSOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStyleGrouped];
    _orderListView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    _orderListView.delegate = self;
    _orderListView.dataSource = self;
    [self.view addSubview:_orderListView];
    self.navigationItem.title = @"我的订单";
    [self requestOrderList];
}

- (void)requestOrderList {
    _orderListArr = [NSMutableArray array];
    NSDictionary *orderParam = @{@"uid":@([PSUserManager shareManager].uid)};
    [PSNetoperation getRequestWithConcretePartOfURL:orderQuery parameter:orderParam success:^(id responseObject) {
        for(NSDictionary *order in responseObject[@"data"]) {
            [_orderListArr addObject:[PSMeOrderModel orderItemWithDict:order]];
        }
        if(_orderListArr && _orderListArr.count<=0) {
            _noDataType = PSNoDataViewTypeSuccess;
        }
        [self.orderListView reloadData];
    } failure:^(id failure) {
        _noDataType = PSNoDataViewTypeFailure;
    } andError:^(NSError *error) {
        _noDataType = PSNoDataViewTypeError;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_orderListArr.count>0) {
        return _orderListArr.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_orderListArr.count>0) {
        return 150;
    }
    return kScreenHeight-64-49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_orderListArr.count > 0) {
        PSOrderListCell *orderListCell = [[PSOrderListCell alloc] init];
        for(UIView *view in orderListCell.goodsImage.subviews) {
            [view removeFromSuperview];
        }
        orderListCell.orderListModel = _orderListArr[indexPath.section];
        return orderListCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    for(UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    PSNoDataView *noDataView = [[PSNoDataView alloc] init];
    [noDataView noDataViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44-49) andType:_noDataType];
    [cell addSubview:noDataView];
    return cell;
}

@end
