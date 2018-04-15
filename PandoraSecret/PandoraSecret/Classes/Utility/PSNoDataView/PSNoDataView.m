//
//  PSNoDataView.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/15.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSNoDataView.h"

@interface PSNoDataView ()

@property (weak, nonatomic) IBOutlet UIImageView *nodataImageView;

@end

@implementation PSNoDataView

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSNoDataView" owner:nil options:nil].firstObject;
    }
    return self;
}

- (void)noDataViewWithFrame:(CGRect)frame andType:(PSNoDataViewType)type {
    self.frame = frame;
    switch (type) {
        case PSNoDataViewTypeSuccess:
            [self.nodataImageView setImage:[UIImage imageNamed:@"no_data_success"]];
            break;
        case PSNoDataViewTypeFailure:
            [self.nodataImageView setImage:[UIImage imageNamed:@"no_data_failure"]];
            break;
        case PSNoDataViewTypeError:
            [self.nodataImageView setImage:[UIImage imageNamed:@"no_data_net_error"]];
            break;
        default:
            break;
    }
}

@end
