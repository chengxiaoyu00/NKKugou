//
//  NKReboViewController.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-15.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKReboViewController.h"

@interface NKReboViewController ()
@property (weak, nonatomic) IBOutlet UITableView *reboTableView;

@end

@implementation NKReboViewController

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
    cell.textLabel.text = @"第一章 项目需求介绍";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"reboModal" sender:self];
}

@end
