//
//  PSLaunchViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/29.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSLaunchViewController.h"
#import "PSUserPageTableViewController.h"

@implementation PSLaunchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)pushToMain:(id)sender {
    [self.navigationController pushViewController:[[PSUserPageTableViewController alloc] init] animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
