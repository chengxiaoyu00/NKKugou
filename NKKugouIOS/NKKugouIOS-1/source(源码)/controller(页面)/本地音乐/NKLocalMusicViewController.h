//
//  NKLocalMusicViewController.h
//  NKKugouIOS-1
//
//  Created by hegf on 14-12-30.
//  Copyright (c) 2014年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKLocMusicTableViewCell.h"
#import "NKSaveListEditView.h"

//代理的使用，1.包含对应的头文件 2.遵循对应的代理协议 3.对应的代理的delegate进行付初值（连线） 4.实现代理方法
@interface NKLocalMusicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NKLocMusicTableViewCellDelegate, NKSaveListEditViewDelegate>

@end
