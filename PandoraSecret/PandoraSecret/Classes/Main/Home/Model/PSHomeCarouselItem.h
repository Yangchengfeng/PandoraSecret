//
//  PSHomeCarouselItem.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/11.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSHomeCarouselItem : NSObject

@property (nonatomic, strong) NSString *imageId;
@property (nonatomic, strong) NSString *imagesUrl;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *goodsCategory;

+ (instancetype)HomeCarouselWithDict:(NSDictionary *)dict;

@end
