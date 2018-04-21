//
//  PSUserPageModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSFocusModel.h"
#import "PSCollectionModel.h"
#import "PSTopicModel.h"

@interface PSUserPageModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *userDesc;
@property (nonatomic, assign) NSInteger isFocus;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, copy) NSMutableArray<PSFocusModel *> *focusArr;
@property (nonatomic, copy) NSMutableArray<PSCollectionModel *> *collectionArr;
@property (nonatomic, copy) NSMutableArray<PSTopicModel *> *topicArr;

+ (instancetype)userPageModelWithDict:(NSDictionary *)dict;

@end
