//
//  PSHomeGoodsCell.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/11.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSHomeProductListItem.h"

@interface PSHomeGoodsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *fancyBtn;
@property (nonatomic, strong) PSHomeProductListItem *productListItem;

@end
