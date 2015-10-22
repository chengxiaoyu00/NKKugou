//
//  NKLoadManageTableViewController.m
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/21.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKLoadManageTableViewController.h"
#import "NKPlayerTool.h"
#import "NKPlayListTool.h"
#import "NKLoadManageCell.h"
#import "NKLoadMusicModel.h"
#import "UIProgressView+AFNetworking.h"

@interface NKLoadManageTableViewController ()<NKLoadManageCellDelegate>
{
    
}

@end

@implementation NKLoadManageTableViewController

//    manager downloadTaskWithResumeData:(NSData *) progress:<#(NSProgress *__autoreleasing *)#> destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        <#code#>
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        <#code#>
//    }
//
//    downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
//        <#code#>
//    }
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"load");
    self.navigationItem.title = @"下载管理";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"load list count is %zi",[NKPlayListTool sharedNKPlayListTool].loadMuiscList.count);
    return [NKPlayListTool sharedNKPlayListTool].loadMuiscList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NKLoadManageCell * cell = [NKLoadManageCell loadManageWithTableView:tableView];
  NKLoadMusicModel *model =  [NKPlayListTool sharedNKPlayListTool].loadMuiscList[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    return cell;
}
//下载 暂停
static NSData * loadData;
- (void)loadManageCell:(NKLoadManageCell *)tableViewCell btnClick:(UIButton *)btn
{
    tableViewCell.downLoading = !tableViewCell.downLoading;
    if ( tableViewCell.isDownLoading == YES) {
        [tableViewCell.model.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            NSLog(@"pause");
            loadData = resumeData;
           // NSLog(@"%@",resumeData);
            
        }];

    }
    else
    {
         NSLog(@"resume");
       // NSLog(@"%@",loadData);
     //   NSProgress * progress = [[NSProgress alloc]init];;
              tableViewCell.model.downloadTask =
        [tableViewCell.model.manager downloadTaskWithResumeData:loadData progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    tableViewCell.model.model.musicURL = [filePath path];
                    
                }];
        
         [tableViewCell.progressView setProgressWithDownloadProgressOfTask:tableViewCell.model.downloadTask animated:YES];
        [tableViewCell.model.downloadTask resume];
    }
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
