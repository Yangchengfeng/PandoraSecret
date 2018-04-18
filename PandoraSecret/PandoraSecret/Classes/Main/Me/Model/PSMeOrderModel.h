//
//  PSMeOrderModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/18.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSMeOrderModel : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSArray *image;

+ (instancetype)orderItemWithDict:(NSDictionary *)dict;

@end
