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
    if(!_addressModel) {
        _addressModel = addressModel;
    }
    _uname.text = _addressModel.uname;
    _uphone.text = _addressModel.phone;
    _detailAddress.text = [NSString stringWithFormat:@"%@-%@", _addressModel.address, _addressModel.detailAddress];
    if([_addressModel.defaultAddress isEqualToString:@"1"]) {
        _defalutAddress.selected = YES;
    } else {
        _defalutAddress.selected = NO;
    }
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PSAddressListCell" owner:nil options:nil].firstObject;
        [self.defalutAddress setImage:[UIImage imageNamed:@"address_select"] forState:UIControlStateSelected];
        [self.defalutAddress setImage:[UIImage imageNamed:@"address_select_none"] forState:UIControlStateNormal];
    }
    return self;
}

@end
