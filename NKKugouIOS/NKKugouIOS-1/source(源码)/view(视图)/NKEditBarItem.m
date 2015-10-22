//
//  NKEditBarItem.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-6.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKEditBarItem.h"

@implementation NKEditBarItem

+(instancetype)editBarItemWithImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action{
    NKEditBarItem* item  = [[NKEditBarItem alloc]init];
    
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    item.titleLabel.textAlignment = NSTextAlignmentCenter;
    item.titleLabel.font = [UIFont systemFontOfSize:15];
    
    item.imageView.contentMode = UIViewContentModeCenter;
    
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return item;
}
#pragma mark 重写下边方法，来自定义Button Title的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    //在button的底部 占1/4
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height/4;
    CGFloat x = 0;
    CGFloat y = contentRect.size.height*3/4 - 2;
    
    CGRect rect = CGRectMake(x, y, w, h);
    
    return rect;
}

#pragma mark 重写下边方法，来自定义Button Image的位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    //在button的顶部 占3/4
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height*3/4 - 2;
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGRect rect = CGRectMake(x, y, w, h);
    
    return rect;
}

@end
