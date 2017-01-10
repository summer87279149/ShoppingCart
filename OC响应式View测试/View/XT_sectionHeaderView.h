//
//  XT_sectionHeaderView.h
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XT_shopCarVM.h"
@interface XT_sectionHeaderView : UIView

typedef void (^clickBlock)(UIButton *);

@property(nonatomic,copy)clickBlock blockBT;

@property (nonatomic, strong) XT_shopCarVM *viewModel;


- (instancetype)initWithFrame:(CGRect)frame section :(NSInteger )section carDataArrList:(NSMutableArray *)carDataArrList andViewModel:(XT_shopCarVM*)VM block:(void (^)(UIButton *))blockbt;


@end
