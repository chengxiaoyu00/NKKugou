//
//  NKdiantaiPlayCell.m
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKdiantaiPlayCell.h"
#import "UIImageView+WebCache.h"
@implementation NKdiantaiPlayCell
+ (instancetype)diantaiPlayCellWithTableView:(UITableView *)tableView
{
    static NSString* ID = @"diantaiCell";
    
    NKdiantaiPlayCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NKdiantaiPlayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    
      //3.做Label 负责歌手名称
    UILabel* singerLable = [[UILabel alloc]init];
    [self.contentView addSubview:singerLable];
    _singerLabel = singerLable;
    
    UIImageView * img = [[UIImageView alloc]init];
    [self.contentView addSubview:img];
    _imgView = img;
  
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imgView.frame = CGRectMake(0, 0, 44, 44);
    _musicNameLabel.frame = CGRectMake(50, 0, 100, 22);
    _singerLabel.frame = CGRectMake(50, 23, 100, 22);
    _loadButton.frame = CGRectMake(200, 0, 100, 44);
}

- (void)loadBtnClick:(UIButton*)btn
{
    //根据具体条件调用代理方法
    if ([_delegate respondsToSelector:@selector(diantaiPlayCell:btnClick:)]) {
        [_delegate diantaiPlayCell:self btnClick:btn
         ];
    }

}

- (void)setModel:(NKMusicModel *)model
{
    _model = model;
    _musicNameLabel.text = model.name;
    _singerLabel.text = model.singer;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"play_bar_singerbg"]];
}
@end
