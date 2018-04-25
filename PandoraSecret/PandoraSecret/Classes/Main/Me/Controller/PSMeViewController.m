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
#import "PSLaunchViewController.h"
#import "PSMePersonalityEditViewController.h"
#import "PSAppAboutViewController.h"
#import "PSAddressListViewController.h"
#import "PSOrderListViewController.h"

static CGFloat rowH = 44.f;
static CGFloat headerH = 0.1f;
static CGFloat footerH = 10.f;
static CGFloat estimatedRowH = 113.5f;

typedef enum {
    PSSettingsSectionTypeHeader = 0,  // 个人头部
    PSSettingsSectionTypePersonality, // 个人信息修改
    PSSettingsSectionTypeOrder,       // 订单信息、地址
    PSSettingsSectionTypeAbout,       // 有关应用
    PSSettingsSectionTypeLogout,      // 登出设置
} PSSettingsSectionType;

@interface PSMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *settingsItems;
@property (weak, nonatomic) IBOutlet PSMeTableView *meTableView;

@end

@implementation PSMeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_meTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)settingsItems {
    if(!_settingsItems) {
        _settingsItems = @[@[@"个人中心信息展示"],
                               @[@"昵称", @"个人描述", @"修改登录密码"],
                               @[@"我的订单", @"收货地址"],
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
        PSUserManager *userManager = [PSUserManager shareManager];
        headerCell.headerModel = userManager.myCenterHeaderModel;
        return headerCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    if(indexPath.section == _settingsItems.count-1) {
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(0, 0, kScreenWidth, rowH);
        [logoutBtn setTitle:self.settingsItems[indexPath.section][indexPath.row] forState:UIControlStateNormal];
        [logoutBtn setTitle:self.settingsItems[indexPath.section][indexPath.row] forState:UIControlStateHighlighted];
        [logoutBtn setTitleColor:kPandoraSecretColor forState:UIControlStateNormal];
        [logoutBtn setTitleColor:kPandoraSecretColor forState:UIControlStateHighlighted];
        logoutBtn.userInteractionEnabled = NO;
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
    
    PSUserManager *userManager = [PSUserManager shareManager];
    switch (indexPath.section) {
        case PSSettingsSectionTypePersonality: {
            BOOL ensure = NO;
            NSString *placeholder = userManager.uname;
            PSEditType editType = PSEditTypeNickname;
            if(indexPath.row == 1) {
                editType = PSEditTypeDescription;
                placeholder = userManager.userDesc;
            }
            if(indexPath.row == 2) {
                ensure = YES;
                editType = PSEditTypePassword;
                placeholder = self.settingsItems[indexPath.section][indexPath.row];
            }
            PSMePersonalityEditViewController *personalityEditVc = [[PSMePersonalityEditViewController alloc] init];
            [personalityEditVc editWithType:editType placeHolder:placeholder needToEnsure:ensure];
            [self.navigationController pushViewController:personalityEditVc animated:YES];
            break;
        }
        case PSSettingsSectionTypeOrder:{
            if(indexPath.row == 0) {
                PSOrderListViewController *orderVC = [[PSOrderListViewController alloc] init];
                [self.navigationController pushViewController:orderVC animated:YES];
            } else {
                PSAddressListViewController *addressList = [[PSAddressListViewController alloc] init];
                addressList.uid = userManager.uid;
                [self.navigationController pushViewController:addressList animated:YES];
            }
            break;
        }
        case PSSettingsSectionTypeAbout: {
            PSAppAboutViewController *aboutVC = [[PSAppAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        }
        case PSSettingsSectionTypeLogout: {
            PSLaunchViewController *launch = [[UIStoryboard storyboardWithName: @"PSLaunchViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"launchFirstVCId"];
            launch.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:launch animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
