//
//  PSCollectionView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/25.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSCollectionView.h"

@interface PSCollectionView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation PSCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.collectionView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

@end
