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

@end

@implementation PSUserPageViewController

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
}

- (void)queryList {
    NSDictionary *param = @{@"uid":@"",
                            @"phone":[PSUserManager shareManager].phoneNum
                            };
    [PSNetoperation getRequestWithConcretePartOfURL:userPageQuery parameter:param success:^(id responseObject) {
        _userPageModel = [PSUserPageModel userPageModelWithDict:responseObject[@"data"]];
        _followList.userPageArr = _userPageModel.focusArr;
        _collectionList.userPageArr = _userPageModel.collectionArr;
        
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

@end
