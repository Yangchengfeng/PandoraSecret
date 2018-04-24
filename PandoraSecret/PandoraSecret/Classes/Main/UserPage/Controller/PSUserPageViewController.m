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

static CGFloat underlineWidthConstraint = 44.f;
static NSString *userPageQuery = @"user/message/query";

@interface PSUserPageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userVatcarImageView;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *userPageListScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlinViewLeftConstraint;
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
    // Do any additional setup after loading the view from its nib.
    _userPageListScrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-140.5);
    _userPageListScrollView.bounces = NO; // 限流
    _userPageListScrollView.pagingEnabled = YES;
    _userPageListScrollView.clipsToBounds = NO;
    _userPageListScrollView.delegate = self;
    
    // 关注列表
    _followList = [[PSUserPageList alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-140.5) andListType:PSUserPageListTypeFollow];
    _followList.tag = PSUserPageListTypeFollow;
    [_userPageListScrollView addSubview:_followList];
    
    // 收藏列表
    _collectionList = [[PSUserPageList alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-140.5) andListType:PSUserPageListTypeCollection];
    [_userPageListScrollView addSubview:_collectionList];
    
    // 下划线位置
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
    
    // unfollow_button
    [_focusBtn setImage:[UIImage imageNamed:@"follow_button"] forState:UIControlStateNormal];
    [_focusBtn setImage:[UIImage imageNamed:@"unfollow_button"] forState:UIControlStateSelected];
    
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
        _userNameLabel.text = _userPageModel.userName;
        _userDescLabel.text = _userPageModel.userDesc;
        [_userVatcarImageView sd_setImageWithURL:[NSURL URLWithString:_userPageModel.image] placeholderImage:[UIImage imageNamed:@"head_icon_me"]];
        if(_userPageModel.isFocus==-1) {
            _focusBtn.hidden = YES;
        } else {
            _focusBtn.hidden = NO;
            if(_userPageModel.isFocus == 0) {
                _focusBtn.selected = NO;
            } else {
                _focusBtn.selected = YES;
            }
        }
    } failure:^(id failure) {
        [SVProgressHUD showErrorWithStatus:failure[@"msg"]];
    } andError:^(NSError *error) {
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x/kScreenWidth;
    if(page < 0.5) {
        _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
    } else {
        CGFloat leftWidth = ((kScreenWidth-1)/2.0 - 44.)/2.0;
        _underlinViewLeftConstraint.constant = kScreenWidth/2.0 + leftWidth;
    }
}

- (IBAction)focusListBtn:(id)sender {
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
}

- (IBAction)collectionListBtn:(id)sender {
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0 + kScreenWidth/2.+1;
}

- (IBAction)shareThisPeople:(id)sender {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGSize itemSize = CGSizeMake(60, 80);
    PSShareView *shareView = [[PSShareView alloc] initWithshareViewFrame:frame ShareItems:self.shareItems functionItems:self.functionItems itemSize:itemSize];
    [shareView shareViewWithUid:_userPageModel.uid Title:_userPageModel.userName content:_userPageModel.userDesc image:_userPageModel.image];
    [shareView showOnController:self];
}

@end
