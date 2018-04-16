//
//  VictoriaAddressEditViewController.m
//  Address
//
//  Created by 阳丞枫 on 2018/4/16.
//  Copyright © 2018年 CodingFire. All rights reserved.
//
//  for Create or Modify an address

#import "VictoriaAddressEditViewController.h"
#import "VictoriaAddressPickerView.h"
#import "VictoriaAddressModel.h"

static NSString *addAddress = @"address/add";

@interface VictoriaAddressEditViewController () <VictoriaAddressPickerDelegate, UITextViewDelegate>

@property (nonatomic, strong) VictoriaAddressPickerView *areaView;
@property (nonatomic, assign) VictoriaAddressTableViewType selectTableViewId;
@property (nonatomic, assign) NSInteger selectedAddressId;
@property (nonatomic, assign) NSInteger selectedAddressParentId;
@property (nonatomic, copy) NSMutableArray *stateArr;
@property (nonatomic, copy) NSMutableArray *cityArr;
@property (nonatomic, copy) NSMutableArray *areaArr;
// myAddressView
@property (nonatomic, copy) NSArray *editListArr;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UITextField *unameTextField;
@property (nonatomic, strong) UITextField *uphoneTextField;
@property (nonatomic, strong) UITextView *detailAddressTextView;
@property (nonatomic, strong) UISwitch *defaultSwitch;

@end

@implementation VictoriaAddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    _selectTableViewId = VictoriaAddressTableViewTypeState;
    _selectedAddressId = 0;
    _selectedAddressParentId = 0;
    _stateArr = [NSMutableArray array];
    _cityArr = [NSMutableArray array];
    _areaArr = [NSMutableArray array];
}

#pragma mark - VictoriaAddressPickerDelegate
- (void)selectedLevelIndex:(VictoriaAddressTableViewType)index withSelectedAddressParentId:(NSString *)parentId andSelectedAddressId:(NSString *)addressId {
    _selectTableViewId = index + 1;
    _selectedAddressId = [addressId integerValue];
    _selectedAddressParentId = [parentId integerValue];
    switch (_selectTableViewId) {
        case VictoriaAddressTableViewTypeCity:
            [_cityArr removeAllObjects];
            break;
        case VictoriaAddressTableViewTypeArea:
            [_areaArr removeAllObjects];
            break;
        default:
            break;
    }
    [self requestAllAreaName];
}

#pragma mark - 获取对应地址列表
- (NSMutableArray *)addressArrWithHigherLevelArr:(NSArray *)higherLevelArr andAddressKey:(NSString *)addressKey {
    NSMutableArray *addressArr = [NSMutableArray array];
    NSInteger i = 0;
    for (id state_dict in higherLevelArr ) {
        NSString *name = @"";
        if([state_dict isKindOfClass:[NSString class]]) {
            name = state_dict;
        } else {
            name = [state_dict objectForKey:addressKey];
        }
        NSMutableDictionary *stateDict = [NSMutableDictionary dictionary];
        [stateDict setValue:name forKey:@"victoria_name"];
        [stateDict setValue:[NSString stringWithFormat:@"%ld", i] forKey:@"victoria_id"];
        [stateDict setValue:[NSString stringWithFormat:@"%ld", _selectedAddressId] forKey:@"victoria_parentid"];
        VictoriaAddressModel *addressModel = [[VictoriaAddressModel alloc] initWithDict:stateDict];
        [addressArr addObject:addressModel];
        i++;
    }
    return addressArr;
}

- (void)requestAllAreaName {
    if (!_areaView) {
        _areaView = [[VictoriaAddressPickerView alloc]initWithFrame:CGRectMakes(0, 0, 375, 667)];
        _areaView.hidden = YES;
        _areaView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_areaView];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:path];
    
    switch (_selectTableViewId) {
        case VictoriaAddressTableViewTypeState: {
            _stateArr = [self addressArrWithHigherLevelArr:plistArr andAddressKey:@"state"];
            [_areaView setStateArray:_stateArr];
            [_areaView showVictoriaAddressPickerView];
            break;
        }
        case VictoriaAddressTableViewTypeCity: {
            NSDictionary *state_dict = plistArr[_selectedAddressId];
            _cityArr = [self addressArrWithHigherLevelArr:state_dict[@"cities"] andAddressKey:@"city"];
            [_areaView setCityArray:_cityArr];
            break;
        }
        case VictoriaAddressTableViewTypeArea: {
            NSDictionary *state_dict = plistArr[_selectedAddressParentId];
            NSDictionary *cities_arr = state_dict[@"cities"][_selectedAddressId];
            _areaArr = [self addressArrWithHigherLevelArr:cities_arr[@"areas"] andAddressKey:@"areas"];
            [_areaView setRegionsArray:_areaArr];
            break;
        }
        default:
            break;
    }
}

#pragma mark - tableview
- (NSArray *)editListArr {
    if(!_editListArr) {
        _editListArr = @[@"收件人", @"联系电话", @"所在地址", @"详细地址", @"设置默认地址"];
    }
    return _editListArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.editListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 3) {
        return 80;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMakes(0, 0, 375, 80)];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMakes(0, 0, 80, 40);
    saveBtn.center = view.center;
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    saveBtn.backgroundColor = kPandoraSecretColor;
    saveBtn.layer.borderWidth = 0.3;
    [saveBtn addTarget:self action:@selector(commitAllInformation) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:saveBtn];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if(indexPath.row == 0 || indexPath.row == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editCellId"];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMakes(85, 0, 375-85, cell.frame.size.height)];
        textField.textColor = [UIColor blackColor];
        textField.tintColor = [UIColor orangeColor];
        textField.font = [UIFont systemFontOfSize:12];
        textField.userInteractionEnabled = YES;
        if(indexPath.row == 0) {
            _unameTextField = textField;
        } else {
            _uphoneTextField = textField;
            _uphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [cell addSubview:textField];
    }
    if(indexPath.row == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseCellId"];
        [cell addSubview:self.addressBtn];
    }
    if(indexPath.row == 3) {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMakes(85, 0, 375-85, 90)];
        textView.text= @"请输入收件人的详细地址信息，如道路，门牌号，小区，楼栋号、单元室等，需要上门或非工作日取件可以加以备注";
        textView.editable = YES;
        textView.tintColor = [UIColor orangeColor];
        textView.textColor = [UIColor lightGrayColor];
        textView.font = [UIFont systemFontOfSize:12];
        textView.delegate = self;
        _detailAddressTextView = textView;
        [cell addSubview:textView];
    }
    if(indexPath.row == 4) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switchCellId"];
        UISwitch *switchBtn = [[UISwitch alloc]init];
        [switchBtn addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        switchBtn.tag = 100 + indexPath.row;
        cell.accessoryView = switchBtn;
        _defaultSwitch = switchBtn;
    }
    cell.textLabel.text = _editListArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

- (void)showAddressView {
    [_uphoneTextField resignFirstResponder];
    [_unameTextField resignFirstResponder];
    [_detailAddressTextView resignFirstResponder];
    if (!_areaView) {
        [self requestAllAreaName];
    } else {
         [_areaView showVictoriaAddressPickerView];
    }
}

- (UIButton *)addressBtn {
    if(!_addressBtn) {
        UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMakes(85, 0, 375-85, 40)];
        [addressBtn setTitle:@"请选择您所需要的地址" forState:UIControlStateNormal];
        [addressBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        addressBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [addressBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [addressBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 50, 0, -50)];
        [addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 16)];
        [addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 123, 0, -123)];
        addressBtn.userInteractionEnabled = YES;
        [addressBtn addTarget:self action:@selector(showAddressView) forControlEvents:UIControlEventTouchUpInside];
        _addressBtn = addressBtn;
    }
    return _addressBtn;
}

- (void)setSelectedState:(NSString *)state city:(NSString *)city andArea:(NSString *)area {
    NSString *selectedAddress = [NSString stringWithFormat:@"%@-%@-%@", state, city, area];
    [self.addressBtn setTitle:selectedAddress forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length < 1) {
        textView.text = @"请输入收件人的详细地址信息，如道路，门牌号，小区，楼栋号、单元室等，需要上门或非工作日取件可以加以备注";
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if(textView.text.length>0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)switchValueChange:(UISwitch *)switchBtn {
    // 保存设置
}

- (void)commitAllInformation {
    PSUserManager *userManager = [PSUserManager shareManager];
    NSDictionary *addressParam = @{@"uid":@(userManager.uid),
                                   @"phone": _uphoneTextField.text,
                                   @"uname": _unameTextField.text,
                                   @"address":[NSString stringWithFormat:@"%@-%@", self.addressBtn.titleLabel.text, _detailAddressTextView.text]
                                   };
    [PSNetoperation postRequestWithConcretePartOfURL:addAddress parameter:addressParam success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"增加地址成功"];
    } failure:^(id failure) {
        [SVProgressHUD showSuccessWithStatus:@"操作失败，请重新再试~"];
    } andError:^(NSError *error) {
    }];
}

@end
