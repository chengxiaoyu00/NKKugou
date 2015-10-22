//
//  NKSavePlayTableViewCell.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-15.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKEditBar.h"

//1.声明代理 设计代理方法
@class NKSavePlayTableViewCell;

@protocol NKSavePlayTableViewCellDelegate <NSObject>

-(void)savePlayTableViewCell:(NKSavePlayTableViewCell*)tableViewCell didUpdateTableView:(NSIndexPath*)indexPath;

@end

@interface NKSavePlayTableViewCell : UITableViewCell
@property (weak, nonatomic) UILabel* musicNameLabel;

+(instancetype)savePlayTableViewCellWithTableView:(UITableView*)tableView;
@property (strong, nonatomic) NSIndexPath* indexPath;
@property (weak, nonatomic)  UIButton* leftButton;
@property (weak, nonatomic)  UIButton* rightButton;
@property (weak, nonatomic) NKEditBar* editBar;

//2.属性中声明代理实例
@property (strong, nonatomic) id<NKSavePlayTableViewCellDelegate> delegate;

@end