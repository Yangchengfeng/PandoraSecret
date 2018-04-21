//
//  PSShowGroundCell.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/2.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSShowGroundModel.h"


@protocol PSShowGroundCellDelegate <NSObject>

- (void)enterUserPageWithUid:(NSInteger)uid;

@end

@interface PSShowGroundCell : UITableViewCell

@property (nonatomic, strong) PSShowGroundModel *showGroundModel;
@property (nonatomic, assign) id<PSShowGroundCellDelegate> delegate;

@end
