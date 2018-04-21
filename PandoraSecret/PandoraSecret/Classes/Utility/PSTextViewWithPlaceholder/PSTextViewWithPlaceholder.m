//
//  PSTextViewWithPlaceholder.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/21.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSTextViewWithPlaceholder.h"


@interface PSTextViewWithPlaceholder ()
{
    UILabel *_placeholderLabel;
}

@end

@implementation PSTextViewWithPlaceholder

- (void)setPlaceholder:(NSString *)placeholder {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [self createLabel];
    }
    _placeholderLabel.text = placeholder;
    _placeholderLabel.frame = CGRectMake(_placeholderLabel.frame.origin.x, _placeholderLabel.frame.origin.y, _placeholderLabel.bounds.size.width, [self sizeWithText:placeholder maxWidth:_placeholderLabel.bounds.size.width]);
}

- (NSString *)placeholder {
    if (_placeholderLabel == nil) {
        return nil;
    }
    return _placeholderLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [self createLabel];
    }
    _placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    if (_placeholderLabel == nil) {
        return nil;
    }
    return _placeholderLabel.textColor;
}

- (UIFont *)textFont {
    if(_textFont == nil) {
        return [UIFont systemFontOfSize:12];
    }
    return _textFont;
}

- (void)dealloc {
    if (_placeholderLabel != nil) {
        [self removeObserver:self forKeyPath:@"font"];
        [self removeObserver:self forKeyPath:@"text"];
        [self removeObserver:self forKeyPath:@"attributedText"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] || ([keyPath isEqualToString:@"attributedText"])) {
        [self textChanged:nil];
    } else {
        if (_placeholderLabel == nil) {
            return;
        }
        _placeholderLabel.font = self.font;
        _placeholderLabel.frame = CGRectMake(_placeholderLabel.frame.origin.x, _placeholderLabel.frame.origin.y, _placeholderLabel.frame.size.width, [self sizeWithText:_placeholderLabel.text maxWidth:_placeholderLabel.frame.size.width]);
    }
}

- (void)textChanged:(NSNotification *)notification {
    if (_placeholderLabel == nil) {
        return;
    }
    if (_isTrim) {
        _placeholderLabel.hidden = ([self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0);
    }else{
        _placeholderLabel.hidden = (0 != self.text.length);
    }
    
}

- (UILabel *)createLabel {
    __autoreleasing UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 6, self.bounds.size.width-8, 0)];
    createLabel.numberOfLines = 0;
    createLabel.font = self.textFont;
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.textColor = self.placeholderColor;
    createLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:createLabel];
    [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    return createLabel;
}

- (float)sizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:self.font,
                                               NSParagraphStyleAttributeName:style
                                               }
                                     context:nil].size;
    return ceilf(size.height);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if ([self.placeholderDelegate respondsToSelector:@selector(touchView:hitTest:withEvent:)]) {
        [self.placeholderDelegate touchView:self hitTest:point withEvent:event];
    }
    return [super hitTest:point withEvent:event];
}

@end
