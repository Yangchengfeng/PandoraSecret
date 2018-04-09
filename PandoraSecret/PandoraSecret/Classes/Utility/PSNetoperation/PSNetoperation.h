//
//  PSNetoperation.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/8.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(id responseObject);
typedef void(^failure)(id failure);
typedef void(^responseError)(NSError *responseError);

@interface PSNetoperation : NSObject

+ (void)getRequestWithConcretePartOfURL:(NSString *)urlStr parameter:(id)param success:(success)success failure:(failure)failure andError:(responseError)responseError;
+ (void)postRequestWithConcretePartOfURL:(NSString *)urlStr parameter:(id)param success:(success)success  andError:(responseError)responseError;
+ (void)postRequestWithConcretePartOfURL:(NSString *)urlStr parameter:(id)param success:(success)success failure:(failure)failure andError:(responseError)responseError;

@end