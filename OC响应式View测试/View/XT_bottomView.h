//
//  XT_bottomView.h
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "XT_shopCarVM.h"
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface XT_bottomView : UIView

@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,strong)UILabel *Lab;
@property(nonatomic,strong)XT_shopCarVM *viewModel;

@property (nonatomic, strong) RACSubject *selectOrCancelAllDelegate;

+(CGFloat)getViewHeight;
-(instancetype)initWithFrame:(CGRect)frame viewModel:(XT_shopCarVM*)VM;
@end
