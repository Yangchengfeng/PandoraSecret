//
//  PSRegisterViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/29.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSRegisterViewController.h"

@interface PSRegisterViewController ()

@end

@implementation PSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *letfBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = letfBarItem;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
