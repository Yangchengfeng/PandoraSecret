//
//  PSShowGroundModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/20.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSShowGroundModel : NSObject

@property (nonatomic, strong) NSString *showId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userImage;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *topicImage;
@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

+ (instancetype)showWithDict:(NSDictionary *)dict;

@end
