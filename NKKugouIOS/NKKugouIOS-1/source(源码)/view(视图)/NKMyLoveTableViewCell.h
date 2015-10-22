//
//  NKMyLoveTableViewCell.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-13.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKEditBar.h"

//1.声明代理 设计代理方法
@class NKMyLoveTableViewCell;

@protocol NKMyLoveTableViewCellDelegate <NSObject>

-(void)myLoveTableViewCell:(NKMyLoveTableViewCell*)tableViewCell didUpdateTableView:(NSIndexPath*)indexPath;

//委托给控制器显示收藏编辑的萌版
-(void)myLoveTableViewCell:(NKMyLoveTableViewCell *)tableViewCell didShowSaveListEditView:(NSIndexPath *)indexPath;

@end
@interface NKMyLoveTableViewCell : UITableViewCell
@property (weak, nonatomic) UILabel* musicNameLabel;

+(instancetype)myLoveTableViewCellWithTableView:(UITableView*)tableView;
@property (strong, nonatomic) NSIndexPath* indexPath;
@property (weak, nonatomic)  UIButton* leftButton;
@property (weak, nonatomic)  UIButton* rightButton;
@property (weak, nonatomic) NKEditBar* editBar;

//2.属性中声明代理实例
@property (strong, nonatomic) id<NKMyLoveTableViewCellDelegate> delegate;

@end
