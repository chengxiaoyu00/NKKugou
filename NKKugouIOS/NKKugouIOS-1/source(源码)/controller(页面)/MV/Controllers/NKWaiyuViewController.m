//
//  NKWaiyuViewController.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-15.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKWaiyuViewController.h"

@interface NKWaiyuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *waiyuTableView;

@end

@implementation NKWaiyuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"saveEditCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"Waiyu";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"waiyuModal" sender:self];
}


@end
