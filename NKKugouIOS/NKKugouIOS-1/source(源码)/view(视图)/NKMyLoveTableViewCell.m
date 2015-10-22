//
//  NKMyLoveTableViewCell.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-13.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKMyLoveTableViewCell.h"
#import "NKMusicModel.h"
#import "NKPlayListTool.h"
#import "NKEditBar.h"
#import "NKEditBarItem.h"

@implementation NKMyLoveTableViewCell

+(instancetype)myLoveTableViewCellWithTableView:(UITableView*)tableView{
    
    static NSString* ID = @"myLoveCell";
    
    NKMyLoveTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NKMyLoveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UIButton* leftButton = [UIButton buttonWithNormalImage:@"all_favorite_btn_check_on_default" selectedImage:@"all_favorite_btn_check_on_pressed" target:self action:@selector(leftButtonClicked:)];
    leftButton.frame = CGRectMake(0, 0, kScreenWidth*kWidthRatio, kScreenHeight*kHeightRatio);
    [self.contentView addSubview:leftButton];
    _leftButton = leftButton;
    
    //2.做一个Label 负责显示歌曲名称
    UILabel* midLable = [[UILabel alloc]init];
    CGFloat midLableX = leftButton.right;
    CGFloat midLableY = 0;
    CGFloat midLableW = self.width - 2*leftButton.width;
    CGFloat midLableH = kScreenHeight*kHeightRatio;
    
    midLable.frame = CGRectMake(midLableX, midLableY, midLableW, midLableH);
    [self.contentView addSubview:midLable];
    _musicNameLabel = midLable;
    
    UIButton* rightButton = [UIButton buttonWithNormalImage:@"arrow_down" selectedImage:@"arrow_up" target:self action:@selector(rightButtonClicked:)];
    CGFloat rightButtonX = midLable.right;
    
    rightButton.frame = CGRectMake(rightButtonX, 0, kWidthRatio*kScreenWidth, kHeightRatio*kScreenHeight);
    [self.contentView addSubview:rightButton];
    _rightButton = rightButton;
    
    //加上cell的编辑栏
    [self setupEditBar];
}

#pragma mark 设置编辑栏
-(void)setupEditBar{
    NKEditBarItem *btn2 = [NKEditBarItem editBarItemWithImage:@"allcheck-2x" title:@"收藏" target:self action:@selector(saveList)];
    NKEditBarItem *btn3 = [NKEditBarItem editBarItemWithImage:@"headphones-2x" title:@"删除" target:self action:@selector(deleteMuisc)];
    NKEditBarItem *btn4 = [NKEditBarItem editBarItemWithImage:@"info-2x" title:@"信息" target:self action:@selector(infoShow)];
    
    NSArray* editItems = @[btn2, btn3, btn4];
    NKEditBar* editBar = [NKEditBar editBarWithItems:editItems];
    _editBar = editBar;
    
    _editBar.frame = CGRectMake(0, _leftButton.bottom, self.width, self.height);
    
    [self.contentView addSubview:editBar];
    
}

#pragma mark 将对应的歌曲添加到收藏列表，可以新建收藏列表也可以选择添加到即有的收藏列表
-(void)saveList{
    //点击收藏按钮时，把收藏列表萌版，覆盖到本地音乐的view上边去。
    if ([_delegate respondsToSelector:@selector(myLoveTableViewCell:didShowSaveListEditView:)]) {
        [_delegate myLoveTableViewCell:self didShowSaveListEditView:_indexPath];
    }
}

#pragma mark 将对应的歌曲从我喜欢列表中删除
-(void)deleteMuisc{
    NKMusicModel* mode =  [NKPlayListTool sharedNKPlayListTool].curPlayMusicList[_indexPath.row];
    NSLog(@"curPlayList %@ index %li", [NKPlayListTool sharedNKPlayListTool].curPlayMusicList, _indexPath.row);
    [[NKPlayListTool sharedNKPlayListTool]deleteOneMusicFromMyLoveList:mode];
    [[NKPlayListTool sharedNKPlayListTool]deleteOneMusicFromLocList:mode];
    if ([_delegate respondsToSelector:@selector(myLoveTableViewCell:didUpdateTableView:)]) {
        [_delegate myLoveTableViewCell:self didUpdateTableView:_indexPath];
    }
}

#pragma mark 将对应的歌曲信息进行显示
-(void)infoShow{
    //歌曲的信息保存在模型中
    NKMusicModel* mode =  [NKPlayListTool sharedNKPlayListTool].curPlayMusicList[_indexPath.row];
    
    NSMutableString* infoStr = [[NSMutableString alloc]init];
    [infoStr appendString:mode.name];
    [infoStr appendString:@"\n"];
    [infoStr appendString:mode.singer];
    [infoStr appendString:@"\n"];
    [infoStr appendString:mode.time];
    
    UIAlertView* infoView = [[UIAlertView alloc]initWithTitle:@"歌曲信息" message:infoStr delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil];
    
    [infoView show];
}

#pragma mark 选中按钮响应函数
- (void)leftButtonClicked:(UIButton*)btn{
    btn.selected = !btn.selected;
    
    NKMusicModel* mode = [NKPlayListTool sharedNKPlayListTool].curPlayMusicList[_indexPath.row];
    mode.willBeDelete = btn.selected;
}

#pragma mark 下拉菜单按钮响应函数
- (void)rightButtonClicked:(UIButton*)btn{
    btn.selected = !btn.selected;
    
    NKMusicModel* mode = [NKPlayListTool sharedNKPlayListTool].curPlayMusicList[_indexPath.row];
    mode.eidtBarShow = btn.selected;
    _editBar.hidden = !btn.selected;
    
    //3.根据具体条件调用代理方法
    if ([_delegate respondsToSelector:@selector(myLoveTableViewCell:didUpdateTableView:)]) {
        [_delegate myLoveTableViewCell:self didUpdateTableView:_indexPath];
    }
}

@end
