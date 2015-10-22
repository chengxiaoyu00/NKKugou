//
//  NKLocMusicTableViewCell.h
//  NKKugouIOS-1
//
//  Created by hegf on 14-12-31.
//  Copyright (c) 2014年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKEditBar.h"

//1.声明代理 设计代理方法
@class NKLocMusicTableViewCell;

@protocol NKLocMusicTableViewCellDelegate <NSObject>

-(void)locMusicTableViewCell:(NKLocMusicTableViewCell*)tableViewCell didUpdateTableView:(NSIndexPath*)indexPath;

//委托给控制器显示收藏编辑的萌版
-(void)locMusicTableViewCell:(NKLocMusicTableViewCell *)tableViewCell didShowSaveListEditView:(NSIndexPath *)indexPath;

@end

@interface NKLocMusicTableViewCell : UITableViewCell
@property (weak, nonatomic) UILabel* musicNameLabel;

+(instancetype)locMusicTableViewCellWithTableView:(UITableView*)tableView;
@property (strong, nonatomic) NSIndexPath* indexPath;
@property (weak, nonatomic)  UIButton* leftButton;
@property (weak, nonatomic)  UIButton* rightButton;
@property (weak, nonatomic) NKEditBar* editBar;

//2.属性中声明代理实例
@property (strong, nonatomic) id<NKLocMusicTableViewCellDelegate> delegate;
@end
