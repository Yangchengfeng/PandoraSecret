//
//  PSLaunchViewController.m
//  PandoraSecret
//
//  Created by 阳丞枫 on 2018/3/29.
//  Copyright © 2018年 chengfengYang. All rights reserved.
//

#import "PSLaunchViewController.h"
#import "PSMainTabBarController.h"
#import <AVKit/AVKit.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"

static NSString *queryURL = @"user/query";
static NSString *registerURL = @"user/register";

@interface PSLaunchViewController () <WeiboDelegate>
{
    AppDelegate *appDelgate; 
}

@property (nonatomic, strong) AVPlayerViewController *avPlayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerRightConstraint;

@end

@implementation PSLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _loginLeftConstraint.constant = _registerRightConstraint.constant = (kScreenWidth - 100 - 60*2)/2.0;
    
    [self setMoviePlayer];
}

-(void)setMoviePlayer{
    
    _avPlayer = [[AVPlayerViewController alloc]init];
    self.avPlayer.allowsPictureInPicturePlayback = NO;
    self.avPlayer.showsPlaybackControls = NO;
    
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"LaunchTour.mp4" ofType:nil];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:path]];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    [layer setFrame:[UIScreen mainScreen].bounds];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _avPlayer.player = player;
    //添加到self.view上面去
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始播放
    [_avPlayer.player play];
    
    // 重复播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
    
}


//播放完成的代理
- (void)playDidEnd:(NSNotification *)Notification{
    [_avPlayer.player seekToTime:CMTimeMake(0, 1)];
    //开始播放
    [_avPlayer.player play];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)loginWithweibo:(id)sender {
    appDelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelgate.sinaDelegate = self;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kReDirectURI;
    request.scope = @"all";
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
}

-(void)weiboLoginByResponse:(WBBaseResponse *)response{
    if(response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        // 保存用户信息，dismissVC，并进行异步注册
        NSDictionary *dic = (NSDictionary *) response.requestUserInfo;
        NSString *sinaUid = [NSString stringWithFormat:@"100000%@", dic[@"uid"]];
        NSDictionary *param = @{@"phone":sinaUid};
        [PSNetoperation getRequestWithConcretePartOfURL:queryURL parameter:param success:^(id responseObject) {
            NSDictionary *userInfo = responseObject[@"data"][0];
            PSUserManager *userManager = [PSUserManager shareManager];
            [userManager saveUserInfo:userInfo];
            PSMainTabBarController *mainVC = [[PSMainTabBarController alloc] init];
            self.view.window.rootViewController = mainVC;
        } failure:^(id failure) {
            [self registerSinaUid:sinaUid];
        } andError:^(NSError *responseError) {
            [SVProgressHUD showErrorWithStatus:@"操作失败，请重新再试"];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"微博登录失败，请尝试其他登录方式！"];
    }
}

- (void)registerSinaUid:(NSString *)sinaUid {
    NSDictionary *param = @{@"phone":sinaUid, @"password":@"123456"};
    [PSNetoperation postRequestWithConcretePartOfURL:registerURL parameter:param success:^(id responseObject) {
        PSUserManager *userManager = [PSUserManager shareManager];
        NSDictionary *userInfo = @{
                                   }; // 需要返回uid
        [userManager saveUserInfo:userInfo];
        PSMainTabBarController *mainVC = [[PSMainTabBarController alloc] init];
        self.view.window.rootViewController = mainVC;
    } failure:^(id failure) {
        NSLog(@"%@", failure);
        [SVProgressHUD showErrorWithStatus:failure[@"msg"]];
    } andError:^(NSError *responseError) {
        NSLog(@"%@", responseError);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
