//
//  NKMusicModel.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-4.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>
//1.要想把自定义的对象进行归档，遵循NSCoding
@interface NKMusicModel : NSObject <NSCoding>

+(instancetype)musicModelWithDict:(NSDictionary*)dict;
@property (copy, nonatomic) NSString* singer;
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* time;
@property (copy, nonatomic) NSString* index;
@property (copy, nonatomic) NSString* geci;

//标记本歌曲是否时将要被删除的一种状态
@property (assign, nonatomic, getter=iswillBeDelete) BOOL willBeDelete;
@property (assign, nonatomic, getter=iseidtBarShow) BOOL eidtBarShow;

//网络
@property(nonatomic,copy)NSString* imgURL;
+(instancetype)webMusicModelWithDict:(NSDictionary*)dict;
//
//电台
@property(nonatomic,copy)NSString* musicURL;

+(instancetype) diantaiMusicModelWithDictionary:(NSDictionary*)dict;
@end
