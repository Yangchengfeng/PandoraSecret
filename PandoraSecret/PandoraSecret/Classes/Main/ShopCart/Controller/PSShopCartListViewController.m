//
//  PSShopCartListViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/1.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShopCartListViewController.h"
#import "PSShopCartTableViewCell.h"
#import "PSShopCartModel.h"

static NSString *shopCartListQuery = @"cart/list";

@interface PSShopCartListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSMutableArray *shopCartListShopArr;
@property (nonatomic, copy) NSMutableArray *shopCartListGoodsArr;
@property (nonatomic, assign) PSNoDataViewType noDataType;
@property (weak, nonatomic) IBOutlet UITableView *shopCartList;

@end

@implementation PSShopCartListViewController

- (void)viewWillAppear:(BOOL)animated {
     [self queryShopCartList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _shopCartList.delegate = self;
    _shopCartList.dataSource = self;
}

- (void)queryShopCartList {
    _shopCartListShopArr = [NSMutableArray array];
    _shopCartListGoodsArr = [NSMutableArray array];
    NSDictionary *param = @{@"uid":@([PSUserManager shareManager].uid)};
    [PSNetoperation getRequestWithConcretePartOfURL:shopCartListQuery parameter:param success:^(id responseObject) {
        for(NSDictionary *address in responseObject[@"data"]) {
            [_shopCartListShopArr addObject:address[@"shopName"]];
            NSMutableArray *arr = [NSMutableArray array];
            for(NSDictionary *goods in address[@"carts"]) {
                [arr addObject:goods];
            }
            [_shopCartListGoodsArr addObject:arr];
        }
        if(_shopCartListShopArr && _shopCartListShopArr.count<=0) {
            _noDataType = PSNoDataViewTypeSuccess;
        }
        [self.shopCartList reloadData];
    } failure:^(id failure) {
        _noDataType = PSNoDataViewTypeFailure;
    } andError:^(NSError *error) {
        _noDataType = PSNoDataViewTypeError;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 商店数
    return _shopCartListShopArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 商品数+1个商店栏
    NSMutableArray *arr = _shopCartListGoodsArr[section];
    return arr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSShopCartTableViewCell *cell;
    BOOL isHeader = YES;
    if(indexPath.row == 0) {
        cell = [[PSShopCartTableViewCell alloc] initWithParam:isHeader];
        cell.shopName = _shopCartListShopArr[indexPath.section];
    } else {
        cell = [[PSShopCartTableViewCell alloc] initWithParam:(!isHeader)];
        NSInteger realIdx = indexPath.row-1;
        cell.shopCartModel = [PSShopCartModel shopCartListModelWithDict:_shopCartListGoodsArr[indexPath.section][realIdx]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0) {
        return 42.f;
    }
    return 102.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
