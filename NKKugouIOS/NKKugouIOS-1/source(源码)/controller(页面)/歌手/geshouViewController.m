//
//  geshouViewController.m
//  NKKugouIOS-1
//
//  Created by neuedu on 15/10/19.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "geshouViewController.h"
#import "AFNetworking.h"
#import "NKMusicModel.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import <MediaPlayer/MediaPlayer.h>

#define  kSearchMusicURL @"https://api.douban.com/v2/music/search"
@interface geshouViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray * _webMusicListArray;
    NSString * _searchText;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation geshouViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   
    //标题、
    self.navigationItem.title = @"歌手";
    // Do any additional setup after loading the view.
    
    _webMusicListArray = [NSMutableArray array];
    
    //上拉下拉刷新的初始化
    [self setupRefresh];
    
    _searchText = @"刘德华";
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _webMusicListArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"geshou";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //UIRefreshControl  下拉上拉刷新  控制器必须是tableviewcontroller
    //MJRefresh-master
    //data
    NKMusicModel *model = _webMusicListArray[indexPath.row];
    ;
    //setting cell
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.singer;
  
    NSURL * url =  [NSURL URLWithString:model.imgURL];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"play_bar_singerbg"]];
     return cell;
}
#pragma mark - searchBar
//参数	意义	备注
//q	查询关键字	q和tag必传其一
//tag	查询的tag	q和tag必传其一
//start	取结果的offset	默认为0
//count	取结果的条数
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  
   // NSLog(@"%@", searchBar.text);
    [searchBar resignFirstResponder];
    
    _searchText = searchBar.text;
    
    //[_webMusicListArray removeAllObjects];
    AFHTTPRequestOperationManager * manage = [AFHTTPRequestOperationManager manager];
    NSString * start = [ NSString stringWithFormat:@"%li",_webMusicListArray.count ];
    NSDictionary * parameters = @{
                                  @"q":_searchText,
                                  @"start": start,
                                  @"count":@1
                                  
                                  };
    [manage GET:kSearchMusicURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"musics"]);
        NSArray * tempArray = responseObject[@"musics"];
        [tempArray enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL *stop) {
//            NSLog(@"title is %@",dict[@"title"]) ;
//            NSLog(@"singer is %@",dict[@"attrs"][@"singer"][0]) ;
//             NSLog(@"image is %@",dict[@"image"]) ;
            //网络音乐模型
            NKMusicModel * model = [NKMusicModel webMusicModelWithDict:dict];
            
            [_webMusicListArray addObject:model];
        }];
        
        //刷新tableview
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

/**
 *  集成刷新控件
 */
#pragma mark - refresh
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
//#warning 自动刷新(一进入程序就下拉刷新)
  //  [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"MJ哥正在帮你刷新中,不客气";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"MJ哥正在帮你加载中,不客气";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
   // NSLog(@"headerRereshing");
    AFHTTPRequestOperationManager * manage = [AFHTTPRequestOperationManager manager];
    NSString * start = [ NSString stringWithFormat:@"%li",_webMusicListArray.count ];
    NSDictionary * parameters = @{
                                  @"q":_searchText,
                                  @"start": start,
                                  @"count":@5
                                  
                                  };
    [manage GET:kSearchMusicURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"musics"]);
        NSArray * tempArray = responseObject[@"musics"];
        [tempArray enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL *stop) {
            //            NSLog(@"title is %@",dict[@"title"]) ;
            //            NSLog(@"singer is %@",dict[@"attrs"][@"singer"][0]) ;
            //             NSLog(@"image is %@",dict[@"image"]) ;
            //网络音乐模型
            NKMusicModel * model = [NKMusicModel webMusicModelWithDict:dict];
            
            [_webMusicListArray addObject:model];
        }];
        
        //刷新tableview
        [_tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
   
}

- (void)footerRereshing
{
     NSLog(@"footerRereshing");
           // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
  
    
}


@end
