//
//  NKGeciViewController.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-9.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKGeciViewController.h"
#import "NKPlayListTool.h"

@interface NKGeciViewController ()
{
    NSArray* _geciArray;
    NSIndexPath* _curIndexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *geciTableView;

@end

@implementation NKGeciViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"678686");
    // Do any additional setup after loading the view.
    _geciTableView.separatorColor = [UIColor clearColor];
    
    //调整导航栏不遮挡TableView
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"歌词";
    
}

-(void)viewDidAppear:(BOOL)animated{
    //解析歌词
    //取得歌词信息的功能封装到工具类中，使用工具类方法取得
    _geciArray = [NKPlayListTool sharedNKPlayListTool].curGeciDict[@"real"];
    
    [_geciTableView reloadData];
    
    [NKPlayBar sharedPlayBar].delegate = self;
    
    _curIndexPath = nil;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateGeci) name:@"updateGeci" object:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    //解决首次直接进入歌词界面，然后返回到本地音乐，播放歌曲出现崩溃的bug
    [NKPlayBar sharedPlayBar].delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateGeci" object:self];
}

-(void)updateGeci{
    _geciArray = [NKPlayListTool sharedNKPlayListTool].curGeciDict[@"real"];
    [_geciTableView reloadData];
}

-(void)playBar:(NKPlayBar *)playBar didGeciChanged:(NSInteger)index{
    //根据匹配的歌词Index，更新TableView
    index+=1;
    if (_curIndexPath!=nil) {
        UITableViewCell* cell = [_geciTableView cellForRowAtIndexPath:_curIndexPath];
        cell.textLabel.textColor = [UIColor whiteColor];
    }

    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_geciTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    UITableViewCell* cell = [_geciTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor yellowColor];
    
    _curIndexPath = indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"geciCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = _geciArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _geciArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

@end
