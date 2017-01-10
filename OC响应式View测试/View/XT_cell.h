//
//  XT_cell.h
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "XT_cellModel.h"
//typedef void(^selectedBtnCallback)();
@interface XT_cell : UITableViewCell

@property(nonatomic,strong)XT_cellModel *model;

@property(nonatomic,assign)NSInteger choosedCount;

@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,assign)NSInteger row;

@property(nonatomic,strong)UITableView *tableView;

//@property(nonatomic,copy)selectedBtnCallback callback;

@property(nonatomic,strong)RACSubject *addDelegate;
@property(nonatomic,strong)RACSubject *subDelegate;
@property(nonatomic,strong)RACSubject *textDelegate;
@property(nonatomic,strong)RACSubject *selectedDelegate;

@property(nonatomic,assign)BOOL isEdit;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setModel:(XT_cellModel *)model;

@end
