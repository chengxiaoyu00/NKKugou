//
//  NKSaveListViewController.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-14.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKSaveListViewController.h"
#import "NKSavePlayViewController.h"
#import "NKSaveListTool.h"
#import "UIBarButtonItem+NKBarItem.h"

@interface NKSaveListViewController ()
{
    NSMutableArray* _saveListArray;
    NSString* _saveListName;
}
@property (weak, nonatomic) IBOutlet UITableView *saveListTableView;

@end

@implementation NKSaveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收藏列表";
    
    _saveListArray = [NSMutableArray array];
    
    
    UIBarButtonItem* deleteButton = [UIBarButtonItem barButtonItemWithNormalImage:@"trash-2x" selectedImage:@"trash-2x" target:self action:@selector(deleteSaveList:)];
    
    self.navigationItem.rightBarButtonItem = deleteButton;
    
}

-(void)deleteSaveList:(UIBarButtonItem*)btn{
    static BOOL flag = NO;
    flag = !flag;
    //收藏列表之剩一列默认列表，自动恢复非编辑状态
    if (_saveListArray.count == 1) {
        return;
    }
    if (flag == YES) {
        //让tableView处于能够被编辑的状态
        [_saveListTableView setEditing:YES animated:YES];
    }else{
        [_saveListTableView setEditing:NO animated:YES];
    }

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return NO;
    }else{
        return YES;
    }
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_saveListArray removeObjectAtIndex:indexPath.row];
    [_saveListTableView reloadData];
    
    //收藏列表之剩一列默认列表，自动恢复非编辑状态
    if (_saveListArray.count == 1) {
        [_saveListTableView setEditing:NO animated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{

    _saveListArray = [NKSaveListTool sharedNKSaveListTool].allSaveListArray;
    [_saveListTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"saveEditCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = _saveListArray[indexPath.row][@"name"];
    NSMutableArray* musicList = _saveListArray[indexPath.row][@"musicList"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%li首歌曲", musicList.count];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _saveListArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* saveListName = cell.textLabel.text;
    _saveListName = saveListName;
    [self performSegueWithIdentifier:@"savePlayPush" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //首先得到选中的收藏列表的名称
    //segue.sourceViewController;
    UIViewController* desvc = segue.destinationViewController; //目标控制器
    desvc.navigationItem.title = _saveListName;
}

@end
