//
//  PSAddressListViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/15.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSAddressListViewController.h"
#import "PSUserOrderAddressModel.h"
#import "VictoriaAddressEditViewController.h"
#import "PSAddressListCell.h"

static NSString *addressQuery = @"address/query";
static NSString *deleteRequest = @"address/delete";

@interface PSAddressListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *addressListView;
@property (nonatomic, strong) NSMutableArray *addresslistArr;
@property (nonatomic, strong) PSUserOrderAddressModel *addressModel;
@property (nonatomic, assign) PSNoDataViewType noDataType;

@end

@implementation PSAddressListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理地址列表";
    
    self.addressListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-44-64-49) style:UITableViewStylePlain];
    _addressListView.delegate = self;
    _addressListView.dataSource = self;
    [self.view addSubview:_addressListView];
    
    UIButton *addAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddress.frame = CGRectMake(0, kScreenHeight-44-49, kScreenWidth, 44);
    [addAddress setTitle:@"新增地址" forState:UIControlStateNormal];
    [addAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addAddress.titleLabel.textAlignment = NSTextAlignmentCenter;
    addAddress.titleLabel.font = [UIFont systemFontOfSize:14];
    addAddress.backgroundColor = kPandoraSecretColor;
    [addAddress addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddress];
}

- (void)queryAddress {
    _addresslistArr = [NSMutableArray array];
    PSUserManager *userManager = [PSUserManager shareManager];
    NSDictionary *param = @{@"uid":@(userManager.uid)};
    [PSNetoperation getRequestWithConcretePartOfURL:addressQuery parameter:param success:^(id responseObject) {
        for(NSDictionary *address in responseObject[@"data"]) {
            [_addresslistArr addObject:address];
        }
        if(_addresslistArr && _addresslistArr.count<=0) {
            _noDataType = PSNoDataViewTypeSuccess;
        }
        [self.addressListView reloadData];
    } failure:^(id failure) {
        _noDataType = PSNoDataViewTypeFailure;
    } andError:^(NSError *error) {
        _noDataType = PSNoDataViewTypeError;
    }];
}

- (void)addAddress {
    VictoriaAddressEditViewController *newAddress = [[VictoriaAddressEditViewController alloc] init];
    [newAddress enterAddressEditVCWithType:VictoriaAddressEditTypeNew];
    [self.navigationController pushViewController:newAddress animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_addresslistArr.count>0) {
        return _addresslistArr.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_addresslistArr.count>0) {
        return 100;
    }
    return kScreenHeight-64-44-49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_addresslistArr.count > 0) {
        PSAddressListCell *addressCell = [[PSAddressListCell alloc] init];
        _addressModel = [PSUserOrderAddressModel orderAddressWithDict:_addresslistArr[indexPath.section]];
        addressCell.addressModel = _addressModel;
        [addressCell.edit addTarget:self action:@selector(toEdit) forControlEvents:UIControlEventTouchUpInside];
        [addressCell.delete addTarget:self action:@selector(toDelete) forControlEvents:UIControlEventTouchUpInside];
        return addressCell;
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

// 跳转到编辑页面
- (void)toEdit {
    VictoriaAddressEditViewController *editAddress = [[VictoriaAddressEditViewController alloc] init];
    editAddress.addressModel = _addressModel;
    [editAddress enterAddressEditVCWithType:VictoriaAddressEditTypeModify];
    [self.navigationController pushViewController:editAddress animated:YES];
}

// 发起删除，成功刷新页面
- (void)toDelete {
    NSDictionary *dict = @{@"uid": @([PSUserManager shareManager].uid),
                           @"id": _addressModel.addressId
                           };
    [PSNetoperation postRequestWithConcretePartOfURL:deleteRequest parameter:dict success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"删除备用地址成功"];
        for(NSDictionary *address in responseObject[@"data"]) {
            [_addresslistArr addObject:address];
        }
        [UIView animateWithDuration:[SVProgressHUD displayDurationForString:@"删除备用地址成功"] animations:^{
            [self.addressListView reloadData];
        }];
    } failure:^(id failure) {
        [SVProgressHUD showErrorWithStatus:failure[@"msg"]];
    } andError:^(NSError *error) {
        
    }];
}

@end
