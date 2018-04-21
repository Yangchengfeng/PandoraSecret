//
//  PSCollectionModel.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSCollectionModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;

+ (instancetype)collectionModelWithDict:(NSDictionary *)dict;

@end
