//
//  PSRegisterViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/29.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSRegisterViewController.h"
#import "PSMainTabBarController.h"
#import "PSWebViewController.h"

static NSString *registerURL = @"user/register";
static NSString *privacyLink = @"https://www.baidu.com/duty/yinsiquan.html";

@interface PSRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phonenumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation PSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *letfBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = letfBarItem;
    
    [_phonenumTextField becomeFirstResponder];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)register:(id)sender {
    if([self testPhoneNum:_phonenumTextField.text] && self.passwordTextField.text.length>0) {
        NSDictionary *param = @{@"phone":_phonenumTextField.text, @"password":_passwordTextField.text};
        [PSNetoperation postRequestWithConcretePartOfURL:registerURL parameter:param success:^(id responseObject) {
        } failure:^(id failure) {
            NSLog(@"%@", failure);
            [SVProgressHUD showErrorWithStatus:failure[@"msg"]];
        } andError:^(NSError *responseError) {
            NSLog(@"%@", responseError);
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请确认输入正确的手机号码及密码"];
    }
    
}

- (BOOL)testPhoneNum:(NSString *)phoneNum {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isPhoneNum = [phoneTest evaluateWithObject:phoneNum];
    return isPhoneNum;
}

- (IBAction)showPrivacy:(id)sender {
    PSWebViewController *privacy = [[PSWebViewController alloc] init];
    privacy.webLink = privacyLink;
    [self.navigationController pushViewController:privacy animated:YES];
}

@end
