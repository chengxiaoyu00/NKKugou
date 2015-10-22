//
//  NKMVSelTabBarController.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-15.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKMVSelTabBarController.h"

@interface NKMVSelTabBarController ()

@end

@implementation NKMVSelTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //在TabBar中设置不阻挡属性。子控制器就都不会阻挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //自己做自己的代理
    self.delegate = self;
    self.navigationItem.title = @"热播";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //改变导航控制器的title 根据的子控制器的title 子控制器的title在storyBorad中已设置
    self.navigationItem.title = viewController.title;
    
}
@end
