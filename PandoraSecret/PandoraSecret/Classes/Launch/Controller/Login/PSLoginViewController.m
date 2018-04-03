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

@interface PSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phonenumTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestBtn;

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
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)login:(UIButton *)sender {
    NSString *userPhoneNum = _phonenumTextField.text;
    // 判断是否为手机号码
    if(![self testPhoneNum:userPhoneNum]) {
        // toast
        return;
    }
    
    // 查找数据库判断是否存在该用户，存在则倒计时， 不存在则toast提示：未注册，请先进行注册
    if(![self testUser:userPhoneNum]) {
        // toast
        return;
    }
    
    [self clickBtn:sender toSendSMSWithPhoneNum:userPhoneNum];
    
}

- (IBAction)makeSurePhoneNumAndVerificationCode:(id)sender {
    [SMSSDK commitVerificationCode:_verificationCode.text
                       phoneNumber:_phonenumTextField.text
                              zone:@"86"
                            result:^(NSError *error) {
                                if (!error) {
                                    // 请求成功
                                        PSMainTabBarController *mainVC = [[PSMainTabBarController alloc] init];
                                        self.view.window.rootViewController = mainVC;
                                } else {
                                    // toast
                                }
    }];
}

- (BOOL)testPhoneNum:(NSString *)phoneNum {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isPhoneNum = [phoneTest evaluateWithObject:phoneNum];
    return isPhoneNum;
}

#pragma mark - 该用户是否已经注册
- (BOOL)testUser:(NSString *)phoneNum {
    BOOL hasUser = YES;
    
    return hasUser;
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
