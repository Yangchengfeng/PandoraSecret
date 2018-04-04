//
//  PSUserPageList.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/4.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PSUserPageListTypeFollow = 0,
    PSUserPageListTypeCollection,
} PSUserPageListType;

@interface PSUserPageList : UITableView

- (instancetype)initWithFrame:(CGRect)frame andListType:(PSUserPageListType)listType;

@end
