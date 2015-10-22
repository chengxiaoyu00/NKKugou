//
//  NKMVPlayViewController.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-15.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKMVPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface NKMVPlayViewController ()
{
    MPMoviePlayerViewController* _moviePlayerViewController;
    
}
@end

@implementation NKMVPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    
    
    NSURL* url = [[NSBundle mainBundle]URLForResource:@"test.mov" withExtension:nil];
    MPMoviePlayerViewController* moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    _moviePlayerViewController = moviePlayerViewController;
    
    [self.view addSubview:moviePlayerViewController.view];
    
    //注册我们观察的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(donePlayBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //注册状态变化的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayerViewController.moviePlayer];
    
    //注册获取缩略图的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(thumnailGet:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    

    [moviePlayerViewController.moviePlayer play];
    //times 一定要写成浮点数形式
    NSArray* times = @[@1.0, @3.0];
    [moviePlayerViewController.moviePlayer requestThumbnailImagesAtTimes:times timeOption:MPMovieTimeOptionNearestKeyFrame];
    
}

-(void)thumnailGet:(NSNotification*)notify{
    NSLog(@"thumnail Get!!!!!");
//    UIImage* image =  notify.userInfo[MPMoviePlayerThumbnailImageKey];
//    UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
//    imageView.frame = CGRectMake(100, 100, 200, 150);
//    [self.view addSubview:imageView];
}

//接受到播放结束的通知后，退回到上一个界面
- (void)donePlayBack:(NSNotification*)notify{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

//接受到播放状态变化的通知后，判断播放器的状态 进行相关的处理
- (void)stateChange:(NSNotification*)notify{
    
    MPMoviePlayerController* moviePlayer =  (MPMoviePlayerController*)notify.object;
    /*
     MPMoviePlaybackStateStopped,
     MPMoviePlaybackStatePlaying,
     MPMoviePlaybackStatePaused,
     MPMoviePlaybackStateInterrupted,
     MPMoviePlaybackStateSeekingForward,
     MPMoviePlaybackStateSeekingBackward
     */
    
    
    switch (moviePlayer.playbackState) {
        case MPMoviePlaybackStatePaused:
            NSLog(@"Paused");
            break;
        case MPMoviePlaybackStatePlaying:
        {
            NSLog(@"Playing");
            NSLog(@"movie duration %f", _moviePlayerViewController.moviePlayer.duration);
            
        }
            break;
        default:
            break;
    }
    
}

//移除通知
-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//界面一出来就是向右横屏
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

@end
