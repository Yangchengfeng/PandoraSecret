//
//  PSMeViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/30.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//  1、分享：QQ、微博、短信
//  2、其他功能：收藏、复制、投诉

#import "PSMeViewController.h"
#import "PSMeTableView.h"
#import "PSMeHeaderTableViewCell.h"
#import "PSShareView.h"

static CGFloat rowH = 44.f;
static CGFloat headerH = 0.1f;
static CGFloat footerH = 10.f;
static CGFloat estimatedRowH = 113.5f;

@interface PSMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *shareItems;
@property (nonatomic, strong) NSDictionary *functionItems;
@property (nonatomic, strong) NSArray *settingsItems;

@end

@implementation PSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSDictionary *)shareItems { // @"分享类目名"：@"分享类目图片名"
    if(!_shareItems) {
        _shareItems = @{ @"QQ":@"QQ",
                         @"微博": @"weibo",
                         @"短信": @"sms",
                        };
    }
    return _shareItems;
}

- (NSDictionary *)functionItems { // 本人不支持
    if(!_functionItems) {
        _functionItems = @{ @"复制": @"copy"
                            };
    }
    return _functionItems;
}

- (NSArray *)settingsItems {
    if(!_settingsItems) {
        _settingsItems = @[@[@"个人中心信息展示"],
                               @[@"昵称", @"个人描述"],
                               @[@"我的订单", @"收货地址", @"修改绑定手机号", @"修改登录密码"],
                               @[@"关于潘多拉的秘密"],
                               @[@"退出当前用户"]];
    }
    return _settingsItems;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingsItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionItems = self.settingsItems[section];
    return sectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        PSMeHeaderTableViewCell *headerCell = [[PSMeHeaderTableViewCell alloc] init];
        // 设置model
        return headerCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    if(indexPath.section == self.settingsItems.count-1) {
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(0, 0, kScreenWidth, rowH);
        [logoutBtn setTitle:self.settingsItems[indexPath.section][indexPath.row] forState:UIControlStateNormal];
        [logoutBtn setTitle:self.settingsItems[indexPath.section][indexPath.row] forState:UIControlStateHighlighted];
        [logoutBtn setTitleColor:kPandoraSecretColor forState:UIControlStateNormal];
        [logoutBtn setTitleColor:kPandoraSecretColor forState:UIControlStateHighlighted];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSubview:logoutBtn];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.settingsItems[indexPath.section][indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return estimatedRowH;
    } else {
        return rowH;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footerH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)sharePersonality:(id)sender {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGSize itemSize = CGSizeMake(60, 80);
    PSShareView *shareView = [[PSShareView alloc] initWithshareViewFrame:frame ShareItems:self.shareItems functionItems:self.functionItems itemSize:itemSize];
    [shareView showOnController:self];
}

@end
