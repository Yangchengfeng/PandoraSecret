//
//  PSMePersonalityEditViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/13.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSMePersonalityEditViewController.h"
#import "PSButton.h"

static NSString *updateURL = @"user/update";

@interface PSMePersonalityEditViewController ()

@property (nonatomic, strong) UITextField *editInfoTextField;
@property (nonatomic, strong) UITextField *ensureInfoTextField;
@property (nonatomic, assign) BOOL needEnsure;
@property (nonatomic, assign) NSInteger editType;

@end

@implementation PSMePersonalityEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)editWithType:(PSEditType)type placeHolder:(NSString *)placeHolder needToEnsure:(BOOL)ensure {
    // 标题设置
    _editType = type;
    NSString *title = @"";
    switch (type) {
        case PSEditTypeNickname:
            title = @"修改昵称";
            break;
        case PSEditTypeDescription:
            title = @"修改个人描述";
            break;
        case PSEditTypePassword:
            title = @"修改账号密码";
            break;
        default:
            break;
    }
    self.navigationItem.title = title;
    _needEnsure = ensure;
    // 密码二次填写
    _ensureInfoTextField = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, kScreenHeight/2.-55, 200, 30)];
    _ensureInfoTextField.placeholder = @"再次输入修改信息";
    _ensureInfoTextField.font = [UIFont systemFontOfSize:12];
    _ensureInfoTextField.layer.borderWidth = 0.5;
    _ensureInfoTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSInteger kNum = 1;
    if(ensure) {
        [self.view addSubview:_ensureInfoTextField];
        kNum = 2;
    }
    // 编辑信息
    _editInfoTextField = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2., kScreenHeight/2.- 55*kNum, 200, 30)];
    _editInfoTextField.font = [UIFont systemFontOfSize:12];
    _editInfoTextField.placeholder = placeHolder;
    _editInfoTextField.layer.borderWidth = 0.5;
    _editInfoTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_editInfoTextField];
    // 确认按钮
    PSButton *btn = [PSButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake((kScreenWidth-80)/2, kScreenHeight/2., 80, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)editRequest {
    [_editInfoTextField resignFirstResponder];
    // 判断是否相同
    if(_needEnsure) {
        [_ensureInfoTextField resignFirstResponder];
        if((_ensureInfoTextField.text.length>0) && (_editInfoTextField.text.length>0) && [_ensureInfoTextField.text isEqualToString:_editInfoTextField.text]) {
            [self userInfoUpdate];
        } else {
            [SVProgressHUD showErrorWithStatus:@"确认两次填写的内容相同"];
        }
    } else {
        if(_editInfoTextField.text.length>0) {
            [self userInfoUpdate];
        } else {
             [SVProgressHUD showErrorWithStatus:@"请先填写要修改的信息"];
        }
    }
}

- (void)userInfoUpdate {

    PSUserManager *manager = [PSUserManager shareManager];
    if([manager hasLogin]) {
        NSDictionary *param = @{
                                @"phone": [manager phoneNum],
                                @"editType": @(_editType),
                                @"message": _editInfoTextField.text
                                };
        [PSNetoperation postRequestWithConcretePartOfURL:updateURL parameter:param success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [manager saveUserInfo:responseObject[@"data"][0]];
        } failure:^(id failure) {
            [SVProgressHUD showSuccessWithStatus:failure[@"msg"]];
        } andError:^(NSError *error) {
            
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_ensureInfoTextField resignFirstResponder];
    [_editInfoTextField resignFirstResponder];
}

@end
