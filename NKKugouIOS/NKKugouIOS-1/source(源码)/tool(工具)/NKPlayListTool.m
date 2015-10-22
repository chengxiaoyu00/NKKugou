//
//  NKPlayListTool.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-5.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKPlayListTool.h"
#import "NSArray+NKPList.h"
#import "NKMusicModel.h"

static NKPlayListTool* tool;
@implementation NKPlayListTool

+(instancetype)sharedNKPlayListTool{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[NKPlayListTool alloc]init];
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

//默认的播放模式全部循环
-(instancetype)init{
    self = [super init];
    if (self) {
        _playMode = kPlayModeAllLoop;
        //初始化我喜欢列表，不要忘了，否则加载不进去
        _myLoveMuiscList = [NSMutableArray array];
        //本地音乐列表初始化
        _allLocMusicList = [NSMutableArray array];
        
        _loadMuiscList = [NSMutableArray array];
    }
    return self;
}

#pragma mark 搜索本地音乐列表
-(void)searchAllMusicList;
{
    NSArray* array = [NSArray arrayWithPlist:@"locMusicList.plist"];
    for (NSDictionary* dict in array) {
        NKMusicModel* mode = [NKMusicModel musicModelWithDict:dict];
        [_allLocMusicList addObject:mode];
    }
}

#pragma mark 下一首歌曲
- (NKMusicModel *)nextPlayMusic{
    NKMusicModel* nextMusic = nil;
    if (_curPlayMusicList.count == 0) {
        return nil;
    }
    
    switch (_playMode) {
        case kPlayModeAllLoop:
            nextMusic = [self allLoopNextMusic];
            break;
        case kPlayModeRandom:
            nextMusic = [self randomNextMusic];
            break;
        case kPlayModeSequence:
            nextMusic = [self sequenceNextMusic];
            break;
        default:
            break;
    }

    _nextPlayMusic = nextMusic;
    return _nextPlayMusic;
}

#pragma mark 全部循环的模式下取得下一首歌曲
-(NKMusicModel*)allLoopNextMusic{
    NKMusicModel* nextMusic = nil;
    
    if (_curPlayMusic == nil) {
        //在对NSArray进行取值的时候，要注意边界的判断，否则程序很容易崩溃
        //程序的健壮型差。
        nextMusic = _curPlayMusicList[0];
    }else{
        if (_curPlayMusicList.count == 1) {
            nextMusic = _curPlayMusic;
        }else{
            NSInteger curIndex = [_curPlayMusicList indexOfObject:_curPlayMusic];
            if(curIndex+1 <= _curPlayMusicList.count-1)
            {
                nextMusic = _curPlayMusicList[curIndex+1];
            }else{
                nextMusic = _curPlayMusicList[0];
            }
        }
    }
    return nextMusic;
}

#pragma mark 随机播放的模式下取得下一首歌曲
-(NKMusicModel*)randomNextMusic{
    NKMusicModel* nextMusic = nil;
    
    //在对NSArray进行取值的时候，要注意边界的判断，否则程序很容易崩溃
    //程序的健壮型差。
    NSInteger randomIndex = arc4random()%_curPlayMusicList.count;
    nextMusic = _curPlayMusicList[randomIndex]; //应该随机 个随机随机数，范围<count 大于等于0
    return nextMusic;
    
}

#pragma mark 顺序播放的模式下取得下一首歌曲
-(NKMusicModel*)sequenceNextMusic{
    NKMusicModel* nextMusic = nil;
    
    if (_curPlayMusic == nil) {
        //在对NSArray进行取值的时候，要注意边界的判断，否则程序很容易崩溃
        //程序的健壮型差。
        nextMusic = _curPlayMusicList[0];
    }else{
        if (_curPlayMusicList.count == 1) {
            nextMusic = _curPlayMusic;
        }else{
            NSInteger curIndex = [_curPlayMusicList indexOfObject:_curPlayMusic];
            if(curIndex+1 <= _curPlayMusicList.count-1)
            {
                nextMusic = _curPlayMusicList[curIndex+1];
            }else{
                nextMusic = nil;
            }
        }
    }
    return nextMusic;
}

#pragma mark 取得修改当前歌曲的model
-(NKMusicModel *)curPlayMusic{
    if (_curPlayMusic == nil) {
        _curPlayMusic = self.nextPlayMusic;
    }
    return _curPlayMusic;
}

#pragma mark 当前播放音乐在总列表中的位置 index
-(NSInteger)curPlayMusicIndex{
    //1.得到整个的音乐列表
    NSArray* allListArray = [NKPlayListTool sharedNKPlayListTool].curPlayMusicList;
    //2.得到当前的音乐
    NKMusicModel* curMusic = [NKPlayListTool sharedNKPlayListTool].curPlayMusic;
    //3.利用当前的音乐定位当前音乐在整个音乐列表中的位置
    NSInteger row = [allListArray indexOfObject:curMusic];
    return row;
}

#pragma mark 删除列表选中项
-(void)deleteMuiscList{
    //删除功能
    NSArray* alllist =  [[NKPlayListTool sharedNKPlayListTool].curPlayMusicList copy];
    
    for (NKMusicModel* mode in alllist) {
        if (mode.willBeDelete == YES) {
            [_curPlayMusicList removeObject:mode];
        }
    }
}

#pragma mark 从音乐列表删除一首歌曲
-(void)deleteOneMusicFromLocList:(NKMusicModel *)music{
    [_curPlayMusicList removeObject:music];
}

#pragma mark 全选或者全不选设定
-(void)allCheck:(BOOL)allCheck{
    NSArray* alllist =  [NKPlayListTool sharedNKPlayListTool].curPlayMusicList;
    for (NKMusicModel* mode in alllist) {
        mode.willBeDelete = allCheck;
    }
}

#pragma mark 将本地音乐列表归档到文件中
-(void)saveLocPlayListToDocument{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentPath = paths[0];
    
    NSString* locMuiscListFile = [documentPath stringByAppendingPathComponent:@"locMusicList.data"];
    //NSLog(@"%@", locMuiscListFile);
    //将本地音乐列表归档到locMuiscListFile中，这个文件位于sandBox的Document路径下
    [NSKeyedArchiver archiveRootObject:_allLocMusicList toFile:locMuiscListFile];
}


#pragma mark 在程序即将结束的时候归档 将下载管理列表归档到文件中
-(void)saveLoadPlayListToDocument{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentPath = paths[0];
    
    NSString* locMuiscListFile = [documentPath stringByAppendingPathComponent:@"loadMusicList.data"];
   NSLog(@"%@", locMuiscListFile);
    NSLog(@"-----------------");
    NSLog(@"save count is %zi",_loadMuiscList.count);
    //将本地音乐列表归档到locMuiscListFile中，这个文件位于sandBox的Document路径下
    [NSKeyedArchiver archiveRootObject:_loadMuiscList toFile:locMuiscListFile];
}
#pragma mark 从音乐列表归档到文件读取当前播放列表
-(NSMutableArray*)getLocPlayListFromDocument{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = paths[0];
    NSString* locMuiscListFile = [documentPath stringByAppendingPathComponent:@"locMusicList.data"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:locMuiscListFile]) {
        _allLocMusicList =  [NSKeyedUnarchiver unarchiveObjectWithFile:locMuiscListFile];
    }else{
        [self searchAllMusicList];
    }
    return _allLocMusicList;
}


#pragma mark 解档  从文件里面读取数据到下载的list数组
-(NSMutableArray*)getLoadPlayListFromDocument{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = paths[0];
    NSString* locMuiscListFile = [documentPath stringByAppendingPathComponent:@"loadMusicList.data"];
    NSLog(@"path %@",locMuiscListFile);
    if ([[NSFileManager defaultManager] fileExistsAtPath:locMuiscListFile]) {
        _loadMuiscList =  [NSKeyedUnarchiver unarchiveObjectWithFile:locMuiscListFile];
    }else{
       // [self searchAllMusicList];
    }
    NSLog(@"get %zi",_loadMuiscList.count);
    return _loadMuiscList;
}
-(NSDictionary *)curGeciDict{
    
    NSURL* geciURL = [[NSBundle mainBundle]URLForResource:_curPlayMusic.geci withExtension:nil];
    
    NSString* geciStr = [NSString stringWithContentsOfURL:geciURL encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* geciArray = [geciStr componentsSeparatedByString:@"\n"];
    NSLog(@"geic Str %@ %li", geciArray, geciArray.count);
    
    NSMutableArray* realGeciArray = [NSMutableArray array];
    NSMutableArray* timeGeciArray = [NSMutableArray array];
    for (NSString* str in geciArray) {
        NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
        
        NSArray* oneLineArray = [str componentsSeparatedByCharactersInSet:set];
        if (oneLineArray.count == 1) {
            [realGeciArray addObject:@""];
        }else{
            [realGeciArray addObject:oneLineArray[2]];
            [timeGeciArray addObject:oneLineArray[1]];
        }
    }

    NSLog(@"timeArray %@", timeGeciArray);
    
    NSDictionary* curGeciDict = @{@"time":timeGeciArray, @"real":realGeciArray};
    return curGeciDict;
}

#pragma mark 加载一首歌曲到我喜欢列表
-(void)addOneMusicToMyLoveList:(NKMusicModel *)mode{
    for (NKMusicModel* cmpmode in _myLoveMuiscList) {
        if ([cmpmode.name isEqualToString:mode.name]) {
            return;
        }
    }
    mode.eidtBarShow = NO;
    [_myLoveMuiscList addObject:mode];
}

#pragma mark 从我喜欢列表中删除一首歌曲
-(void)deleteOneMusicFromMyLoveList:(NKMusicModel *)music{
    for (NKMusicModel* cmpmode in _myLoveMuiscList) {
        if ([cmpmode.name isEqualToString:music.name]) {
            [_myLoveMuiscList removeObject:cmpmode];
            return;
        }
    }
}

#pragma mark 将我喜欢音乐列表归档到文件中
-(void)saveMyLoveListToDocument{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentPath = paths[0];
    
    NSString* myLoveMuiscListFile = [documentPath stringByAppendingPathComponent:@"myLoveList.data"];
    //NSLog(@"%@", _myLoveMuiscList);
    //将本地音乐列表归档到locMuiscListFile中，这个文件位于sandBox的Document路径下
    [NSKeyedArchiver archiveRootObject:_myLoveMuiscList toFile:myLoveMuiscListFile];
}

#pragma mark 从我喜欢音乐列表归档到文件读取我喜欢列表
-(NSMutableArray*)getMyLoveListFromDocument{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = paths[0];
    NSString* myLoveMuiscListFile = [documentPath stringByAppendingPathComponent:@"myLoveList.data"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:myLoveMuiscListFile]) {
        _myLoveMuiscList =  [NSKeyedUnarchiver unarchiveObjectWithFile:myLoveMuiscListFile];
    }
    return _myLoveMuiscList;
}

#pragma mark 删除我喜欢列表选中项(批量删除)
-(void)deleteMuiscFromMyLoveList{
    //删除功能
    NSArray* alllist =  [_myLoveMuiscList copy];
    
    for (NKMusicModel* mode in alllist) {
        if (mode.willBeDelete == YES) {
            [_myLoveMuiscList removeObject:mode];
        }
    }
}

#pragma mark 歌曲编辑状态复位，隐藏
-(void)resetAllStatus{
    for (NKMusicModel* mode in _curPlayMusicList) {
        mode.eidtBarShow = NO;
        mode.willBeDelete = NO;
    }
}

@end
