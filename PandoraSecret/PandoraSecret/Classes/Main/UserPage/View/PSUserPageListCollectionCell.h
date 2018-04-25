//
//  PSUserPageListCollectionCell.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/25.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSShowGroundModel.h"
#import "PSCollectionModel.h"

@interface PSUserPageListCollectionCell : UITableViewCell

@property (nonatomic, strong) PSShowGroundModel *topicModel;
@property (nonatomic, strong) PSCollectionModel *collectionModel;

@end
