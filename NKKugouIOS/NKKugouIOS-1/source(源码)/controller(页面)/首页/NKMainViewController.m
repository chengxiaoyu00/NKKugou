//
//  NKMainViewController.m
//  NKKugouIOS-1
//
//  Created by hegf on 14-12-29.
//  Copyright (c) 2014年 hegf. All rights reserved.
//

#import "NKMainViewController.h"
#import "NSArray+NKPList.h"
#import "UIViewController+NKStroyBoard.h"
#import "NKPlayBar.h"
//区别不同模式的枚举类型
typedef enum musicMode
{
    musicModeLocal,
    musicModeWeb,
    musicModeMore

}musicMode;
@interface NKMainViewController ()
{
    NSArray* _myMusicListSelArray;
     NSArray* _webMusicListSelArray;
    UITableViewCell* _curselCell;
    musicMode _mode;
}

- (IBAction)userLogin:(UIButton *)sender;
- (IBAction)userMessage:(UIButton *)sender;
- (IBAction)userRegist:(UIButton *)sender;
- (IBAction)wifiSwitch:(UIButton *)sender;
- (IBAction)myMusic:(UIButton *)sender;
- (IBAction)webMusic:(UIButton *)sender;
- (IBAction)MoreMuisc:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *myMusicIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *moreMusicIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *webMusicIndicator;

@end

@implementation NKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置指示器的显示 初始化默认显示我的音乐指示器
    [self setIndictor];
    
    NSArray* myMusicListSelArray = [NSArray arrayWithPlist:@"myMusicSelList.plist"];
    _myMusicListSelArray = myMusicListSelArray;
    
    
    //网络选择数组
    NSArray* webMusicListSelArray = [NSArray arrayWithPlist:@"webMusicSelList.plist"];
    _webMusicListSelArray = webMusicListSelArray;
    
    //隐藏footerView
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.navigationItem.title = @"主页";
    
}

//主页控制器显示时隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

//隐藏stausBar
-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark 设置指示器的显示
- (void)setIndictor{
    if (_mode == musicModeLocal) {
        self.myMusicIndicator.hidden = NO;
        self.webMusicIndicator.hidden = YES;
        self.moreMusicIndicator.hidden = YES;
        
    }
    
    else if (_mode == musicModeWeb)
    {
        self.myMusicIndicator.hidden = YES;
        self.webMusicIndicator.hidden = NO;
        self.moreMusicIndicator.hidden = YES;
    }
    else
    {
        self.myMusicIndicator.hidden = YES;
        self.webMusicIndicator.hidden = YES;
        self.moreMusicIndicator.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_mode) {
        case musicModeLocal:
        {
            return _myMusicListSelArray.count;
            break;
        }
        case musicModeWeb:
        {
            return _webMusicListSelArray.count;
            break;
        }
       default:
            return 0;
            break;
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    switch (_mode) {
        case musicModeLocal:
        {
            cell.textLabel.text = _myMusicListSelArray[indexPath.row];

            break;
        }
        case musicModeWeb:
        {
             cell.textLabel.text = _webMusicListSelArray[indexPath.row];
            break;
        }
        default:
             cell.textLabel.text = _webMusicListSelArray[indexPath.row];
            break;
    }

    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //1.把上一个选中的cell的颜色变成白色
    if (_curselCell != nil) {
         _curselCell.textLabel.textColor = [UIColor whiteColor];
    }
    
    //2.当前的cell变成黄色
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor yellowColor];
    
    //3. 更新当前选中的cell
    _curselCell  = cell;

    NSLog(@"%zi, %zi", indexPath.section, indexPath.row);
    switch (_mode) {
        case musicModeLocal:
            [self handleLocalMusic:indexPath.row];
            break;
        case musicModeWeb:
            [self handleWebMusic:indexPath.row];

            break;
        case musicModeMore:
            [self handleWebMusic:indexPath.row];
            break;
        default:
            break;
    }
   
}
-(void)handleLocalMusic:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            //切换到本地音乐控制器
            UIViewController* vc = [UIViewController viewControllerWithStoryBoradID:@"NKLocalMusicViewController1"];
            
            
            //利用属于自己的导航控制器切换到指定的控制器 本地音乐控制器
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
            NSLog(@"我喜欢");
            [self performSegueWithIdentifier:@"myLovePush" sender:self];
            break;
        case 2:
            NSLog(@"收藏列表");
            [self performSegueWithIdentifier:@"saveListPush" sender:self];
            break;
        case 3:
            NSLog(@"下载管理");
            [self performSegueWithIdentifier:@"main2load" sender:self];
            break;
        case 4:
            NSLog(@"最近播放");
            [self performSegueWithIdentifier:@"main2zuiijn" sender:self];
            
            break;
        case 5:
            [self performSegueWithIdentifier:@"mvPush" sender:self];
            break;
        default:
            break;
    }

}

-(void)handleWebMusic:(NSInteger)row
{
    switch (row) {
        case 0:
        {
//            //切换到Geshou控制器
//            UIViewController* vc = [UIViewController viewControllerWithStoryBoradID:@"geshouViewController"];
//            
//            
//            //利用属于自己的导航控制器切换到指定的控制器 本地音乐控制器
//            [self.navigationController pushViewController:vc animated:YES];
            
            
              [self performSegueWithIdentifier:@"main2geshou" sender:self];
            break;
        }
        case 1:
           // NSLog(@"电台");
          [self performSegueWithIdentifier:@"main2diantai" sender:self];
            break;
       
        default:
            break;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"mvPush"])
    {
        [NKPlayBar sharedPlayBar].hidden = YES;
    }
}

#pragma mark 用户登录
- (IBAction)userLogin:(UIButton *)sender {
    NSLog(@"user Login");
}

#pragma mark 用户信息
- (IBAction)userMessage:(UIButton *)sender {
    NSLog(@"用户信息");
}

#pragma mark 用户注册
- (IBAction)userRegist:(UIButton *)sender {
    NSLog(@"user 注册");
}

#pragma mark wifi切换
- (IBAction)wifiSwitch:(UIButton *)sender {
    NSLog(@"wifi 切换");
}

#pragma mark 我的音乐
- (IBAction)myMusic:(UIButton *)sender {
   // NSLog(@"我的音乐");
    //模式更新
    _mode = musicModeLocal;
    //刷新
    [_tableView reloadData];
    
    //指示器修改
    [self setIndictor];
}

#pragma mark 网络音乐
- (IBAction)webMusic:(UIButton *)sender {
    //NSLog(@"网络音乐");
       //模式更新
    _mode = musicModeWeb;
    //刷新
    [_tableView reloadData];

    //指示器修改
    [self setIndictor];
}

#pragma mark 更多功能
- (IBAction)MoreMuisc:(UIButton *)sender {
    NSLog(@"更多功能");
}
@end
