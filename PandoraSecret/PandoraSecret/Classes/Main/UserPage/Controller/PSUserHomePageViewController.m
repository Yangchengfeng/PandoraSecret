//
//  PSUserHomePageViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/25.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserHomePageViewController.h"
#import "PSUserHomePageHeaderView.h"
#import "PSUserPageModel.h"
#import "PSShareView.h"
#import "PSUserPageListFollowCell.h"
#import "PSUserPageListCollectionCell.h"

static NSString *userPageQuery = @"user/message/query";
static NSString *userPageUpdate = @"user/message/update";

@interface PSUserHomePageViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, PSUserPageHeaderViewDelegate>

@property (nonatomic, strong) PSUserHomePageHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *tableScrollView;
@property (nonatomic, strong) PSUserPageModel *userPageModel;
@property (nonatomic, strong) NSArray *shareItems;
@property (nonatomic, strong) NSArray *functionItems;
@property (nonatomic, strong) UITableView *focusView;
@property (nonatomic, strong) UITableView *collectionView;

@end

@implementation PSUserHomePageViewController {
    CGFloat _yOffset;
}

- (NSArray *)shareItems {
    if(!_shareItems) {
        _shareItems = @[@"weibo", @"sms", @"QQ", @"wechat", @"email", @"renren",@"facebook"];
    }
    return _shareItems;
}

- (NSArray *)functionItems {
    if(!_functionItems) {
        _functionItems = @[@"copy", @"complaint", @"collection"];
    }
    return _functionItems;
}

-(void)viewDidLoad {
    
    [self createTableScrollView];
    
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"PSUserHomePageHeaderView" owner:nil options:nil].firstObject;
    self.headerView.headerDelegate = self;
    [self.view addSubview:self.headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.trailing.equalTo(self.view);
        make.height.equalTo(@(230));
    }];
    _yOffset = self.headerView.center.y;
//    [self queryList];
}

- (void)queryList {
    NSDictionary *param = @{@"uid":@(_uid),
                            @"phone":[PSUserManager shareManager].phoneNum
                            };
    [PSNetoperation getRequestWithConcretePartOfURL:userPageQuery parameter:param success:^(id responseObject) {
        _userPageModel = [PSUserPageModel userPageModelWithDict:responseObject[@"data"]];
    } failure:^(id failure) {
        [SVProgressHUD showErrorWithStatus:failure[@"msg"]];
    } andError:^(NSError *error) {
    }];
}

#pragma mark 创建下方tableview
-(void)createTableScrollView{
    
    self.tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight+20)];
    _tableScrollView.delegate = self;
    _tableScrollView.contentSize = CGSizeMake(2*kScreenWidth, kScreenHeight);
    _tableScrollView.pagingEnabled = YES;
    _tableScrollView.alwaysBounceVertical = NO;
    _tableScrollView.alwaysBounceHorizontal = NO;
    _tableScrollView.bouncesZoom = NO;
    _tableScrollView.bounces = NO;

    // 关注列表
    _focusView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+20) style:UITableViewStyleGrouped];
    _focusView.delegate = self;
    _focusView.dataSource = self;
    _focusView.tag = 100;
    [self createTableHeadView:_focusView];
    [_tableScrollView addSubview:_focusView];
    
    // 收藏列表
    _collectionView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight+20) style:UITableViewStyleGrouped];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.tag = 101;
    [self createTableHeadView:_collectionView];
    [_tableScrollView addSubview:_collectionView];
    
    [self.view addSubview:_tableScrollView];
}

-(void)createTableHeadView:(UITableView *)tableView {
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
    tableHeaderView.backgroundColor = [UIColor orangeColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorColor = [UIColor whiteColor];
    tableView.tableHeaderView = tableHeaderView;
    tableView.backgroundColor = kColorRGBA(252, 252, 252, 1);
}

#pragma mark scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableScrollView]) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y > 187) {
        _headerView.center = CGPointMake(_headerView.center.x, _yOffset - 187);
        return;
    }
    CGFloat h = _yOffset - offsetY;
    _headerView.center = CGPointMake(_headerView.center.x, h);
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x/kScreenWidth;
    if(page < 0.5) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userPageScrollFollow" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userPageScrollFoCollection" object:nil];
    }
    if (![scrollView isEqual:_tableScrollView]) {
        [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:_tableScrollView]) {
        return;
    }
    [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
}

//设置tableView的偏移量
-(void)setTableViewContentOffsetWithTag:(NSInteger)tag contentOffset:(CGFloat)offset{
    CGFloat tableViewOffset = offset;
    if(offset > 187){
        tableViewOffset = 187;
    }
    if (tag == 100) {
        [_collectionView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }
    if(tag == 101){
        [_focusView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }
}

- (void)shareThisPeople {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGSize itemSize = CGSizeMake(60, 80);
    PSShareView *shareView = [[PSShareView alloc] initWithshareViewFrame:frame ShareItems:self.shareItems functionItems:self.functionItems itemSize:itemSize];
    [shareView shareViewWithUid:_userPageModel.uid Title:_userPageModel.userName content:_userPageModel.userDesc image:_userPageModel.image];
    [shareView showOnController:self];
}

- (void)followThisPeople {
    // 发送网络请求回调信息刷新
}

- (void)moveToFollowList {
    [_tableScrollView setContentOffset:CGPointMake(0, -20) animated:YES];
}

- (void)moveToCollectionList {
    [_tableScrollView setContentOffset:CGPointMake(kScreenWidth, -20) animated:YES];

}

- (void)goBackToShowGround {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == _collectionView) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _collectionView) {
        return 10;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _focusView) {
        return 73.5;
    }
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == _focusView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"followId"];
        if(!cell) {
            cell = [[PSUserPageListFollowCell alloc] init];
        }
        return cell;
    }
    if(tableView == _collectionView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"collectionId"];
        if(!cell) {
            cell = [[PSUserPageListCollectionCell alloc] init];
        }
        return cell;
    }
    return cell;
}

#pragma mark - 导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
