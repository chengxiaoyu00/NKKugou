//
//  AppDelegate.m
//  NKKugouIOS-1
//
//  Created by hegf on 14-12-29.
//  Copyright (c) 2014年 hegf. All rights reserved.
//

#import "AppDelegate.h"
#import "NKNewFeatrueViewController.h"
#import "NKNavigationController.h"
#import "UIViewController+NKStroyBoard.h"
#import "NKPlayListTool.h"
#import "NKSaveListTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //整体进行解档
    //判断Dcoment路径下有没有本地音乐列表文件locMusicList.data
    //如果有这个文件，从文件解当我的音乐列表 如果没有这个文件，加载所有的音乐
    [[NKPlayListTool sharedNKPlayListTool] getLocPlayListFromDocument];
    [[NKPlayListTool sharedNKPlayListTool]getMyLoveListFromDocument];
    [[NKSaveListTool sharedNKSaveListTool]getAllSaveListFromDocument];
     //下载管理的列表归档
    [[NKPlayListTool sharedNKPlayListTool] getLoadPlayListFromDocument];
    //根据版本号启动控制器
    [self startViewControllerByVersion];
    

    return YES;
}

#pragma mark 根据版本号启动控制器
- (void)startViewControllerByVersion{
    //1.取得旧的版本信息
    NSString* oldBundleVersion = [[NSUserDefaults standardUserDefaults]valueForKey:(NSString*)kCFBundleVersionKey];
    
    //2.取得版本信息，保存在info.plist
    NSDictionary* infoDict = [[NSBundle mainBundle]infoDictionary];
    NSString* bundleVersion = [infoDict objectForKey:(NSString*)kCFBundleVersionKey];

    //3.和旧版本进行对比，如果有变化，就启动新特性控制器，并把最新的版本保存起来，
    //如果没有变化，就启动主页
    if (![oldBundleVersion isEqualToString:bundleVersion]) {
        //启动新特性控制器
        //保存？数据存取的问题 sandbox 保存到userDefults中
        UIViewController* vc = [UIViewController viewControllerWithStoryBoradID:@"NKNewFeatrueViewController1"];
        self.window.rootViewController = vc;
        [[NSUserDefaults standardUserDefaults]setValue:bundleVersion forKey:(NSString*)kCFBundleVersionKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }else{
        UIViewController* vc = [UIViewController viewControllerWithStoryBoradID:@"NKNavigationController1"];
        self.window.rootViewController = vc;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //整体进行归档
    //对本地音乐列表进行归档
    [[NKPlayListTool sharedNKPlayListTool]saveLocPlayListToDocument];
    //将当前我喜欢音乐播放列表归档到myLoveList.data中
    [[NKPlayListTool sharedNKPlayListTool]saveMyLoveListToDocument];

    //将最新的收藏列表归档
    [[NKSaveListTool sharedNKSaveListTool]saveAllSaveListToDocument];
    
    //下载管理的列表归档
    [[NKPlayListTool sharedNKPlayListTool] saveLoadPlayListToDocument];
    
}

@end
