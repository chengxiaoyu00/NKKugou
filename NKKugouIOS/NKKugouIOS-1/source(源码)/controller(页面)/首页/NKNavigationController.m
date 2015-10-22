//
//  NKNavigationController.m
//  NKKugouIOS-1
//
//  Created by hegf on 14-12-29.
//  Copyright (c) 2014年 hegf. All rights reserved.
//

#import "NKNavigationController.h"
#import "NKPlayBar.h"
#import "UIView+NKMoreAttribute.h"
#import "UIImage+NKScreenImage.h"
#import "NKPlayListTool.h"

@interface NKNavigationController ()
{
    NSMutableArray* _screenImageArray;
    UIImageView* _screenImageView;
}
@end

@implementation NKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //在导航控制器的下端加一个PlayBar 这样在切换到其他控制器时，都能够显示
    [self setupPlayBar];
    
    //统一导航控制器导航栏返回键的风格
    //[UINavigationBar appearance].backgroundColor = [UIColor blackColor];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"arrow-thick-left-2x"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"arrow-thick-left-2x"];
   // [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
    
    //定义滑动手势识别器
    UIPanGestureRecognizer* panGestureRecongnizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecongnize:)];
    //将手势识别器添加到导航控制器的view中，监控所有自控制器的滑动
    [self.view addGestureRecognizer:panGestureRecongnizer];
    
    //初始化一个屏幕图像的数组，保存所有的之前的控制器的屏幕图像，栈结构
    _screenImageArray = [NSMutableArray array];
    
}

#pragma mark 手势识别器的响应函数，处理手势识别事件
-(void)panRecongnize:(UIPanGestureRecognizer*)recongnizer{
    //如果当前显示的控制器是根控制器，直接返回，不做手势处理。
    if (self.topViewController == self.viewControllers[0]) {
        return;
    }
    switch (recongnizer.state) {
        case UIGestureRecognizerStateBegan:
            [self handleBengan:recongnizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self handleChanged:recongnizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self handleEnded:recongnizer];
            break;
        default:
            break;
    }
}

#pragma mark 处理手势识别的开始事件
-(void)handleBengan:(UIPanGestureRecognizer*)recongnizer{
    CGPoint translation = [recongnizer translationInView:self.view];
    NSLog(@"began translation %@", NSStringFromCGPoint(translation));
    
    UIImageView* screenImageView = [[UIImageView alloc]initWithImage:[_screenImageArray lastObject]];
    _screenImageView = screenImageView;
    screenImageView.frame = [UIScreen mainScreen].applicationFrame;
    screenImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    //把截屏加到window的最底层
    [self.view.window insertSubview:screenImageView atIndex:0];
}

#pragma mark 处理手势识别的变化事件
-(void)handleChanged:(UIPanGestureRecognizer*)recongnizer{
    CGPoint translation = [recongnizer translationInView:self.view];
    NSLog(@"change translation %@", NSStringFromCGPoint(translation));
    
    //在起初的状态，不能向左滑动
    if (translation.x < 0) {
        translation.x = 0;
    }
    
    self.view.transform = CGAffineTransformMakeTranslation(translation.x, 0);
    _screenImageView.transform = CGAffineTransformMakeScale(0.5+(translation.x/self.view.width)*0.5, 0.5+(translation.x/self.view.width)*0.5);
    
}

#pragma mark 处理手势识别的结束事件
-(void)handleEnded:(UIPanGestureRecognizer*)recongnizer{
    CGPoint translation = [recongnizer translationInView:self.view];
    NSLog(@"ended translation %@", NSStringFromCGPoint(translation));
    
    if(translation.x <= self.view.width/3){
        //回到起初的状态，不做切换
        //self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            self.view.transform = CGAffineTransformIdentity;
            _screenImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            [_screenImageView removeFromSuperview];
        }];
        
    }else{
        [UIView animateKeyframesWithDuration:0.8 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
            //滑动超过1/3屏幕，让动画一致滑动到屏幕的最右侧。
            self.view.transform = CGAffineTransformMakeTranslation(self.view.width, 0);
            _screenImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);

        } completion:^(BOOL finished) {
            //切换到上一级控制器
            [self popViewControllerAnimated:NO];
            //把已经改变的transform重置未原始状态
            self.view.transform = CGAffineTransformIdentity;
        }];
    
    }
    
}

#pragma mark 在导航控制器的下端加一个PlayBar 这样在切换到其他控制器时，都能够显示
-(void)setupPlayBar{
    NKPlayBar* playBar = [NKPlayBar sharedPlayBar];
    CGFloat w = playBar.bounds.size.width;
    CGFloat h = playBar.bounds.size.height;
    CGFloat x = 0;
    CGFloat y = self.view.height-h;
    
    playBar.frame = CGRectMake(x, y, w, h);
    NSLog(@"%@", NSStringFromCGRect(playBar.frame));
    [self.view addSubview:playBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //截屏
    UIImage* image = [UIImage getNormalImage:self.view];
    [_screenImageArray addObject:image];
    
    [[NKPlayListTool sharedNKPlayListTool]resetAllStatus];
    
    [super pushViewController:viewController animated:animated];
    
    //如果顶层控制器 不是根控制器 则隐藏导航栏
    if (self.topViewController != self.viewControllers[0]) {
        self.navigationBar.hidden = NO;
    }
    
}

//返回到根控制器 只留一个截屏
-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    UIImage* image = _screenImageArray[0];
    [_screenImageArray removeAllObjects];
    [_screenImageArray addObject:image];
    
    //截屏view删除掉
    [_screenImageView removeFromSuperview];
    
    return [super popToRootViewControllerAnimated:animated];
}

//跳到指定的控制器viewController viewController的Image以及之后的Image都需要删除
-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSMutableArray* tmpArray = [NSMutableArray array];
    
    for (int i=0; i<self.viewControllers.count; i++) {
        if (viewController != self.viewControllers[i]) {
            [tmpArray addObject:_screenImageArray[i]];
            break;
        }
    }
    
    [_screenImageArray removeAllObjects];
    _screenImageArray = tmpArray;
    
    //截屏view删除掉
    [_screenImageView removeFromSuperview];
    
    return [super popToViewController:viewController animated:animated];
}

//返回上一级控制器调用
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [_screenImageArray removeLastObject];
    //截屏view删除掉
    [_screenImageView removeFromSuperview];
    return [super popViewControllerAnimated:animated];
}

////让导航以及所有的子控制器不允许自动旋转了
//-(BOOL)shouldAutorotate{
//    return YES;
//}
////让导航以及所有的子控制器只支持竖屏
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//

@end
