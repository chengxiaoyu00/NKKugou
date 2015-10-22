//
//  NKdiantaiTableViewController.m
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/20.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKdiantaiTableViewController.h"
#import "AFNetworking.h"
#import "NKdiantaiChannel.h"
#import "NKdiantaiPlayTableViewController.h"
#define  kChannelURL @"http://www.douban.com/j/app/radio/channels"

@interface NKdiantaiTableViewController ()
{
    NSMutableArray * _channels;
}
//@property (strong, nonatomic) IBOutlet UITableView *tableView1;

@end

@implementation NKdiantaiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"电台";
    
    _channels = [NSMutableArray array];
    
   // UIRefreshControl
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    //网络请求
    AFHTTPRequestOperationManager * manage = [AFHTTPRequestOperationManager manager];
    [manage GET:kChannelURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject[@"channels"]);
        //tmpArray 全部频道
        NSArray * tmpArray = responseObject[@"channels"];
        
        [tmpArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            NKdiantaiChannel * channel = [NKdiantaiChannel diantaiChannelWithDictionary:dict];
            
            [_channels addObject:channel];
        }];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _channels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"diantai";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
   NKdiantaiChannel* channel =  _channels[indexPath.row];
    
    
    
    // Configure the cell...
    cell.textLabel.text = channel.name;
    cell.detailTextLabel.text = channel.channel_id;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到某个电台播放页面
    [self performSegueWithIdentifier:@"diantai2diantaiplay" sender:_channels[indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NKdiantaiChannel *channel = sender;
    //titile
    NKdiantaiPlayTableViewController * vc =  segue.destinationViewController;
    
    vc.channel = channel;
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
