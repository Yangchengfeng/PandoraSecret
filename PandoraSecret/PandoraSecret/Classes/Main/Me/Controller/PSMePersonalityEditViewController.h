//
//  PSMePersonalityEditViewController.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/13.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSBaseViewController.h"

typedef enum {
    PSEditTypeNickname = 0, // 昵称
    PSEditTypeDescription,  // 个人描述
    PSEditTypePassword,     // 密码
} PSEditType;

@interface PSMePersonalityEditViewController : PSBaseViewController

- (void)editWithType:(PSEditType)type placeHolder:(NSString *)placeHolder needToEnsure:(BOOL)ensure;

@end
