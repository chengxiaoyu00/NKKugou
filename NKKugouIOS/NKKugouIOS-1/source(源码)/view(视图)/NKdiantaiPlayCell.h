//
//  NKdiantaiPlayCell.h
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKMusicModel.h"
//1.声明代理 设计代理方法
@class NKdiantaiPlayCell;

@protocol NKdiantaiPlayCellDelegate <NSObject>
@optional
-(void)diantaiPlayCell:(NKdiantaiPlayCell*)tableViewCell btnClick:(UIButton*)btn;
@end


@interface NKdiantaiPlayCell : UITableViewCell

@property (weak, nonatomic) UILabel* musicNameLabel;
@property (weak, nonatomic) UILabel* singerLabel;
@property (weak, nonatomic)  UIButton* loadButton;
@property(nonatomic,weak)UIImageView* imgView;


@property(nonatomic,strong)NKMusicModel* model;


+(instancetype)diantaiPlayCellWithTableView:(UITableView*)tableView;

//2.属性中声明代理实例
@property (strong, nonatomic) id<NKdiantaiPlayCellDelegate> delegate;
@end
