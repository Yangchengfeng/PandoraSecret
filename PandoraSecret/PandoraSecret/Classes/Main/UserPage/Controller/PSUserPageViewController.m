//
//  PSUserPageViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/4.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageViewController.h"
#import "PSUserPageList.h"

static CGFloat underlineWidthConstraint = 44.f;

@interface PSUserPageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *userPageListScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlinViewLeftConstraint;

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
    UITableView *followList = [[PSUserPageList alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-140.5) andListType:PSUserPageListTypeFollow];
    [_userPageListScrollView addSubview:followList];
    
    // 收藏列表
    UITableView *collectionList = [[PSUserPageList alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-140.5) andListType:PSUserPageListTypeCollection];
    [_userPageListScrollView addSubview:collectionList];
    
    // 下划线位置
    _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"===");
    CGFloat page = scrollView.contentOffset.x/kScreenWidth;
    if(page < 0.5) {
        _underlinViewLeftConstraint.constant = ((kScreenWidth-1)/2.0 - underlineWidthConstraint)/2.0;
    } else {
        CGFloat leftWidth = ((kScreenWidth-1)/2.0 - 44.)/2.0;
        _underlinViewLeftConstraint.constant = kScreenWidth/2.0 + leftWidth;
    }
}

@end
