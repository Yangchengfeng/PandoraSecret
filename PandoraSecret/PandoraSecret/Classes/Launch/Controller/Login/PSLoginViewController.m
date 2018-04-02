//
//  PSLoginViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/29.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSLoginViewController.h"

@interface PSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phonenumTextField;

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
    
    [_phonenumTextField becomeFirstResponder];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)login:(id)sender {
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
    
    // 倒计时 & 发送验证码 ：同步
    
}

#pragma mark - 判断是否为手机号码
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

#pragma mark - 倒计时、重新发送

#pragma mark - 发送验证码


#pragma mark - toast
- (void)toastWithStr:(NSString *)toast {
    
}

@end
