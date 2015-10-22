//
//  NKLoadMusicModel.m
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKLoadMusicModel.h"
#define keyModel @"model"
@implementation NKLoadMusicModel
//2.重写initWithCoder 在从文件中利用NSKeyedUnachiver读取对象数据，还原时候调用
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
       // [aDecoder decodeObjectOfClass:[NKMusicModel class] forKey:@"model"];
        _model.name = [aDecoder decodeObjectForKey:@"name"];
        _manager = [aDecoder decodeObjectForKey:@"manager"];
        _downloadTask = [aDecoder decodeObjectForKey:@"downloadTask"];
       
    }
    return self;
}

//3.重写encodeWithCoder 把对象进行归档，存储到文件中的时候进行编码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_model.name forKey:@"name"];


    [aCoder encodeObject:_manager forKey:@"manager"];
    [aCoder encodeObject:_downloadTask forKey:@"downloadTask"];
   }

@end
