//
//  UIViewController+NKStroyBoard.m
//  NKKugouIOS-1
//
//  Created by hegf on 14-12-30.
//  Copyright (c) 2014年 hegf. All rights reserved.
//

#import "UIViewController+NKStroyBoard.h"

@implementation UIViewController (NKStroyBoard)
+ (instancetype)viewControllerWithStoryBoradID:(NSString *)storyBoardID{
    UIStoryboard* storyBorad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyBorad instantiateViewControllerWithIdentifier:storyBoardID];
    return vc;
}
@end
