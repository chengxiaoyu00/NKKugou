//
//  NKdiantaiPlayTableViewController.m
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/20.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKdiantaiPlayTableViewController.h"
#import "NKdiantaiChannel.h"
#import "AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "NKMusicModel.h"
#import "UIImageView+WebCache.h"
#import "NKPlayerTool.h"
#import "NKPlayListTool.h"
#import "NKdiantaiPlayCell.h"
#import "UIProgressView+AFNetworking.h"
#import "UIView+NKMoreAttribute.h"
#import "NKLoadMusicModel.h"

#define kSongListURL @"http://www.douban.com/j/app/radio/people"
@interface NKdiantaiPlayTableViewController ()<NKdiantaiPlayCellDelegate>
{
    NSMutableArray * _diantaiMusics;
}
@end

@implementation NKdiantaiPlayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.navigationItem.title = _channel.name;
    
    _diantaiMusics = [NSMutableArray array];
    
    UIRefreshControl * refresh = [[UIRefreshControl alloc]init];
    self.refreshControl = refresh;
    [refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
   
}
- (void)refreshAction
{
    //NSLog(@"refrsh");
    [self webRequest];
    [self.refreshControl endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    //注册接受新的播放歌曲的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusic:) name:@"playMusic" object:nil];
    
    //音乐播放来源修改成电台
    [NKPlayerTool sharedNKPlayerTool].musicSource = kmusicSourceDiantai;
    
    //网络请求歌曲
    [self webRequest];
}

//2.接受新的播放歌曲的通知，并作处理
-(void)playMusic:(NSNotification*)notify{
    //NSLog(@"接受到了新的音乐");
    //根据当前播放的歌曲切换到对应的cell
    
    //让tableView 选中某一行
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[NKPlayListTool sharedNKPlayListTool].curPlayMusicIndex inSection:0];
    
    //切换到指定的indexPath那一行，保持选中行在屏幕的中央
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    // 音乐播放来源修改成电台
    [NKPlayerTool sharedNKPlayerTool].musicSource = kmusicSourceLocal;
    //移除播放音乐的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)webRequest
{
    [_diantaiMusics removeAllObjects];
    //网络请求
    AFHTTPRequestOperationManager * manage = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"app_name":@"radio_desktop_win",
                                 @"version":@100,
                                 @"channel":_channel.channel_id,
                                 @"type":@"n"
                                 
                                 };
    [manage GET:kSongListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"%@",responseObject[@"song"]);
        //        NSLog(@"%@",responseObject[@"title"]);
        //        NSLog(@"%@",responseObject[@"length"]);
        //         NSLog(@"%@",responseObject[@"length"]);
        //tmpArray 全部频道
        NSArray * tmpArray = responseObject[@"song"];
        
        [tmpArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            NKMusicModel  * model = [NKMusicModel diantaiMusicModelWithDictionary:dict];
            
            [_diantaiMusics addObject:model];
        }];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIAlertView  showAlertViewForRequestOperationWithErrorOnCompletion:operation delegate:self];
    }];

}
//- (void)viewWillAppear:(BOOL)animated
//{
//    // 音乐播放来源修改成电台
//    [NKPlayerTool sharedNKPlayerTool].musicSource = kmusicSourceDiantai;
//    
//    [self webRequest];
//
//
//}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _diantaiMusics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NKdiantaiPlayCell *cell = [NKdiantaiPlayCell diantaiPlayCellWithTableView:tableView];
    cell.delegate = self;
    
    NKMusicModel* model =  _diantaiMusics[indexPath.row];
    
    
    
    // Configure the cell...
    cell.model = model;
    return cell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   ;
    [NKPlayListTool sharedNKPlayListTool].curPlayMusicList = _diantaiMusics;
    [[NKPlayerTool sharedNKPlayerTool]playMusic: _diantaiMusics[indexPath.row]];
}

- (void)diantaiPlayCell:(NKdiantaiPlayCell *)tableViewCell btnClick:(UIButton *)btn
{
    //NSLog(@"btn click");
  //  [[NKPlayListTool sharedNKPlayListTool].loadMuiscList addObject:tableViewCell.model];
    //tableViewCell.model;//url
    //下载
    [self downLoad:tableViewCell.model];
    

    
}
- (void)downLoad:(NKMusicModel* )model
{
    //NSLog(@"%@",url);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:model.musicURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
   //NSProgress * progress =  [[NSProgress alloc]init];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //NSLog(@"File downloaded to: %@", filePath);
       
       // NSLog(@"url%@", model.musicURL);
        
        
    }];
    
    
    //建立下载对应的数据模型
    NKLoadMusicModel * loadModel = [[NKLoadMusicModel alloc]init];
    loadModel.model = model;
    loadModel.downloadTask = downloadTask;
    loadModel.manager = manager;
    //loadModel.progress = progress;
    [[NKPlayListTool sharedNKPlayListTool].loadMuiscList addObject:loadModel];
    

    

    [downloadTask resume];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
