//
//  PSTextViewWithPlaceholder.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSTextViewWithPlaceholder;
@protocol  PSTextViewWithPlaceholderDelegate <NSObject>

@required
- (void)touchView:(PSTextViewWithPlaceholder *)textView hitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end

@interface PSTextViewWithPlaceholder : UITextView

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
@property (nonatomic, assign) UIFont *textFont;
@property (nonatomic, assign) id<PSTextViewWithPlaceholderDelegate> placeholderDelegate;
@property(nonatomic, assign) BOOL isTrim;

@end
