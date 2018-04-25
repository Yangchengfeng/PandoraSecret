//
//  PSUserPageList.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/4.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PSUserPageListTypeFollow = 100,
    PSUserPageListTypeCollection,
} PSUserPageListType;

@interface PSUserPageList : UIView

@property (nonatomic, strong) UITableView *userPageListView;
@property (nonatomic, copy) NSMutableArray *userPageArr;

- (instancetype)initWithFrame:(CGRect)frame andListType:(PSUserPageListType)listType;

@end
