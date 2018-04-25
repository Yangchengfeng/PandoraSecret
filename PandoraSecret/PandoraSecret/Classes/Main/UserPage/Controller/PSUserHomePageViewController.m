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
#import "PSUserPageList.h"

static NSString *userPageQuery = @"user/message/query";
static NSString *userPageUpdate = @"user/message/update";

@interface PSUserHomePageViewController () <UIScrollViewDelegate, UITableViewDelegate, PSUserPageHeaderViewDelegate>

@property (nonatomic, strong) PSUserHomePageHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *tableScrollView;
@property (nonatomic, strong) PSUserPageModel *userPageModel;
@property (nonatomic, strong) NSArray *shareItems;
@property (nonatomic, strong) NSArray *functionItems;
@property (nonatomic, strong) PSUserPageList *focusView;
@property (nonatomic, strong) PSUserPageList *collectionView;

@end

@implementation PSUserHomePageViewController {
    
    UIView *_bottomLine;
    UIView *_movingLine;
    NSInteger _index;
    CGFloat _tableViewH;
    CGFloat _lastOffset;
    CGFloat _yOffset;
    CGFloat _changW;
    CGFloat _changY;
    UIImage *_headImage;
}


- (PSUserHomePageHeaderView *)headerView {
    if(!_headerView) {
        _headerView = [[PSUserHomePageHeaderView alloc] initWithFrame:CGRectMake(0, kNavH, kScreenWidth, 230)];
        _headerView.headerDelegate = self;
        _yOffset = _headerView.center.y;
    }
    return _headerView;
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
    
    [self.view addSubview:self.headerView];
    
    [self queryList];
}

- (void)queryList {
    NSDictionary *param = @{@"uid":@(_uid),
                            @"phone":[PSUserManager shareManager].phoneNum
                            };
    [PSNetoperation getRequestWithConcretePartOfURL:userPageQuery parameter:param success:^(id responseObject) {
        _userPageModel = [PSUserPageModel userPageModelWithDict:responseObject[@"data"]];
        _focusView.userPageArr = _userPageModel.focusArr;
        _collectionView.userPageArr = _userPageModel.topicArr;
    } failure:^(id failure) {
        [SVProgressHUD showErrorWithStatus:failure[@"msg"]];
    } andError:^(NSError *error) {
    }];
}

#pragma mark 创建下方tableview
-(void)createTableScrollView{
    CGFloat tableScrollX = 0;
    CGFloat tableScrollY = 0;
    CGFloat tableScrollWidth = kScreenWidth;
    CGFloat tableScrollHeight = kScreenHeight - kNavH;
    
    UIScrollView *userPageListScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(tableScrollX, tableScrollY, tableScrollWidth, tableScrollHeight)];
    userPageListScrollView.delegate = self;
    userPageListScrollView.contentSize = CGSizeMake(2*kScreenWidth, tableScrollHeight);
    userPageListScrollView.pagingEnabled = YES;
    userPageListScrollView.alwaysBounceVertical = NO;
    userPageListScrollView.bounces = NO;
    _tableScrollView = userPageListScrollView;

    // 关注列表
    _focusView = [[PSUserPageList alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, tableScrollHeight) andListType:PSUserPageListTypeFollow];
    _focusView.userPageListView.tag = 100;
    _focusView.userPageListView.delegate = self;
    [self createTableHeadView:_focusView.userPageListView];
    [_tableScrollView addSubview:_focusView];
    
    // 收藏列表
    _collectionView = [[PSUserPageList alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth,tableScrollHeight) andListType:PSUserPageListTypeCollection];
    _collectionView.userPageListView.tag = 101;
    _collectionView.userPageListView.delegate = self;
    [self createTableHeadView:_collectionView.userPageListView];
    [_tableScrollView addSubview:_collectionView];
    
    [self.view addSubview:_tableScrollView];
}

-(void)createTableHeadView:(UITableView *)tableView {
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = tableHeaderView;
    tableView.backgroundColor = kColorRGBA(252, 252, 252, 1);
}

#pragma mark scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_tableScrollView]) {
        _index = _tableScrollView.bounds.origin.x/_tableScrollView.bounds.size.width;
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y > 195) {
        _headerView.center = CGPointMake(_headerView.center.x, _yOffset - 195);
        return;
    }
    CGFloat h = _yOffset - offsetY;
    _headerView.center = CGPointMake(_headerView.center.x, h);
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableScrollView]) {
        if (_index == 0) {
            
        }
        if (_index == 1){
            
        }
        return;
    }
    
    [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
    
//    CGFloat page = scrollView.contentOffset.x/kScreenWidth;
//    if(page < 0.5) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"userPageScrollFollow" object:nil];
//    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"userPageScrollFoCollection" object:nil];
//    }
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
    if(offset > 195){
        tableViewOffset = 195;
    }
    if (tag == 100) {
//        [_collectionView.userPageListView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }
    if(tag == 101){
//        [_focusView.tableview setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
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
}

- (void)moveToCollectionList {
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
