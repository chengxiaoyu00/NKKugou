//
//  NKNewFeatrueViewController.m
//  NKKugouIOS-1
//
//  Created by hegf on 14-12-29.
//  Copyright (c) 2014年 hegf. All rights reserved.
//

#import "NKNewFeatrueViewController.h"
#import "UIButton+NKImage.h"
#import "UIView+NKMoreAttribute.h"
#import "NKNavigationController.h"
#import "NKMainViewController.h"
#import "NSArray+NKPList.h"

#define kStartButtonWidthRatio 244/320
#define kStartButtonHeightRatio 64/568
#define kStartButtonYRatio 0.66

@interface NKNewFeatrueViewController ()

@end

//pageControl的纵向比例
#define kRatio 0.85

@implementation NKNewFeatrueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置新特性View
    [self setNewFeatureScrollView];
    // 设置pagecontrol的位置
    [self setPageControlPostion];
 
}

#pragma mark 设置pagecontrol的位置
- (void) setPageControlPostion{
    _pageControl.frame = CGRectMake(0, self.view.height*kRatio, self.view.width, 37);
    NSLog(@"%@", NSStringFromCGRect(_pageControl.frame));
    
//    NSURL* url = [[NSBundle mainBundle]URLForResource:@"newFeatrue.plist" withExtension:nil];
//    NSArray* newFeature = [NSArray arrayWithContentsOfURL:url];
    NSArray* newFeature = [NSArray arrayWithPlist:@"newFeatrue.plist"];
    _pageControl.numberOfPages = newFeature.count;
}

#pragma mark 设置新特性View
- (void)setNewFeatureScrollView{
    
    NSURL* url = [[NSBundle mainBundle]URLForResource:@"newFeatrue.plist" withExtension:nil];
    NSArray* newFeature = [NSArray arrayWithContentsOfURL:url];
    
    for (int i=0; i<newFeature.count; i++) {
        UIImageView* imageView = [[UIImageView alloc]init];
        NSString* imageStr = newFeature[i];
        [imageView setImage:[UIImage imageNamed:imageStr]];
        imageView.frame = CGRectMake(i*self.view.width, 0, self.view.width, self.view.height);
        //最后一个imageView
        if (i == newFeature.count-1) {
            [self addStartButton:imageView];
        }
        [_scrowView addSubview:imageView];
    }
    _scrowView.contentSize = CGSizeMake(newFeature.count*self.view.width, self.view.height);
    _scrowView.pagingEnabled = YES;
    _scrowView.bounces = NO;
    
}
#pragma mark 添加开始按钮
- (void)addStartButton:(UIImageView*)imageView{
//    UIButton *startButton = [[UIButton alloc]init];
//    [startButton setImage:[UIImage imageNamed:@"introduction_enter_nomal"] forState:UIControlStateNormal];
//    [startButton setImage:[UIImage imageNamed:@"introduction_enter_press"] forState:UIControlStateHighlighted];
//    
//    [startButton addTarget:self action:@selector(startMainView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* startButton = [UIButton buttonWithNormalImage:@"introduction_enter_nomal" hilightedImage:@"introduction_enter_press" target:self action:@selector(startMainView:)];
    
    CGFloat startY = self.view.height*kStartButtonYRatio;
    CGFloat startW = self.view.width*kStartButtonWidthRatio;
    CGFloat startH = self.view.height*kStartButtonHeightRatio;
    CGFloat startX = (self.view.width - startW)/2;
    
    startButton.frame = CGRectMake(startX, startY, startW, startH);
    
    //默认imageView 不接受用户的点击的，他的所有子空间也是不接受用户交互的，需要使能一下标识，就可以接受用户交互
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:startButton];
    
}

#pragma mark 开始主页
- (void)startMainView:(UIButton*)startBtn{
    NSLog(@"start Button Click");
    //启动一个主界面
    
    //设置window 的根控制器为导航控制器
    
//    NKMainViewController* main = [[NKMainViewController alloc]init];
//    UIButton* test = [[UIButton alloc]init];
//    test.frame = CGRectMake(0, 0, 100, 100);
//    test.backgroundColor = [UIColor redColor];
//    
//    [main.view addSubview:test];
//    
//    NKNavigationController* nav = [[NKNavigationController alloc]initWithRootViewController:main];
//    
//    self.view.window.rootViewController  = nav;
    //先找到stroyborad
    UIStoryboard* storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //从storyboard中找到对应的ViewController实例
    NKNavigationController* nav = [storyborad instantiateViewControllerWithIdentifier:@"NKNavigationController1"];
    
    self.view.window.rootViewController = nav;
//    [UIApplication sharedApplication].keyWindow.rootViewController  = nav;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat num = scrollView.contentOffset.x/self.view.frame.size.width;
    _pageControl.currentPage = num;
    
}

@end
