//
//  PSUserPageViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/4.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageViewController.h"
#import "PSUserPageList.h"

@interface PSUserPageViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *userPageListScrollView;

@end

@implementation PSUserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _userPageListScrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-140.5);
    _userPageListScrollView.bounces = NO; // 限流
    _userPageListScrollView.pagingEnabled = YES;
    _userPageListScrollView.clipsToBounds = NO;
    
    // 关注列表
    UITableView *followList = [[PSUserPageList alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-140.5) andListType:PSUserPageListTypeFollow];
    [_userPageListScrollView addSubview:followList];
    
    // 收藏列表
    UITableView *collectionList = [[PSUserPageList alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-140.5) andListType:PSUserPageListTypeCollection];
    [_userPageListScrollView addSubview:collectionList];
    
}

@end
