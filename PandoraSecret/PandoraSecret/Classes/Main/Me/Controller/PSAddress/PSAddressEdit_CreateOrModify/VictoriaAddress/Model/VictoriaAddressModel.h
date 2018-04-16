//
//  VictoriaAddressModel.h
//  Address
//
//  Created by 阳丞枫 on 2018/4/16.
//  Copyright © 2018年 CodingFire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VictoriaAddressModel : NSObject

@property (nonatomic, strong) NSString *victoria_parentid;
@property (nonatomic, strong) NSString *victoria_id;
@property (nonatomic, strong) NSString *victoria_name;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
