//
//  PSMeHeaderModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/14.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSMeHeaderModel : NSObject

@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *userVatcar;
@property (nonatomic, assign) NSInteger focusNum;
@property (nonatomic, assign) NSInteger collectionNum;

+ (instancetype)myCenterHeaderWithDict:(NSDictionary *)dict;

@end
