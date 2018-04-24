//
//  PSUserPageViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/4.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageViewController.h"
#import "PSUserPageList.h"
#import "PSUserPageModel.h"
#import "PSShareView.h"

// -******************** 个人主页头部 ***********************-

static CGFloat underlineWidthConstraint = 44.f;

@protocol PSUserPageHeaderViewDelegate <NSObject>

- (void)shareThisPeople;
- (void)followThisPeople;
- (void)moveToFollowList;
- (void)moveToCollectionList;

@end

@interface PSUserPageHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *userDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userVatcarImageView;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlinViewLeftConstraint;

@property (nonatomic, weak) id<PSUserPageHeaderViewDelegate> headerDelegate;

@end

@implementation PSUserPageHeaderView

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSUserPageHeaderView" owner:nil options:nil].firstObject;
        // 下划线位置
        _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
        
        // unfollow_button
        [_focusBtn setImage:[UIImage imageNamed:@"follow_button"] forState:UIControlStateNormal];
        [_focusBtn setImage:[UIImage imageNamed:@"unfollow_button"] forState:UIControlStateSelected];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPageListScrollToFollow) name:@"userPageScrollFollow" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPageListScrollToCollection) name:@"userPageScrollFoCollection" object:nil];
    }
    return self;
}

- (IBAction)chooseListBtn:(UIButton *)sender {
    if(sender.tag == 10) {
        [self userPageListScrollToFollow];
        if([self.headerDelegate respondsToSelector:@selector(moveToFollowList)]) {
            [self.headerDelegate moveToFollowList];
        }
    }
    if(sender.tag == 11){
        [self userPageListScrollToCollection];
        if([self.headerDelegate respondsToSelector:@selector(moveToCollectionList)]) {
            [self.headerDelegate moveToCollectionList];
        }
    }
}

- (IBAction)focus:(id)sender {
    if([self.headerDelegate respondsToSelector:@selector(followThisPeople)]) {
        [self.headerDelegate followThisPeople];
    }
}

- (IBAction)share:(id)sender {
    if([self.headerDelegate respondsToSelector:@selector(shareThisPeople)]) {
        [self.headerDelegate shareThisPeople];
    }
}

- (void)userPageListScrollToFollow {
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
}

- (void)userPageListScrollToCollection {
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0 + kScreenWidth/2.+1;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userPageScrollFollow" object:nil];
}

@end

// -******************** 个人主页 ***********************-

static NSString *userPageQuery = @"user/message/query";
static NSString *userPageUpdate = @"user/message/update";

@interface PSUserPageViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PSUserPageHeaderViewDelegate>

@property (nonatomic, strong) UITableView *userPageView;
@property (nonatomic, strong) UIScrollView *userPageListScrollView;
@property (nonatomic, strong) PSUserPageList *followList;
@property (nonatomic, strong) PSUserPageList *collectionList;
@property (nonatomic, strong) PSUserPageModel *userPageModel;
@property (nonatomic, strong) NSArray *shareItems;
@property (nonatomic, strong) NSArray *functionItems;

@end

@implementation PSUserPageViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _userPageView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    _userPageView.delegate = self;
    _userPageView.dataSource = self;
    [self.view addSubview:_userPageView];
    [_userPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(-20);
    }];
    
    [self queryList];
}

- (void)queryList {
    NSDictionary *param = @{@"uid":@(_uid),
                            @"phone":[PSUserManager shareManager].phoneNum
                            };
    [PSNetoperation getRequestWithConcretePartOfURL:userPageQuery parameter:param success:^(id responseObject) {
        _userPageModel = [PSUserPageModel userPageModelWithDict:responseObject[@"data"]];
        _followList.userPageArr = _userPageModel.focusArr;
        _collectionList.userPageArr = _userPageModel.topicArr;
    } failure:^(id failure) {
        [SVProgressHUD showErrorWithStatus:failure[@"msg"]];
    } andError:^(NSError *error) {
    }];
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
    [_userPageListScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)moveToCollectionList {
    [_userPageListScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

#pragma mark - scrollview
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x/kScreenWidth;
    if(page < 0.5) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userPageScrollFollow" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userPageScrollFoCollection" object:nil];
    }
}

#pragma mark - 数据源设置

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    _userPageListScrollView = [[UIScrollView alloc] init];
    [cell addSubview:_userPageListScrollView];
    [_userPageListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.and.top.and.bottom.equalTo(cell);
    }];
    _userPageListScrollView.contentSize = CGSizeMake(kScreenWidth*2, tableView.bounds.size.height-230+44);
    _userPageListScrollView.bounces = NO; // 限流
    _userPageListScrollView.pagingEnabled = YES;
    _userPageListScrollView.clipsToBounds = NO;
    _userPageListScrollView.delegate = self;
    
    // 关注列表
    _followList = [[PSUserPageList alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, tableView.bounds.size.height-230+44) andListType:PSUserPageListTypeFollow];
    _followList.tag = PSUserPageListTypeFollow;
    [_userPageListScrollView addSubview:_followList];
    
    // 收藏列表
    _collectionList = [[PSUserPageList alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, tableView.bounds.size.height-230+44) andListType:PSUserPageListTypeCollection];
    [_userPageListScrollView addSubview:_collectionList];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PSUserPageHeaderView *header = [[PSUserPageHeaderView alloc] init];
    header.headerDelegate = self;
    if(_userPageModel.userName.length>0) {
        header.userNameLabel.text = _userPageModel.userName;
    } else {
        header.userNameLabel.text = @"潘多拉的秘密社会人";
    }
    if(_userPageModel.userDesc.length>0) {
        header.userDescLabel.text = _userPageModel.userDesc;
    } else {
        header.userDescLabel.text = @"我只是潘多拉的秘密里的社会人";
    }
    [header.userVatcarImageView sd_setImageWithURL:[NSURL URLWithString:_userPageModel.image] placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
    if(_userPageModel.isFocus==-1) {
        header.focusBtn.hidden = YES;
    } else {
        header.focusBtn.hidden = NO;
        if(_userPageModel.isFocus == 0) {
            header.focusBtn.selected = NO;
        } else {
            header.focusBtn.selected = YES;
        }
    }
    if(_userPageModel.uid == [PSUserManager shareManager].uid) {
        header.focusBtn.hidden = YES;
    } else {
        header.focusBtn.hidden = NO;
    }
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.height - 230 + 44;
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
