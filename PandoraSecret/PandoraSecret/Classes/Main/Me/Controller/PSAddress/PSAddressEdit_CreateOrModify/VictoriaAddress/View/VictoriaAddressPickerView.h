//
//  VictoriaAddressPickerView.h
//  Address
//
//  Created by 阳丞枫 on 2018/4/16.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VictoriaAddressTableViewTypeState = 0,
    VictoriaAddressTableViewTypeCity,
    VictoriaAddressTableViewTypeArea
} VictoriaAddressTableViewType;

@protocol VictoriaAddressPickerDelegate <NSObject>

- (void)selectedLevelIndex:(VictoriaAddressTableViewType)index withSelectedAddressParentId:(NSString *)parentId andSelectedAddressId:(NSString *)addressId;
- (void)setSelectedState:(NSString *)state city:(NSString *)city andArea:(NSString *)area;

@end

@interface VictoriaAddressPickerView: UIView 

@property (nonatomic, copy) NSMutableArray *stateArray;
@property (nonatomic, copy) NSMutableArray *cityArray;
@property (nonatomic, copy) NSMutableArray *regionsArray;
@property (nonatomic, weak) id<VictoriaAddressPickerDelegate> delegate;

- (void)showVictoriaAddressPickerView;
- (void)hiddenVictoriaAddressPickerView;

@end

