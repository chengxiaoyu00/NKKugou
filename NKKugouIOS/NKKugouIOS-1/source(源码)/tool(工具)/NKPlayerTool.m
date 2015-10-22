//
//  NKPlayerTool.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-4.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
#import "NKPlayListTool.h"
#import <MediaPlayer/MediaPlayer.h>

@interface NKPlayerTool()
{
    AVAudioPlayer* _audioPlayer;
    MPMoviePlayerController* _player;
}
@end

//单例的实现步骤
//1.把单例对象声明全局的static变量
//2.实现＋(instancetype)sharedXXXXX 要使用dispatch_once控制他只能创建一次
//3.重写＋(instancetype)allocWithZone 保证alloc只执行一次。

static NKPlayerTool* tool;

@implementation NKPlayerTool

+(instancetype)sharedNKPlayerTool{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[NKPlayerTool alloc]init];
    });
    return tool;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [super allocWithZone:zone];
    });
    return tool;
}
-(void)musicPlayEndAction:(NSNotification*)notify
{
    NSLog(@"%@",notify);
    [self playNextMusic];
}
#pragma mark 实现audioplayer的代理方法，监控播放器播放歌曲结束的事件
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //进行下一首的切换
    [self playNextMusic];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
#pragma mark 播放音乐
-(void)playMusic:(NKMusicModel *)music{
   // MPMoviePlayerController
    //所有的播放音乐的处理都在此函数，就在此处更新当前播放的歌曲。
    //切记不要在什么地方点击播放，就在什么地方设置当前播放音乐，会导致
    //当前播放音乐的设置处过多，难以维护，可维护性差。
    
    //程序的健壮型，应该有义务对别人传进来的参数作判断，如果不合理的应该有相应的处理。
    if (music == nil) {
        return;
    }
    
    [NKPlayListTool sharedNKPlayListTool].curPlayMusic = music;
    //注册音乐播放结束的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(musicPlayEndAction:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    NSURL * url ;
    if (_musicSource == kmusicSourceLocal) {
        //准备本地的播放url
        NSString* musicname = music.name;
        musicname = [musicname stringByAppendingPathExtension:@"mp3"];
        
        NSURL* localUrl = [[NSBundle mainBundle]URLForResource:musicname withExtension:nil];
        url = localUrl;
    }
    else
    {
        //准备电台的播放url
       url = [NSURL URLWithString:music.musicURL];
    }
    
    
    //播放器
    if (_player == nil) {
         MPMoviePlayerController* player = [[MPMoviePlayerController alloc]initWithContentURL:url];
        _player = player;
    }else
    {
        [_player setContentURL:url];
    
    }
    
     [_player play];
//    AVAudioPlayer* audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    _audioPlayer = audioPlayer;
//    
//    _audioPlayer.delegate = self;
//    
//    [_audioPlayer prepareToPlay];
//    [_audioPlayer play];
    
    //设置系统状态为播放音乐
    _status = kPlayerPlaying;
    
    //发送开始播放音乐的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playMusic" object:self];
  
    //发送歌词更新的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateGeci" object:self];
    
}

#pragma mark 暂停音乐
-(void)pauseMusic{
    //当前播放器如果时播放状态，暂停
//    if ([_audioPlayer isPlaying]) {
//        [_audioPlayer pause];
//        _status = kPlayerPause;
//    }
    if (_status == kPlayerPlaying  ) {
        [_player pause];
        _status = kPlayerPause;

    }
}

#pragma mark 从暂停状态恢复播放，断点继续播放
-(void)resumeMusic{
    //当播放器不是处在播放状态时，从断点开始播放
//    if (![_audioPlayer isPlaying]) {
//        [_audioPlayer prepareToPlay];
//        [_audioPlayer play];
//        _status = kPlayerPlaying;
//    }
    
    if (_status == kPlayerPause) {
      //  [_audioPlayer prepareToPlay];
        [_player play];
        _status = kPlayerPlaying;
    }
}

#pragma mark 播放下一曲
-(void)playNextMusic{
    [self playMusic:[NKPlayListTool sharedNKPlayListTool].nextPlayMusic];
}

@end
