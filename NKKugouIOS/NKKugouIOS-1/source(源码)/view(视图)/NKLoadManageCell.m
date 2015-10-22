//
//  NKLoadManageCell.m
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKLoadManageCell.h"
#import "UIView+NKMoreAttribute.h"
#import "NKLoadMusicModel.h"
#import "UIProgressView+AFNetworking.h"
@implementation NKLoadManageCell

+ (instancetype)loadManageWithTableView:(UITableView *)tableView
{
    static NSString* ID = @"loadManageCell";
    
    NKLoadManageCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NKLoadManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //自定义contentView
        [self setupContentView];
    }
    return self;
}

#pragma mark 自定义contentView
-(void)setupContentView{
    
    //下载使用的按钮
    UIButton* Button = [[UIButton alloc ]init];
    [Button setTitle:@"下载" forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(loadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [Button setBackgroundColor:[UIColor greenColor]];
    [self.contentView addSubview:Button];
    _loadButton = Button;
    
    //2.做Label 负责显示歌曲名称
    //3.做Label 负责歌手名称
    UILabel* musicNameLable = [[UILabel alloc]init];
    [self.contentView addSubview:musicNameLable];
    _musicNameLabel = musicNameLable;
    
    
    //3.下载进度
    UIProgressView * progress = [[UIProgressView alloc]init];
    _progressView = progress;
    [self.contentView addSubview:progress];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     _musicNameLabel.frame = CGRectMake(0, 0, 100, 22);
   
    _loadButton.frame = CGRectMake(200, 0, 100, 44);
    _progressView.frame = CGRectMake(0, self.height-10, self.width, 10);
}

- (void)loadBtnClick:(UIButton*)btn
{
    //根据具体条件调用代理方法
    if ([_delegate respondsToSelector:@selector(loadManageCell:btnClick:)]) {
        [_delegate loadManageCell:self btnClick:btn         ];
    }
    
}

- (void)setModel:(NKLoadMusicModel *)model
{
    _model = model;
    _musicNameLabel.text = model.model.name;
    
    
    [_progressView setProgressWithDownloadProgressOfTask:model.downloadTask animated:YES];
 }

@end
