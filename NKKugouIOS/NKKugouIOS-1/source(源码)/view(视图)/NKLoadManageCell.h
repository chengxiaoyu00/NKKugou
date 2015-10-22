//
//  NKLoadManageCell.h
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKMusicModel.h"
#import "NKLoadMusicModel.h"
//1.声明代理 设计代理方法
@class NKLoadManageCell;

@protocol NKLoadManageCellDelegate <NSObject>
@optional
-(void)loadManageCell:(NKLoadManageCell*)tableViewCell btnClick:(UIButton*)btn;
@end


@interface NKLoadManageCell : UITableViewCell

@property (weak, nonatomic) UILabel* musicNameLabel;

@property (weak, nonatomic)  UIButton* loadButton;
@property(nonatomic,weak)UIProgressView* progressView;


@property(nonatomic,strong)NKLoadMusicModel* model;

@property (assign,nonatomic,getter=isDownLoading) BOOL downLoading ;

+(instancetype)loadManageWithTableView:(UITableView*)tableView;

//2.属性中声明代理实例
@property (strong, nonatomic) id<NKLoadManageCellDelegate> delegate;
@end