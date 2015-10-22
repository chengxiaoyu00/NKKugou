//
//  playMovieViewController.m
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/22.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "playMovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface playMovieViewController ()
{
    MPMoviePlayerViewController * _playViewControl;
}

@end

@implementation playMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"test.mov"withExtension:nil];;
//    NSLog(@"url is %@",url
//          );
    MPMoviePlayerViewController * playViewControl = [[MPMoviePlayerViewController alloc]initWithContentURL:url];;
    _playViewControl = playViewControl;
    
    [self.view addSubview:playViewControl.view];
      [playViewControl.moviePlayer play];
    [playViewControl.moviePlayer requestThumbnailImagesAtTimes:@[@0.1,@2.4]  timeOption:MPMovieTimeOptionNearestKeyFrame];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thumbnailImageNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
 object:nil];

   // MPMoviePlayerThumbnailImageRequestDidFinishNotification
}

- (void)finishNotification:(NSNotification * )notify
{
    //NSLog(@"notify");
    //退出模态控制器
   
    [self dismissViewControllerAnimated:self completion:nil];
   // self presentViewController:<#(UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>
}
- (void)stateChangeNotification:(NSNotification * )notify
{
    //NSLog(@"notify%@",notify);
   MPMoviePlayerController* pc =  notify.object ;
    //NSLog(@"%li",(long)pc.playbackState);
    
    //退出模态控制器
    
   // [self dismissViewControllerAnimated:self completion:nil];
    // self presentViewController:<#(UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>
}

-(void)thumbnailImageNotification:(NSNotification*)notify
{
    NSLog(@"%@",notify);
    UIImage * img = notify.userInfo[MPMoviePlayerThumbnailImageKey];
    
    UIImageView * imgView = [[UIImageView alloc ]initWithImage:img];;
    [self.view addSubview:imgView];
    imgView.frame = CGRectMake(100, 50, 100, 100);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
