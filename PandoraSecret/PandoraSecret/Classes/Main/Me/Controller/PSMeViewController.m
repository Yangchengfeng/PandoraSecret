//
//  PSMeViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/30.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMeViewController.h"
#import "PSMeTableView.h"

static CGFloat rowH = 44.f;
static CGFloat headerH = 0.1f;
static CGFloat footerH = 10.f;

@interface PSMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PSMeTableView *settingsTableView;

@end

@implementation PSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)settingsItems {
    NSArray *settingsitems = @[@[@"昵称", @"个人描述", @"收货地址", @"修改绑定手机号", @"修改登录密码"],
                               @[@"关于潘多拉的秘密"],
                               @[@"退出当前用户"]];
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
    }
    if(indexPath.section == [self settingsItems].count-1) {
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(0, 0, kScreenWidth, rowH);
        [logoutBtn setTitle:[self settingsItems][indexPath.section][indexPath.row] forState:UIControlStateNormal];
        [logoutBtn setTitle:[self settingsItems][indexPath.section][indexPath.row] forState:UIControlStateHighlighted];
        [logoutBtn setTitleColor:kPandoraSecretColor forState:UIControlStateNormal];
        [logoutBtn setTitleColor:kPandoraSecretColor forState:UIControlStateHighlighted];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSubview:logoutBtn];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self settingsItems][indexPath.section][indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footerH;
}

@end
