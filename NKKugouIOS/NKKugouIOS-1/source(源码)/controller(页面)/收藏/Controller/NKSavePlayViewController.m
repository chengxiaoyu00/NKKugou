//
//  NKSavePlayViewController.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-15.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKSavePlayViewController.h"
#import "NSArray+NKPList.h"
#import <AVFoundation/AVFoundation.h>
#import "NKMusicModel.h"
#import "NKPlayerTool.h"
#import "UIButton+NKImage.h"
#import "UIBarButtonItem+NKBarItem.h"
#import "NKPlayListTool.h"
#import "NKEditBar.h"
#import "NKEditBarItem.h"
#import "NKPlayBar.h"
#import "KxMenu.h"
#import "NKGeciViewController.h"
#import "NKSaveListTool.h"

@interface NKSavePlayViewController ()
{
    NKEditBar* _editBar;
    BOOL _isEditBarShow;
}
@property (weak, nonatomic) IBOutlet UITableView *savePlayTableView;


@end

@implementation NKSavePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定义导航栏
    [self setupNavBar];

    
    //1.拿出来原来的frame
    CGRect frame = _savePlayTableView.frame;
    //2.修改部分属性
    frame.size.height = [UIScreen mainScreen].applicationFrame.size.height*(568.0-22.0)/568.0;
    //3.设置回来
    _savePlayTableView.frame = frame;
    
    //设置编辑栏
    [self setupEditBar];
    
    //tableView的Cell之间的分割线去掉
    _savePlayTableView.separatorColor = [UIColor clearColor];
    
}

#pragma mark 对本地音乐列表进行加载 从本地音乐对应的归档文件中读取音乐模型，对本地音乐列表进行加载
-(void)viewWillAppear:(BOOL)animated{
    //1.注册接受新的播放歌曲的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusic:) name:@"playMusic" object:nil];
    
    //判断Dcoment路径下有没有收藏列表文件@"allSaveList.data"
    //得到对应的收藏列表的所有歌曲
    NSDictionary* saveListDict = [[NKSaveListTool sharedNKSaveListTool]getSaveListDictWithSaveListName:self.navigationItem.title];
    NSMutableArray* saveListMuiscList = saveListDict[@"musicList"];

    //将我喜欢列表拷贝到当前播放音乐列表中。
    //不是用mutableCopy 好处在于 对当前音乐列表进行删除等管理后，同时能够反应到收藏列表中去
    //方便了收藏列表的管理。
    [NKPlayListTool sharedNKPlayListTool].curPlayMusicList = saveListMuiscList;
}

#pragma mark 对本地音乐列表中的所有音乐模型进行归档，存储到本地音乐文件列表中去
-(void)viewWillDisappear:(BOOL)animated{
    
    [NKPlayBar sharedPlayBar].hidden = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"playMusic" object:nil];
}

#pragma mark 设置编辑栏
-(void)setupEditBar{
    NKEditBarItem *btn1 = [NKEditBarItem editBarItemWithImage:@"loop-2x" title:@"模式" target:self action:@selector(modeSel:)];
    NKEditBarItem *btn2 = [NKEditBarItem editBarItemWithImage:@"allcheck-2x" title:@"全选" target:self action:@selector(allCheck:)];
    NKEditBarItem *btn4 = [NKEditBarItem editBarItemWithImage:@"trash-2x" title:@"删除" target:self action:@selector(deleteList)];
    
    NSArray* editItems = @[btn1, btn2, btn4];
    NKEditBar* editBar = [NKEditBar editBarWithItems:editItems];
    _editBar = editBar;
    CGRect tmpframe = editBar.frame;
    tmpframe.origin.x = 0;
    tmpframe.origin.y = [UIScreen mainScreen].applicationFrame.size.height + 22;
    editBar.frame = tmpframe;
    
    [self.view addSubview:editBar];
    
    _isEditBarShow = NO;
}

#pragma mark 模式选择
-(void)modeSel:(UIButton*)sender{
    NSLog(@"mode Sel");
    [self showMenu:sender];
}

#pragma mark 全部选择
-(void)allCheck:(UIButton*)btn{
    btn.selected = !btn.selected;
    
    //全部选择，所有的表列表中的歌曲我将要删除，更新列表中模型的状态willBeDelete
    [[NKPlayListTool sharedNKPlayListTool]allCheck:btn.selected];
    
    //刷新tableView
    [_savePlayTableView reloadData];
}

#pragma mark 模式选择
-(void)deleteList{
    //删除功能
    [[NKPlayListTool sharedNKPlayListTool]deleteMuiscList];

    [_savePlayTableView reloadData];
}

//2.接受新的播放歌曲的通知，并作处理
-(void)playMusic:(NSNotification*)notify{
    NSLog(@"接受到了新的音乐");
    //根据当前播放的歌曲切换到对应的cell
    
    //让tableView 选中某一行
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[NKPlayListTool sharedNKPlayListTool].curPlayMusicIndex inSection:0];
    
    //切换到指定的indexPath那一行，保持选中行在屏幕的中央
    [_savePlayTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}


#pragma mark 定义导航栏
-(void)setupNavBar{
    
    UIBarButtonItem* editItem = [UIBarButtonItem barButtonItemWithNormalImage:@"pencil-2x"  selectedImage:@"pencil-2x" target:self action:@selector(showEditBar:)];
    
    UIBarButtonItem* geciItem = [UIBarButtonItem barButtonItemWithNormalImage:@"musical-geci-2x"  selectedImage:@"musical-geci-2x" target:self action:@selector(geciVCPush)];
    
    
    NSArray* array = @[editItem, geciItem];
    
    self.navigationItem.rightBarButtonItems = array;
}

#pragma mark 切换到歌词界面
-(void)geciVCPush{
    //通过Segue切换界面，Identifier是在storyBaord中设置，一定要完全一致
    [self performSegueWithIdentifier:@"savePlayGeciPush" sender:self];
}

#pragma mark 显示或者隐藏编辑栏
-(void)showEditBar:(UIBarButtonItem*)item{
    _isEditBarShow = !_isEditBarShow;
    if (_isEditBarShow) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect frame = _editBar.frame;
            frame.origin.y = frame.origin.y - 44;
            _editBar.frame = frame;
        } completion:nil];
        //PlayBar应该隐藏
        [NKPlayBar sharedPlayBar].hidden = YES;
    }else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect frame = _editBar.frame;
            frame.origin.y = frame.origin.y + 44;
            _editBar.frame = frame;
        } completion:^(BOOL finished) {
            //PlayBar应该显示
            [NKPlayBar sharedPlayBar].hidden = NO;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NKPlayerTool sharedNKPlayerTool] playMusic:[NKPlayListTool sharedNKPlayListTool].curPlayMusicList[indexPath.row]];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //返回有几首音乐model的数量  封装成model的好处，面向对象编程，代替面向dict编程
    return [NKPlayListTool sharedNKPlayListTool].curPlayMusicList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //View
    NKSavePlayTableViewCell* cell = [NKSavePlayTableViewCell savePlayTableViewCellWithTableView:tableView];
    
    //对Cell代理进行"连线"
    cell.delegate = self;
    
    //model设置给Cell
    NKMusicModel* mode = [NKPlayListTool sharedNKPlayListTool].curPlayMusicList[indexPath.row];
    //cell所在整个List的位置
    cell.indexPath = indexPath;
    
    //frame跟模型修改frame
    cell.leftButton.selected = mode.willBeDelete;
    cell.rightButton.selected = mode.eidtBarShow;
    cell.editBar.hidden = !mode.eidtBarShow;
    cell.musicNameLabel.text = mode.name;
    
    return cell;
}

#pragma mark 本地音乐Cell的代理方法，用于cell的EditBar显示隐藏时更新tableView
-(void)savePlayTableViewCell:(NKSavePlayTableViewCell *)tableViewCell didUpdateTableView:(NSIndexPath *)indexPath{
    [_savePlayTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NKMusicModel* mode = [NKPlayListTool sharedNKPlayListTool].curPlayMusicList[indexPath.row];
    return mode.iseidtBarShow?(2*kHeightRatio*kScreenHeight):(kHeightRatio*kScreenHeight);
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"全部循环"
                     image:[UIImage imageNamed:@"loop-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"随机播放"
                     image:[UIImage imageNamed:@"random-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"顺序播放"
                     image:[UIImage imageNamed:@"seqence-2x"]
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    
    CGRect frame = sender.frame;
    
    frame.origin.y = self.view.frame.size.height - sender.frame.size.height;
    [KxMenu setTintColor:[UIColor yellowColor]];
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

//根据点击的按钮处理播放模式，进行播放模式的切换
- (void) pushMenuItem:(KxMenuItem*)sender
{
    NSDictionary* dict = @{@"全部循环":@0, @"随机播放":@1, @"顺序播放":@2};
    NSInteger index = [(NSString*)dict[sender.title] integerValue];
    [NKPlayListTool sharedNKPlayListTool].playMode = (PlayMode)index;
}

@end