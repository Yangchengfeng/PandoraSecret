//
//  PSHomeHeaderView.h
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/23.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSHomeHeaderViewDelegate <NSObject>

- (void)enterWebView:(NSString *)webViewLink;

@end

@interface PSHomeHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<PSHomeHeaderViewDelegate> delegate;

@end
