//
//  NKEditBarItem.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-6.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKEditBarItem : UIButton
+(instancetype)editBarItemWithImage:(NSString*)image title:(NSString*)title target:(id)target action:(SEL)action;
@end
