//
//  PSMainTabBarController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/29.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMainTabBarController.h"

@interface PSMainTabBarController ()

@end

@implementation PSMainTabBarController

- (instancetype)init {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"PSMain" bundle:[NSBundle mainBundle]];
    PSMainTabBarController *myView = [story instantiateViewControllerWithIdentifier:@"Main"];
    return myView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = kPandoraSecretColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
