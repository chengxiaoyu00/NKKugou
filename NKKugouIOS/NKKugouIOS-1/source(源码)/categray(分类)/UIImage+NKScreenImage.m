//
//  UIImage+NKScreenImage.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-12.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "UIImage+NKScreenImage.h"

@implementation UIImage (NKScreenImage)
//获取当前屏幕内容
+ (instancetype)getNormalImage:(UIView *)view{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
