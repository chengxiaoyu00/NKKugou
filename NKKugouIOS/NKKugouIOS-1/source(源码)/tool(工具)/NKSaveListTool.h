//
//  NKSaveListTool.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-14.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKMusicModel.h"

@interface NKSaveListTool : NSObject
+(instancetype)sharedNKSaveListTool;

//收藏列表 默认至少有一个叫做“默认收藏”的列表
@property (strong, nonatomic) NSMutableArray* allSaveListArray;

//添加一个收藏列表
-(void)addOneSaveListToAllSaveList:(NSString*)saveListName;
//删除一个收藏列表
-(void)removeOneSaveListFromAllSaveList:(NSString*)saveListName;

//将所有的收藏列表归档到allSaveList.data
-(void)saveAllSaveListToDocument;
//从归档文件allSaveList.data中取得所有的收藏列表
-(NSMutableArray*)getAllSaveListFromDocument;

@property (strong, nonatomic) NSDictionary* curSelSaveList;

-(NSDictionary*)getSaveListDictWithSaveListName:(NSString*)listName;

-(void)addOneMusicToSelSaveList:(NKMusicModel*) mode;

@end
