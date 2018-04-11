//
//  PSHomeProductListItem.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/11.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSHomeProductListItem : NSObject

@property (nonatomic, strong) NSString *tradeItemId;
@property (nonatomic, strong) NSString *name; // 商品标题
@property (nonatomic, strong) NSString *title; // 商品二级标题
@property (nonatomic, strong) NSString *productCategory; // 商品所属类目
@property (nonatomic, strong) NSString *status; // 1是在线商品 0 是下线商品
@property (nonatomic, strong) NSString *sale; // 销量
@property (nonatomic, strong) NSString *stock; // 库存
@property (nonatomic, strong) NSString *shopId; // 店铺ID
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *price;

+ (instancetype)homeProductListItemWithDict:(NSDictionary *)dict;

@end
