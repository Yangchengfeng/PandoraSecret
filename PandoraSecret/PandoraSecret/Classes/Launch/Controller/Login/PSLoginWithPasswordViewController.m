//
//  PSLoginWithPasswordViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/4/3.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSLoginWithPasswordViewController.h"
#import "SVProgressHUD.h"

static NSString *loginURL = @"user/login";

@interface PSLoginWithPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation PSLoginWithPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_phoneNumberTextField becomeFirstResponder];
}

- (IBAction)loginWithPhoneNumberAndPassword:(id)sender {
    if([self testPhoneNum:_phoneNumberTextField.text] && _passwordTextField.text.length>0) {
        // 验证账号密码
        NSDictionary *param = @{@"phone":_phoneNumberTextField.text, @"password":_passwordTextField.text};
        [PSNetoperation postRequestWithConcretePartOfURL:loginURL parameter:param success:^(id responseObject) {
        } andError:^(NSError *responseError) {
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的账号和密码"];
    }
}

- (BOOL)testPhoneNum:(NSString *)phoneNum {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isPhoneNum = [phoneTest evaluateWithObject:phoneNum];
    return isPhoneNum;
}

@end
