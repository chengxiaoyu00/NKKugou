//
//  NKMusicModel.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-4.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKMusicModel.h"

#define keyName @"name"
#define keySinger @"singer"
#define keyTime @"time"
#define keyIndex @"index"
#define keyGeci @"geci"

#define keyWillBeDelete @"willBeDelete"
#define keyEidtBarShow @"eidtBarShow"


@implementation NKMusicModel
+(instancetype)musicModelWithDict:(NSDictionary *)dict{
    NKMusicModel* mode = [[NKMusicModel alloc]init];
//    mode.name = dict[@"name"];
//    ....
//    ...
    //KVC dict中的key和@pro 要完全一致， 包括dict元素数量不能少
    [mode setValuesForKeysWithDictionary:dict];
    
    return mode;
}
+ (instancetype)diantaiMusicModelWithDictionary:(NSDictionary *)dict
{
     NKMusicModel *model = [[NKMusicModel alloc]init ];
    model.name = dict[@"title"];
      model.imgURL = dict[@"picture"];
      model.singer = dict[@"artist"];
      model.musicURL = dict[@"url"];
      model.time = dict[@"length"];
    return model;
}
+(instancetype)webMusicModelWithDict:(NSDictionary *)dict
{
    NKMusicModel *model = [[NKMusicModel alloc]init ];
   // [model setValuesForKeysWithDictionary:dict];
    //            NSLog(@"title is %@",dict[@"title"]) ;
    //            NSLog(@"singer is %@",dict[@"attrs"][@"singer"][0]) ;
    //             NSLog(@"image is %@",dict[@"image"]) ;
    model.name = dict[@"title"];
    model.singer = dict[@"attrs"][@"singer"][0];
    model.imgURL = dict[@"image"];
    return model;

}
/*
 @property (copy, nonatomic) NSString* singer;
 @property (copy, nonatomic) NSString* name;
 @property (copy, nonatomic) NSString* time;
 @property (copy, nonatomic) NSString* index;
 
 //标记本歌曲是否时将要被删除的一种状态
 @property (assign, nonatomic, getter=iswillBeDelete) BOOL willBeDelete;
 
 */
//2.重写initWithCoder 在从文件中利用NSKeyedUnachiver读取对象数据，还原时候调用
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:keyName];
        _singer = [aDecoder decodeObjectForKey:keySinger];
        _time = [aDecoder decodeObjectForKey:keyTime];
        _index = [aDecoder decodeObjectForKey:keyIndex];
        _geci = [aDecoder decodeObjectForKey:keyGeci];
        _willBeDelete = [aDecoder decodeObjectForKey:keyWillBeDelete];
    }
    return self;
}

//3.重写encodeWithCoder 把对象进行归档，存储到文件中的时候进行编码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_name forKey:keyName];
    [aCoder encodeObject:_singer forKey:keySinger];
    [aCoder encodeObject:_time forKey:keyTime];
    [aCoder encodeObject:_index forKey:keyIndex];
    [aCoder encodeObject:_geci forKey:keyGeci];
    [aCoder encodeBool:_willBeDelete forKey:keyWillBeDelete];
}


@end
