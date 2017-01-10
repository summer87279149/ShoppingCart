//
//  XT_cellModel.h
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XT_commodityModel.h"

@interface XT_cellModel : NSObject

@property(nonatomic,copy)NSString *item_id;

@property(nonatomic,copy)NSString *count;

@property(nonatomic,copy)NSString *item_size;

@property(nonatomic,strong)XT_commodityModel *item_info;

@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,assign)NSInteger choosedCount;


@end
