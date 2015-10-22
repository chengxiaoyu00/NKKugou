//
//  NKSaveListEditView.h
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-13.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKSaveListEditView;

@protocol NKSaveListEditViewDelegate <NSObject>

//收藏列表View代理方法，在点击OK或者Cancel调用 0 OK 1 Cancel
-(void)saveListEditView:(NKSaveListEditView*)view didOKOrCancel:(NSInteger) flag;

@end

@interface NKSaveListEditView : UIView<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
- (IBAction)deleteSaveList:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *saveListEditTableView;
@property (weak, nonatomic) IBOutlet UITextField *saveListName;
@property (weak, nonatomic) IBOutlet UIView *editView;

@property (strong, nonatomic) id<NKSaveListEditViewDelegate> delegate;

@end
