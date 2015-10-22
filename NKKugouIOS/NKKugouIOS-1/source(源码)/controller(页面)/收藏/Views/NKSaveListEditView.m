//
//  NKSaveListEditView.m
//  NKKugouIOS-1
//
//  Created by hegf on 15-1-13.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "NKSaveListEditView.h"
#import "NKSaveListTool.h"

@interface NKSaveListEditView()
{
    NSMutableArray* _saveListArray;
    //被选中得收藏列表的名称
    NSString* _selSaveListName;
}
@end
@implementation NKSaveListEditView

#pragma mark 由NSBundle加载nib文件 不会调用init，二会调用awakeFromNib
-(void)awakeFromNib{
    _saveListName.delegate = self;
//    _saveListArray = [NSMutableArray array];
//    NSString* defaultListName = @"默认收藏";
//    [_saveListArray addObject:defaultListName];
    //解档收藏列表
    //从工具类中确定所有的收藏列表
    _saveListArray = [NKSaveListTool sharedNKSaveListTool].allSaveListArray;
    _selSaveListName = nil;
}


#pragma mark 实现textFiled开始编辑代理方法，调整编辑栏的位置不被键盘遮挡
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = _editView.frame;
    frame.origin.y -= 110;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _editView.frame = frame;
    } completion:nil];
}

#pragma mark 实现textFiled结束编辑代理方法，调整编辑栏的位置还原
-(void)textFieldDidEndEditing:(UITextField *)textField{
    CGRect frame = _editView.frame;
    frame.origin.y += 110;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _editView.frame = frame;
    } completion:nil];
}

#pragma mark 新建收藏列表
- (IBAction)newSaveList:(UIButton *)sender {
    //键盘消失
    [_saveListName resignFirstResponder];
    
    //使用工具类添加收藏列表
    [[NKSaveListTool sharedNKSaveListTool]addOneSaveListToAllSaveList:_saveListName.text];
    
    [_saveListEditTableView reloadData];

}

#pragma mark 删除选中收藏列表
- (IBAction)deleteSaveList:(UIButton *)sender {
    [[NKSaveListTool sharedNKSaveListTool]removeOneSaveListFromAllSaveList:_selSaveListName];
    [_saveListEditTableView reloadData];
}

#pragma mark 实现tableView代理方法，加载cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"saveEditCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = _saveListArray[indexPath.row][@"name"];
    return cell;
}

#pragma mark 实现tableView代理方法，返回cell条目
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _saveListArray.count;
}

#pragma mark 实现tableView代理方法，监控cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* selCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString* saveListName = selCell.textLabel.text;
    _selSaveListName = saveListName;
    
    
}

#pragma mark OK按钮的响应函数，通过代理通知控制器。0代表OK
- (IBAction)okClicked:(UIButton *)sender {
    
    NSDictionary* dict = [[NKSaveListTool sharedNKSaveListTool]getSaveListDictWithSaveListName:_selSaveListName];
    [NKSaveListTool sharedNKSaveListTool].curSelSaveList = dict;
    
    if ([_delegate respondsToSelector:@selector(saveListEditView:didOKOrCancel:)]) {
        [_delegate saveListEditView:self didOKOrCancel:0];
    }
    
    
}

#pragma mark Cancel按钮的响应函数，通过代理通知控制器。1代表Cancel
- (IBAction)cancel:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(saveListEditView:didOKOrCancel:)]) {
        [_delegate saveListEditView:self didOKOrCancel:1];
    }
}

@end
