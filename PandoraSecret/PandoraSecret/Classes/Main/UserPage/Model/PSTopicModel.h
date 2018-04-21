//
//  PSTopicModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSTopicModel : NSObject

@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *topicImage;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) BOOL anonymous;

+ (instancetype)topicModelWithDict:(NSDictionary *)dict;

@end
