//
//  XT_shopCarVM.h
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface XT_shopCarVM : NSObject

@property (nonatomic, strong) NSMutableArray *cellArr;

@property(nonatomic,assign)NSInteger selectSection;

@property(nonatomic,assign)NSInteger totalPrice;

@property(nonatomic,strong)NSMutableArray *selectAllInSectionArr;

@property(nonatomic,assign)BOOL isSelectAllSection;

-(instancetype)init;

-(NSInteger)rowsInsection:(NSInteger)section;

-(void)selectAllCellsInSection:(NSInteger)section;

-(void)cancelSelectAllCellsInSection:(NSInteger)section;

-(void)selectAllSections;

-(void)cancelSelectAllSections;

-(void)calculateTotalPrice;
@end
