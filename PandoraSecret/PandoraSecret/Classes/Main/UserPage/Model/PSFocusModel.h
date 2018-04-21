//
//  PSFocusModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSFocusModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *userDesc;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSInteger isFocus;

+ (instancetype)focusModelWithDict:(NSDictionary *)dict;

@end
