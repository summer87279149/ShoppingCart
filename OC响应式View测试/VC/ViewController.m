//
//  ViewController.m
//  OC响应式View测试
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "XT_sectionHeaderView.h"
#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "XT_cell.h"
#import "XT_shopCarVM.h"
#import "XT_bottomView.h"
#define APPScreenHeight [[UIScreen mainScreen] bounds].size.height
#define APPScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tabV;
}
@property(nonatomic,strong)XT_shopCarVM *viewModel;
@property (nonatomic, strong) XT_bottomView *endView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[XT_shopCarVM alloc]init];
    tabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight-44) style:UITableViewStyleGrouped];
    tabV.delegate=self;
    tabV.dataSource = self;
    [tabV registerClass:[XT_cell class] forCellReuseIdentifier:@"xtcell"];
    [self.view addSubview:tabV];
    [self.view addSubview:self.endView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_viewModel rowsInsection:section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _viewModel.cellArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    __weak typeof(self) weakSelf = self;
    XT_sectionHeaderView *view = [[XT_sectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, APPScreenHeight, 40) section:section carDataArrList:self.viewModel.cellArr andViewModel:self.viewModel  block:^(UIButton *button) {        
        //selectAllInSectionArr里面存放所有section的选中状态的数组，值为NSNumber*
        NSNumber *isSelectAll = weakSelf.viewModel.selectAllInSectionArr[section];
      //如果选中就取消
     if ([isSelectAll  isEqual: @1]) {
        [weakSelf.viewModel cancelSelectAllCellsInSection:section];
         button.selected = NO;
     }
      //如果未选中，就选中
     if ([isSelectAll isEqual:@0]) {
        [weakSelf.viewModel selectAllCellsInSection:section];
         button.selected = YES;
     }
    }];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XT_cell *cell = [tableView dequeueReusableCellWithIdentifier:@"xtcell" forIndexPath:indexPath];
    NSMutableArray *arr = _viewModel.cellArr[indexPath.section];
    XT_cellModel *model = arr[indexPath.row];
    
    cell.addDelegate = [RACSubject subject];
    [cell.addDelegate subscribeNext:^(UITableViewCell* thisCell) {
        NSInteger integer = [model.count integerValue];
        ++integer;
        model.count = [NSString stringWithFormat:@"%ld",integer];
    }];
    
    cell.subDelegate = [RACSubject subject];
    [cell.subDelegate subscribeNext:^(id x) {
        NSInteger integer = [model.count integerValue];
        --integer;
        model.count = [NSString stringWithFormat:@"%ld",integer];
    }];
    
    cell.textDelegate = [RACSubject subject];
    [cell.textDelegate subscribeNext:^(NSString* value) {
        if (value.integerValue) {
            cell.choosedCount = value.integerValue;
        }else{
            cell.choosedCount = cell.choosedCount;
        }
        if (value.integerValue <= 0) {
            cell.choosedCount = 0;
        }
        if (value.integerValue >= cell.model.item_info.stock_quantity.integerValue) {
            cell.choosedCount = cell.model.item_info.stock_quantity.integerValue;
        }
        model.count = [NSString stringWithFormat:@"%ld",cell.choosedCount];
    }];
    
    cell.selectedDelegate = [RACSubject subject];
    [[cell.selectedDelegate takeUntil:cell.rac_prepareForReuseSignal ] subscribeNext:^(id x) {
         model.isSelect = !model.isSelect;
        //如果某个cell取消选择了，那么发送通知把该section的全选状态取消
        if (model.isSelect == NO) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelSelectAllInOneSection" object:nil userInfo:@{@"indexPath":indexPath}];
        }
       
    }];
    
    [[RACSignal combineLatest:@[RACObserve(model, count),RACObserve(model, isSelect)]]  subscribeNext:^(RACTuple* x) {
//        NSLog(@"当前model数量:%@,当前model选择状态%@",x.first,x.second);
        [self.viewModel calculateTotalPrice];
    }];
    
    [cell setModel:model];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(XT_bottomView *)endView
{
    if (!_endView) {
        _endView = [[XT_bottomView alloc]initWithFrame:CGRectMake(0, APPScreenHeight-[XT_bottomView getViewHeight], APPScreenWidth, [XT_bottomView getViewHeight])
                                             viewModel:_viewModel];
        _endView.selectOrCancelAllDelegate = [RACSubject subject];
        
        [_endView.selectOrCancelAllDelegate subscribeNext:^(UIButton* button) {
            if (!_viewModel.isSelectAllSection) {
                [_viewModel selectAllSections];
                
            }else{
                [_viewModel cancelSelectAllSections];
            }
            [_viewModel calculateTotalPrice];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AllSectionsOpreationDid" object:nil];
        }];
    }
    return _endView;
}


#pragma mark- 删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *list = _viewModel.cellArr[indexPath.section];
        XT_cellModel *model = list[indexPath.row];
        model.isSelect=NO;
        if (list.count==1) {
            [_viewModel.cellArr removeObjectAtIndex:indexPath.section];
        }
        [list removeObjectAtIndex:indexPath.row];
        [tabV reloadData];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
