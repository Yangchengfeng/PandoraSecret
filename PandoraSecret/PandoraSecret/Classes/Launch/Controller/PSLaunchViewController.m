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

@interface PSLaunchViewController ()

@property (nonatomic, strong) AVPlayerViewController *avPlayer;

@end

@implementation PSLaunchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
