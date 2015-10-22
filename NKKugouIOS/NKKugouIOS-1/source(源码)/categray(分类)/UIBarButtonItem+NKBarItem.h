//
//  UIBarButtonItem+NKBarItem.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-4.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NKBarItem)
+(instancetype)barButtonItemWithNormalImage:(NSString*)normal selectedImage:(NSString*)selectedImage target:(id)target action:(SEL)action;
@end
