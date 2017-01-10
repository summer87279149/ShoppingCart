//
//  XT_shopCarVM.m
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "MJExtension.h"
#import "XT_shopCarVM.h"
#import "XT_cellModel.h"

@interface XT_shopCarVM()

@property (nonatomic, copy) NSMutableArray *dataArr;

@end


@implementation XT_shopCarVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"data.plist" ofType:nil];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc]initWithDictionary:dic copyItems:YES];
        self.dataArr = [self getMySectionsArrWith:dataDic];
        [self setupCellArr];
        self.isSelectAllSection = NO;
        
    }
    return self;
}
//字典转模型
-(void)setupCellArr{
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i<self.dataArr.count; ++i) {
        NSMutableArray *arr = self.dataArr[i];
        //映射 arr->itemArr
        NSArray * itemArr = [arr.rac_sequence map:^id(id value) {
            XT_cellModel *model = [XT_cellModel mj_objectWithKeyValues:value];
            model.isSelect = NO;
            return model;
        }].array;
        NSMutableArray *mutaArr = [itemArr mutableCopy];
        [mutArr addObject:mutaArr];
    }
    self.cellArr = mutArr;
}

-(NSMutableArray *)selectAllInSectionArr{
    if(!_selectAllInSectionArr){
        _selectAllInSectionArr = [NSMutableArray arrayWithCapacity:2];
        for (int i = 0 ; i<self.cellArr.count; ++i) {
            NSNumber *number = @0;
            [_selectAllInSectionArr addObject:number];
            
           
        }
    }
    return _selectAllInSectionArr;
}

-(NSMutableArray *)getMySectionsArrWith:(NSMutableDictionary*)dataDic{
    NSArray * keys = [dataDic allKeys];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i<keys.count; ++i) {
        NSString *key = keys[i];
        NSDictionary *childDic = dataDic[key];
        [arr addObject:childDic];
    }
    return  arr;
}

-(NSInteger)rowsInsection:(NSInteger)section{
    return  [NSArray arrayWithArray:self.cellArr[section]].count;
}

-(void)selectAllCellsInSection:(NSInteger)section{
    NSMutableArray *arr = self.cellArr[section];
    for (int i = 0; i<arr.count ; ++i) {
        XT_cellModel *model = arr[i];
        model.isSelect = YES;
    }
    self.selectAllInSectionArr[section] = @1;
}
-(void)cancelSelectAllCellsInSection:(NSInteger)section{
    NSMutableArray *arr = self.cellArr[section];
    for (int i = 0; i<arr.count ; ++i) {
        XT_cellModel *model = arr[i];
        model.isSelect = NO;
    }
    self.selectAllInSectionArr[section] = @0;
}

-(void)selectAllSections{
    for (int i = 0; i<self.cellArr.count; ++i) {
        self.selectAllInSectionArr[i] = @1;
        NSMutableArray *arr = self.cellArr[i];
        for (int j = 0; j < arr.count; ++j) {
            //去除无货的商品
            XT_cellModel *model = arr[j];
            if (![model.item_info.sale_state isEqualToString:@"3"]) {
                model.isSelect = YES;
//                NSLog(@"================");
            }
        }
    }
    self.isSelectAllSection = !self.isSelectAllSection;
}

-(void)cancelSelectAllSections{
    for (int i = 0; i<self.cellArr.count; ++i) {
        self.selectAllInSectionArr[i] = @0;
        NSMutableArray *arr = self.cellArr[i];
        for (int j = 0; j < arr.count; ++j) {
            XT_cellModel *model = arr[j];
            //去除无货的商品
            if (![model.item_info.sale_state isEqualToString:@"3"]) {
                model.isSelect = NO;
            }
        }
    }
    self.isSelectAllSection = !self.isSelectAllSection;
}

-(void)calculateTotalPrice{
    self.totalPrice = 0;
    for (NSMutableArray *arr in self.cellArr) {
        for (int j = 0; j < arr.count; ++j) {
            XT_cellModel *model = arr[j];
            if (![model.item_info.sale_state isEqualToString:@"3"]) {
                if (model.isSelect == YES){
                    self.totalPrice = self.totalPrice + [model.item_info.sale_price integerValue] * [model.count integerValue];
                }
            }
            
        }
    }
}
@end

