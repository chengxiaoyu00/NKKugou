//
//  NKLoadMusicModel.h
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKMusicModel.h"
#import "AFNetworking.h"
@interface NKLoadMusicModel : NSObject
@property(nonatomic,strong)NKMusicModel* model;
@property(nonatomic,strong)AFURLSessionManager *manager;
@property(nonatomic,strong)NSURLSessionDownloadTask *downloadTask;
//@property (strong,nonatomic)  NSProgress * progress;


@end
