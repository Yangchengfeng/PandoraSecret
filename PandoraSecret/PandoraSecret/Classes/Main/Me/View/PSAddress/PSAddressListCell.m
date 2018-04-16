//
//  PSAddressListCell.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/16.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSAddressListCell.h"

@interface PSAddressListCell ()
@property (weak, nonatomic) IBOutlet UILabel *uname;
@property (weak, nonatomic) IBOutlet UILabel *uphone;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (weak, nonatomic) IBOutlet UIButton *defalutAddress;

@end

@implementation PSAddressListCell

- (void)setAddressModel:(PSUserOrderAddressModel *)addressModel {
    _uname.text = addressModel.uname;
    _uphone.text = addressModel.phone;
    _detailAddress.text = addressModel.address;
    if(addressModel.defaultAddress == 1) {
        _defalutAddress.selected = YES;
    } else {
        _defalutAddress.selected = NO;
    }
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSAddressListCell" owner:nil options:nil].firstObject;
        [self.defalutAddress setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        [self.defalutAddress setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return self;
}

@end
