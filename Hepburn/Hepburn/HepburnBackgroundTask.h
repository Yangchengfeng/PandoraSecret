//
//  HepburnBackgroundTask.h
//  Hepburn
//
//  Created by 阳丞枫 on 2018/8/27.
//  Copyright © 2018年 阳丞枫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HepburnBackgroundTask : NSObject

+ (instancetype)sharedInstance;
- (void)beginBackgroundTask;

@end
