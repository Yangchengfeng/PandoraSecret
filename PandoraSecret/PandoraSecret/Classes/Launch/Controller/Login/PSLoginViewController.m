//
//  PSLoginViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/29.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSLoginViewController.h"
#import "PSMainTabBarController.h"
#import <SMS_SDK/SMSSDK.h>
#import "SVProgressHUD.h"

static NSString *queryURL = @"user/query";

@interface PSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phonenumTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestBtn;
@property (strong, nonatomic) NSDictionary *smsCodeDictionary;

@end

@implementation PSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 返回按钮，后期将进行重构
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *letfBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = letfBarItem;
    
    [_sendRequestBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendRequestBtn setBackgroundColor:[UIColor lightGrayColor]];
    _sendRequestBtn.userInteractionEnabled = YES;
    
    [_phonenumTextField becomeFirstResponder];
    
    _smsCodeDictionary = @{@"300463": @"手机号码每天发送次数超限",
                           @"300464": @"每台手机每天发送次数超限",
                           @"300467": @"校验验证码请求频繁",
                           @"300468": @"验证码错误"
                           };
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)login:(UIButton *)sender {
    NSString *userPhoneNum = _phonenumTextField.text;
    // 判断是否为手机号码
    if(![self testPhoneNum:userPhoneNum]) {
        // toast
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号码"];
        return;
    }
    
    // 查找数据库判断是否存在该用户，存在则倒计时， 不存在则toast提示：未注册，请先进行注册
    [self testUser:userPhoneNum withSender:sender andPhoneNum:userPhoneNum];
}

- (void)testUser:(NSString *)phoneNum withSender:(UIButton *)sender andPhoneNum:(NSString *)userPhoneNum {
    NSDictionary *param = @{@"phone":_phonenumTextField.text};
    [PSNetoperation getRequestWithConcretePartOfURL:queryURL parameter:param success:^(id responseObject) {
        // 保存用户信息，登录失败再清除
        [self clickBtn:sender toSendSMSWithPhoneNum:userPhoneNum];
    } failure:^(id failure) {
        [SVProgressHUD showErrorWithStatus:@"该用户未注册，请先注册"];
    } andError:^(NSError *responseError) {
        [SVProgressHUD showErrorWithStatus:@"操作失败，请重新再试"];
    }];
}

- (IBAction)makeSurePhoneNumAndVerificationCode:(id)sender {

    if(_phonenumTextField.text.length != 11 || _verificationCode.text.length !=4) {
        [SVProgressHUD showErrorWithStatus:@"请确认输入正确的号码和验证码"];
    }
    [SMSSDK commitVerificationCode:_verificationCode.text
                       phoneNumber:_phonenumTextField.text
                              zone:@"86"
                            result:^(NSError *error) {
                                if (!error) {
                                    // 请求成功
                                    PSMainTabBarController *mainVC = [[PSMainTabBarController alloc] init];
                                    self.view.window.rootViewController = mainVC;
                                    // 保存用户信息(uid等)
                                    
                                } else {
                                    // toast
                                    NSString *errorStr = [_smsCodeDictionary objectForKey:[NSString stringWithFormat:@"%ld", error.code]];
                                    [SVProgressHUD showErrorWithStatus:errorStr];
                                    [_sendRequestBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                                    [_sendRequestBtn setBackgroundColor:[UIColor redColor]];
                                    _sendRequestBtn.userInteractionEnabled = YES;
                                }
    }];
}

- (BOOL)testPhoneNum:(NSString *)phoneNum {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isPhoneNum = [phoneTest evaluateWithObject:phoneNum];
    return isPhoneNum;
}

- (void)clickBtn:(UIButton *)clickBtn toSendSMSWithPhoneNum:(NSString *)phoneNum {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:phoneNum
                                   zone:@"86"
                               template:@""
                                 result:^(NSError *error) {
                                        if (!error) {
                                            // 倒计时
                                            [_sendRequestBtn setTitle:@"60s" forState:UIControlStateNormal];
                                            [_sendRequestBtn setBackgroundColor:[UIColor redColor]];
                                            [self openCountdown:clickBtn];
                                            _sendRequestBtn.userInteractionEnabled = NO;
                                        } else {
                                            // toast
                                            [SVProgressHUD showWithStatus:@"验证码未发送成功"];
                                            [_sendRequestBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                                            [_sendRequestBtn setBackgroundColor:[UIColor redColor]];
                                            _sendRequestBtn.userInteractionEnabled = YES;
                                            return;
                                        }
    }];
}

- (void)openCountdown:(UIButton *)btn{
    
    __block NSInteger time = 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
    
        if(time <= 0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor redColor]];
                btn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 61;
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:[NSString stringWithFormat:@"%.2ds", seconds] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            });
            time--;
        }
        
    });
    dispatch_resume(_timer);
}

@end
