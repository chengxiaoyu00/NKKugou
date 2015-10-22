//
//  NKPlayBar.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-4.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义浮点数时 一定不要忘了加.0
#define kImageWidthRatio 44.0/320.0
#define kImageHeightRatio 44.0/568.0

#define screenWidth [UIScreen mainScreen].applicationFrame.size.width
#define screenHeight [UIScreen mainScreen].applicationFrame.size.height
@class NKPlayBar;
@protocol NKPlayBarDelegate <NSObject>
//歌词索引变化时调用这个代理方法，传回歌词Index
-(void)playBar:(NKPlayBar*)playBar didGeciChanged:(NSInteger)index;

@end


@interface NKPlayBar : UIView
+(instancetype)sharedPlayBar;

@property (weak, nonatomic) UILabel* musicNameLabel;
@property (weak, nonatomic) UILabel* singerLabel;
@property (weak, nonatomic) UIButton* playButton;
@property (strong, nonatomic) id<NKPlayBarDelegate> delegate;
@end
