//
//  PSShopCartModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSShopCartModel : NSObject
       
@property (nonatomic, assign) NSInteger userListid;
@property (nonatomic, assign) NSInteger shopId; // 店铺ID
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, strong) NSString *shopName; // 商品标题
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title; // 商品二级标题
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger uid;

+ (instancetype)shopCartListModelWithDict:(NSDictionary *)dict;

@end
