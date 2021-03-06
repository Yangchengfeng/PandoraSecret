//
//  PSShowGroundViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/2.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSShowGroundViewController.h"
#import "PSShowGroundCell.h"
#import "PSShowGroundModel.h"
#import "PSUserHomePageViewController.h"

static NSString *showGroundListQuery = @"topic/list";

@interface PSShowGroundViewController () <UITableViewDelegate, UITableViewDataSource, PSShowGroundCellDelegate>

@property (nonatomic, strong) UITableView *showGroundListView;
@property (nonatomic, copy) NSMutableArray *showGroundListArr;

@end

@implementation PSShowGroundViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _showGroundListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:UITableViewStyleGrouped];
    _showGroundListView.delegate = self;
    _showGroundListView.dataSource = self;
    [self.view addSubview:_showGroundListView];
}

- (void)queryList {
    _showGroundListArr = [NSMutableArray array];
    [PSNetoperation getRequestWithConcretePartOfURL:showGroundListQuery parameter:nil success:^(id responseObject) {
        for(NSDictionary *dict in responseObject[@"data"]) {
            [_showGroundListArr addObject:[PSShowGroundModel showWithDict:dict]];
        }
        [_showGroundListView reloadData];
    } failure:^(id failure) {
        [SVProgressHUD showErrorWithStatus:failure[@"msg"]];
    } andError:^(NSError *error) {
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSShowGroundCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PSShowGroundCell" owner:nil options:nil].firstObject;
    if(!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    }
    cell.delegate = self;
    cell.showGroundModel = _showGroundListArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_showGroundListArr) {
        return _showGroundListArr.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.f;
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

- (void)enterUserPageWithUid:(NSInteger)uid {
    PSUserHomePageViewController *userPage = [[PSUserHomePageViewController alloc] init];
    userPage.hidesBottomBarWhenPushed = YES;
    userPage.uid = uid;
    [self.navigationController pushViewController:userPage animated:YES];
}

@end
