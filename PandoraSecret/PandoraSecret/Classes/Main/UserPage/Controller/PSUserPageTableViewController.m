//
//  PSUserPageTableViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/3.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageTableViewController.h"
#import "PSUserPageHeaderView.h"

@interface PSUserPageTableViewController ()

@end

@implementation PSUserPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PSUserPageHeaderView *headerView = [[PSUserPageHeaderView alloc] init];
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

@end
