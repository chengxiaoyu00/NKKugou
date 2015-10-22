//
//  NKSaveListTool.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-14.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKSaveListTool.h"

#define MAXListNumber 10

static NKSaveListTool* tool;

@implementation NKSaveListTool

+(instancetype)sharedNKSaveListTool{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[NKSaveListTool alloc]init];
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

-(instancetype)init{
    self = [super init];
    if (self) {
        _allSaveListArray = [NSMutableArray array];
        //追加一个默认收藏列表
        NSMutableArray* defaultSaveListArray = [NSMutableArray array];
        NSDictionary* defultSaveListDict = @{@"name":@"默认收藏", @"musicList":defaultSaveListArray};
        [_allSaveListArray addObject:defultSaveListDict];
        
        _curSelSaveList = [NSDictionary dictionary];
    }
    return self;
    
}

#pragma mark 添加一个收藏列表
-(void)addOneSaveListToAllSaveList:(NSString*)saveListName{
    if (saveListName.length == 0) {
        return;
    }
    if (_allSaveListArray.count == 10) {
        return;
    }
    for (NSDictionary* dict in _allSaveListArray) {
        if ([dict[@"name"] isEqualToString:saveListName]) {
            return;
        }
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:saveListName forKey:@"name"];
    NSMutableArray* musicListArray = [NSMutableArray array];
    [dict setObject:musicListArray forKey:@"musicList"];
    [_allSaveListArray addObject:dict];
    
}
#pragma mark 删除一个收藏列表
-(void)removeOneSaveListFromAllSaveList:(NSString*)saveListName{
    if ([_allSaveListArray[0][@"name"] isEqualToString:saveListName]) {
        return;
    }
    for (NSDictionary* dict in _allSaveListArray) {
        if ([dict[@"name"] isEqualToString:saveListName]) {
            [_allSaveListArray removeObject:dict];
        }
    }
}

#pragma mark 将所有的收藏列表归档到allSaveList.data
-(void)saveAllSaveListToDocument{
    NSArray* allSaveList = [_allSaveListArray mutableCopy];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentPath = paths[0];
    
    NSString* allSaveListFile = [documentPath stringByAppendingPathComponent:@"allSaveList.data"];
   // NSLog(@"%@", allSaveListFile);
    
    [NSKeyedArchiver archiveRootObject:allSaveList toFile:allSaveListFile];
}

#pragma mark  从归档文件allSaveList.data中取得所有的收藏列表
-(NSMutableArray*)getAllSaveListFromDocument{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = paths[0];
    NSString* allSaveListFile = [documentPath stringByAppendingPathComponent:@"allSaveList.data"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:allSaveListFile]) {
       _allSaveListArray =  [NSKeyedUnarchiver unarchiveObjectWithFile:allSaveListFile];
    }
    
    return _allSaveListArray;
    
}

-(NSDictionary *)getSaveListDictWithSaveListName:(NSString *)listName{
    for (NSDictionary* dict in _allSaveListArray) {
        if ([dict[@"name"] isEqualToString:listName]) {
             return dict;
        }
    }
    return nil;
}

-(void)addOneMusicToSelSaveList:(NKMusicModel*)mode{
    //音乐加对了
    //_willBeSaveMode;
    //列表得选对了
    BOOL saveflag = YES;
    NSMutableArray* musicListArray = _curSelSaveList[@"musicList"];
    for (NKMusicModel* cmpmode in musicListArray) {
        if ([cmpmode.name isEqualToString:mode.name]) {
            saveflag = NO;
            break;
        }
    }
    if (saveflag == YES) {
        mode.eidtBarShow = NO;
        [musicListArray addObject:mode];
    }
    
}

@end
