//
//  NKPlayerTool.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-4.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKMusicModel.h"
#import <AVFoundation/AVFoundation.h>

typedef enum {
    kPlayerLoaded = 0,
    kPlayerPause,
    kPlayerPlaying
}PlayStatus;

//本地音乐 电台音乐
typedef enum MusicSource
{
    kmusicSourceLocal,
    kmusicSourceDiantai

}MusicSource;
@interface NKPlayerTool : NSObject<AVAudioPlayerDelegate>
+(instancetype)sharedNKPlayerTool;

//播放音乐
-(void)playMusic:(NKMusicModel*)music;
//暂停音乐
-(void)pauseMusic;
//播放下一首歌曲
-(void)playNextMusic;
//从暂停状态恢复播放，断点继续播放
-(void)resumeMusic;

@property (assign, nonatomic) PlayStatus status;
@property(nonatomic,assign)MusicSource  musicSource;

@end
