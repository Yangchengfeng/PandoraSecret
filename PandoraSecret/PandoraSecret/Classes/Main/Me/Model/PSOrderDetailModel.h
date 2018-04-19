//
//  PSOrderDetailModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/18.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSOrderDetailModel : NSObject

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *num;

+ (instancetype)orderDetailWithDict:(NSDictionary *)dict;

@end
