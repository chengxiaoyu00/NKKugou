//
//  NKPlayBar.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-4.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKPlayBar.h"
#import "UIView+NKMoreAttribute.h"
#import "UIButton+NKImage.h"
#import <AVFoundation/AVFoundation.h>
#import "NKPlayerTool.h"
#import "NKMusicModel.h"
#import "NSArray+NKPList.h"
#import "NKPlayListTool.h"

static NKPlayBar* playBar;

@interface NKPlayBar()
{
    UIProgressView* _progress;
    NSArray* _timeArray;
}

@end

static CGFloat curTime = 0;
static CGFloat totalTime = 0;
static NSInteger geciIndex = 0;

@implementation NKPlayBar

+(instancetype)sharedPlayBar{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        playBar = [[NKPlayBar alloc]init];
        //先指定playBar的宽和高，至于放在屏幕的什么位置 由父控件来决定
        playBar.bounds = CGRectMake(0, 0, screenWidth, kImageHeightRatio*screenHeight);
    });
    return playBar;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        playBar = [super allocWithZone:zone];
    });
    return playBar;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        //加载子控件
        [self setupSubViews];
        
        //注册接受playMusic通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivePlayMusicNotify:) name:@"playMusic" object:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
    }
    return self;
}

//注意通知一定要记得删除，否则会有内存泄漏风险
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"playMusic" object:nil];
}

#pragma mark 时间进度条的处理
-(void)timeTick{
    if([NKPlayerTool sharedNKPlayerTool].status == kPlayerPlaying){
        
        NSString* curTimeMinuteStr = [NSString stringWithFormat:@"%02i",(int)(curTime/60)];
        
        NSString* curTimeSecondStr = [NSString stringWithFormat:@"%05.2f", curTime - [curTimeMinuteStr intValue]*60];
        
        NSString* curTimeStr = [NSString stringWithFormat:@"%@:%@",curTimeMinuteStr,curTimeSecondStr];
        
        if(geciIndex < _timeArray.count)
        {
            if ([curTimeStr isEqualToString:_timeArray[geciIndex]]) {
                NSLog(@"match %li", geciIndex);
                if ([_delegate respondsToSelector:@selector(playBar:didGeciChanged:)]) {
                    [_delegate playBar:self didGeciChanged:geciIndex];
                }
                geciIndex++;
            }
        }
        _progress.progress = curTime/totalTime;
        curTime += 0.01;
    }
    
}

#pragma mark 接受到playMusic通知，就更新歌曲信息Label
-(void)receivePlayMusicNotify:(NSNotification*)notify{
    [self updateMusicInfoLabel];
    _timeArray = [NSArray array];
    _timeArray = [NKPlayListTool sharedNKPlayListTool].curGeciDict[@"time"];
    geciIndex = 0;
    
}

#pragma mark 加载子控件
-(void)setupSubViews{
    
    //设置自己的背景色 和透明度
    self.backgroundColor = [UIColor grayColor];
    self.alpha = 0.8;
    
    //左边的图标
    UIImageView* leftImage = [[UIImageView alloc]init];
    [leftImage setImage:[UIImage imageNamed:@"play_bar_singerbg"]];
    leftImage.frame = CGRectMake(0, 0, screenWidth*kImageWidthRatio, screenHeight*kImageHeightRatio);
    [self addSubview:leftImage];
    
    //进度条
    UIProgressView* progress = [[UIProgressView alloc]init];
    progress.progressViewStyle = UIProgressViewStyleDefault;
    progress.progressTintColor = [UIColor yellowColor];
    progress.backgroundColor = [UIColor grayColor];
    progress.frame = CGRectMake(leftImage.right + 2, 3, screenWidth - leftImage.right - 4, 3);
    progress.progress = 0;
    _progress = progress;
    [self addSubview:progress];
    
    
    //下一曲按钮
    UIButton* nextButton = [[UIButton alloc]init];
    [nextButton setImage:[UIImage imageNamed:@"play_next"] forState:UIControlStateNormal];
    CGFloat nextButtonHeight = leftImage.height - (progress.bottom+3);
    CGFloat nextButtonWidth = nextButtonHeight;
    CGFloat nextButtonX = screenWidth-nextButtonWidth;
    CGFloat nextButtonY = progress.bottom + 3;
    
    nextButton.frame = CGRectMake(nextButtonX, nextButtonY, nextButtonWidth, nextButtonHeight);
    
    [nextButton addTarget:self action:@selector(playNextMusic:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:nextButton];
 
    
    //播放按钮
    UIButton* playButton = [UIButton buttonWithNormalImage:@"play_play" selectedImage:@"play_stop" target:self action:@selector(playMusic:)];
    
    CGFloat playButtonHeight = nextButton.height;
    CGFloat playButtonWidth = nextButton.width;
    CGFloat playButtonX = nextButton.left-playButtonWidth;
    CGFloat playButtonY = nextButton.up;
    
    playButton.frame = CGRectMake(playButtonX, playButtonY, playButtonWidth, playButtonHeight);
    _playButton = playButton;
    [self addSubview:playButton];
    
    
    //歌曲label
    UILabel* musicNameLabel = [[UILabel alloc]init];
    musicNameLabel.textColor = [UIColor whiteColor];
    musicNameLabel.frame = CGRectMake(progress.left, progress.bottom, screenWidth-leftImage.width-nextButton.width-playButton.width, 18);
    _musicNameLabel = musicNameLabel;
    [self addSubview:musicNameLabel];
    
    //歌手label
    UILabel* singerLabel = [[UILabel alloc]init];
    singerLabel.font = [UIFont systemFontOfSize:13];
    singerLabel.textColor = [UIColor whiteColor];
    singerLabel.frame = CGRectMake(progress.left, musicNameLabel.bottom, screenWidth-leftImage.width-nextButton.width-playButton.width, leftImage.height-musicNameLabel.bottom);
    _singerLabel = singerLabel;
    [self addSubview:singerLabel];

}

#pragma mark 播放下一曲
-(void)playNextMusic:(UIButton*)btn{
    //播放下一曲
    [[NKPlayerTool sharedNKPlayerTool]playMusic:[NKPlayListTool sharedNKPlayListTool].nextPlayMusic];
}

#pragma mark 播放当前歌曲
-(void)playMusic:(UIButton*)btn{
    
    if ([NKPlayerTool sharedNKPlayerTool].status == kPlayerPlaying) {
        [[NKPlayerTool sharedNKPlayerTool] pauseMusic];
        btn.selected = !btn.selected;
    }else
    {
        //处于暂停状态 调用resume
        if ([NKPlayerTool sharedNKPlayerTool].status == kPlayerPause) {
            [[NKPlayerTool sharedNKPlayerTool] resumeMusic];
            btn.selected = !btn.selected;
        }else{ //处于不是暂停 未播放的状态
            [[NKPlayerTool sharedNKPlayerTool] playMusic:[NKPlayListTool sharedNKPlayListTool].curPlayMusic];
        }
    }
}

#pragma mark 更新歌曲信息Label
-(void)updateMusicInfoLabel{
    _musicNameLabel.text = [NKPlayListTool sharedNKPlayListTool].curPlayMusic.name;
    _singerLabel.text = [NKPlayListTool sharedNKPlayListTool].curPlayMusic.singer;
    _playButton.selected = YES;
    totalTime = [[NKPlayListTool sharedNKPlayListTool].curPlayMusic.time floatValue];
    
    curTime = 0;
}

@end
