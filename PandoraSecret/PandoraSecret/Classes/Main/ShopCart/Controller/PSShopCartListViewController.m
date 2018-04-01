//
//  PSShopCartListViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/1.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShopCartListViewController.h"
#import "PSShopCartTableViewCell.h"

@interface PSShopCartListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *shopCartList;

@end

@implementation PSShopCartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _shopCartList.delegate = self;
    _shopCartList.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 商店数
    return 22;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 商品数+1个商店栏
    return 22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    BOOL isHeader = YES;
    if(indexPath.row == 0) {
        cell = [[PSShopCartTableViewCell alloc] initWithParam:isHeader];
    } else {
        cell = [[PSShopCartTableViewCell alloc] initWithParam:(!isHeader)];
    }
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
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
