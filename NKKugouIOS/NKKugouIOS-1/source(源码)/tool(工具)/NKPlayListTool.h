//
//  NKPlayListTool.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-5.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKMusicModel.h"

//播放模式的标记
typedef enum {
    kPlayModeAllLoop = 0,
    kPlayModeRandom,
    kPlayModeSequence
}PlayMode;

@interface NKPlayListTool : NSObject
+(instancetype)sharedNKPlayListTool;

//本地音乐的播放列表管理
//1.搜索本地所有音乐
-(void)searchAllMusicList;
////2.创建加载音乐列表
//-(void)loadMusicList;
//3.从音乐列表删除一首歌曲
-(void)deleteOneMusicFromLocList:(NKMusicModel*)music;
//4.删除列表选中项
-(void)deleteMuiscList;
//9.全选或者全不选设定
-(void)allCheck:(BOOL)allCheck;


//将本地音乐列表解档到本地音乐数组中
-(NSMutableArray*)getLocPlayListFromDocument;
@property (strong, nonatomic) NSMutableArray* allLocMusicList;
//把本地音乐列表归档到文件
-(void)saveLocPlayListToDocument;

//5.取得修改当前歌曲的id
@property (strong, nonatomic) NKMusicModel* curPlayMusic;
//6.取得下一首歌曲id
@property (strong, nonatomic) NKMusicModel* nextPlayMusic;
//7.取得本地音乐所有的音乐列表
@property (strong, nonatomic) NSMutableArray* curPlayMusicList;

//歌曲编辑状态复位，隐藏
-(void)resetAllStatus;

//8.当前播放音乐在总列表中的位置 index
@property (assign, nonatomic) NSInteger curPlayMusicIndex;
//播放模式的标记
@property (assign, nonatomic) PlayMode playMode;
@property (strong, nonatomic, readonly) NSDictionary* curGeciDict;

//我喜欢音乐列表
@property (strong, nonatomic) NSMutableArray* myLoveMuiscList;
//加载一首歌曲到我喜欢列表
-(void)addOneMusicToMyLoveList:(NKMusicModel*)mode;
//从我喜欢列表中删除一首歌曲
-(void)deleteOneMusicFromMyLoveList:(NKMusicModel *)music;
//将我喜欢音乐列表归档到文件中
-(void)saveMyLoveListToDocument;
//从我喜欢音乐列表归档到文件读取我喜欢列表
-(NSMutableArray*)getMyLoveListFromDocument;
//删除我喜欢列表选中项(批量删除)
-(void)deleteMuiscFromMyLoveList;


//下载管理
@property (strong, nonatomic) NSMutableArray* loadMuiscList;
//将下载管理列表归档到文件中
-(void)saveLoadPlayListToDocument;
////从文件读取下载管理列表
-(NSMutableArray*)getLoadPlayListFromDocument;
@end
