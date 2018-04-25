//
//  PSUserPageList.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/4.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSUserPageList.h"
#import "PSUserPageListFollowCell.h"
#import "PSShowGroundCell.h"

@interface PSUserPageList () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger listType;

@end

@implementation PSUserPageList

- (instancetype)initWithFrame:(CGRect)frame andListType:(PSUserPageListType)listType {
    self = [super init];
    if(self) {
    
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorColor = [UIColor whiteColor];
        self.userPageListView = tableView;
        self.frame = frame;
        self.listType = listType;
        [self addSubview:_userPageListView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_listType == PSUserPageListTypeFollow) {
        return 74.5f;
    }
    return 170.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_listType == PSUserPageListTypeFollow) {
        PSUserPageListFollowCell *cell = [[PSUserPageListFollowCell alloc] init];
        return cell;
    }
    if(_listType == PSUserPageListTypeCollection) {
        PSShowGroundCell *cell = [[PSShowGroundCell alloc] init];
        cell.showGroundModel = (PSShowGroundModel *)_userPageArr;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    return cell;
}



@end
