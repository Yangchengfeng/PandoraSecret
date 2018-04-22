//
//  PSShopDetailModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/23.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSHomeProductListItem.h"

@interface PSShopDetailModel : NSObject

@property (nonatomic, assign) NSInteger fans;
@property (nonatomic, assign) NSInteger star; 
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSMutableArray<PSHomeProductListItem *> *productItems;

+ (instancetype)shopDetailWithDict:(NSDictionary *)dict;

@end
