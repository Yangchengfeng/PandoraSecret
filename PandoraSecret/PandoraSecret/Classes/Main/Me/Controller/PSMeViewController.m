//
//  PSMeViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/30.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMeViewController.h"
#import "PSMeTableView.h"

@interface PSMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PSMeTableView *settingsTableView;

@end

@implementation PSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)settingsItems {
    NSArray *settingsitems = @[@[@"昵称", @"收货地址", @"修改绑定手机号", @"修改登录密码"],
                               @[@"清除缓存", @"关于潘多拉的秘密"]];
    return settingsitems;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self settingsItems].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionItems = [self settingsItems][section];
    return sectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self settingsItems][indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

@end
