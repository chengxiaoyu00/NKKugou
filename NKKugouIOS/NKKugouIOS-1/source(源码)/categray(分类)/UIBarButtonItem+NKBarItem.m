//
//  UIBarButtonItem+NKBarItem.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-4.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "UIBarButtonItem+NKBarItem.h"
#import "UIButton+NKImage.h"

@implementation UIBarButtonItem (NKBarItem)
+(instancetype)barButtonItemWithNormalImage:(NSString *)normal selectedImage:(NSString *)selectedImage target:(id)target action:(SEL)action{
    UIButton* btn = [UIButton buttonWithNormalImage:normal  hilightedImage:selectedImage target:target action:action];
    btn.bounds = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}
@end
