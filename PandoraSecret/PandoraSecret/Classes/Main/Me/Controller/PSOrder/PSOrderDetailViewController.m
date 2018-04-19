//
//  PSOrderDetailViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/19.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSOrderDetailViewController.h"
#import "PSOrderDetailCell.h"
#import "PSOrderDetailModel.h"

static NSString *orderDetailQuery = @"order/detail";

@interface PSOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *orderDetailView;
@property (nonatomic, copy) NSMutableArray *orderDetailArr;
@property (nonatomic, copy) NSMutableArray *orderFooterArr;
@property (nonatomic, assign) PSNoDataViewType noDataType;

@end

@implementation PSOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderDetailView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStyleGrouped];
    _orderDetailView.backgroundColor = [UIColor whiteColor];
    _orderDetailView.delegate = self;
    _orderDetailView.dataSource = self;
    _orderDetailView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_orderDetailView];
    self.navigationItem.title = @"订单详情";
}

- (void)requestOrderDetailWithOrderId:(NSString *)orderId {
    _orderDetailArr = [NSMutableArray array];
    _orderFooterArr = [NSMutableArray array];
    NSDictionary *orderParam = @{@"orderId":orderId};
    [PSNetoperation getRequestWithConcretePartOfURL:orderDetailQuery parameter:orderParam success:^(id responseObject) {
        for(NSDictionary *order in responseObject[@"data"][@"goods"]) {
            [_orderDetailArr addObject:[PSOrderDetailModel orderDetailWithDict:order]];
        }
        [_orderFooterArr addObject:responseObject[@"data"][@"price"]];
        [_orderFooterArr addObject:responseObject[@"data"][@"orderId"]];
        [_orderFooterArr addObject:responseObject[@"data"][@"createTime"]];
        if(_orderDetailArr && _orderDetailArr.count<=0) {
            _noDataType = PSNoDataViewTypeSuccess;
        }
        [self.orderDetailView reloadData];
    } failure:^(id failure) {
        _noDataType = PSNoDataViewTypeFailure;
    } andError:^(NSError *error) {
        _noDataType = PSNoDataViewTypeError;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_orderDetailArr.count>0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_orderDetailArr.count>0) {
        if(section == 0) {
            return _orderDetailArr.count;
        } else {
            return 3;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_orderDetailArr.count>0) {
        if(indexPath.section == 0) {
            return 90;
        } else {
            return 20;
        }
    }
    return kScreenHeight-44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_orderDetailArr.count > 0) {
        if(indexPath.section == 0) {
            PSOrderDetailCell *orderDetailCell = [[PSOrderDetailCell alloc] init];
            orderDetailCell.orderDetailModel = _orderDetailArr[indexPath.row];
            return orderDetailCell;
        }
        if(indexPath.section == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"实付：￥%@", _orderFooterArr[indexPath.row]];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"订单号：%@", _orderFooterArr[indexPath.row]];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"下单时间：%@", _orderFooterArr[indexPath.row]];
                    break;
                default:
                    break;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            return cell;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    for(UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    PSNoDataView *noDataView = [[PSNoDataView alloc] init];
    [noDataView noDataViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) andType:_noDataType];
    [cell addSubview:noDataView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 用于去掉Grouped类型引起的头部空白
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

// 用于设定特定组间距
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3;
}

@end
