//
//  XT_sectionHeaderView.m
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "XT_cellModel.h"
#import "UIColor+XT_Color.h"
#import "XT_sectionHeaderView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#define APPScreenHeight [[UIScreen mainScreen] bounds].size.height
#define APPScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface XT_sectionHeaderView ()

@property(nonatomic,assign)NSInteger section ;

@property(nonatomic,copy)NSMutableArray *carDataArrList;



@end

@implementation XT_sectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame section :(NSInteger )section carDataArrList:(NSMutableArray *)carDataArrList andViewModel:(XT_shopCarVM*)VM block:(void (^)(UIButton *))blockbt
{   
    self =  [super initWithFrame:frame];
    if (self) {
        _section= section;
        _carDataArrList = carDataArrList;
        _blockBT = blockbt;
        _viewModel = VM;
        [self initView];
    }
    return self;
}

- (void )initView
{
    self.backgroundColor = [UIColor whiteColor];
    UIImage *btimg = [UIImage imageNamed:@"Unselected.png"];
    UIImage *selectImg = [UIImage imageNamed:@"Selected.png"];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(2, 5, btimg.size.width+12, btimg.size.height+10)];
    bt.tag = 100+_section;
    [bt addTarget:self action:@selector(clickAll:) forControlEvents:UIControlEventTouchUpInside];
    [bt setImage:btimg forState:UIControlStateNormal];
    [bt setImage:selectImg forState:UIControlStateSelected];
    [self addSubview:bt];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bt.frame)+15, 0, 90,40)];
    lab.textColor=[UIColor colorFromHexRGB:@"666666"];
    lab.font=[UIFont systemFontOfSize:16];
    
    NSArray *list  = [self.carDataArrList objectAtIndex:_section];
    XT_cellModel *model = [list lastObject];
    
//    NSLog(@"dicType是%ld",model.type);
    [self addSubview:lab];
    
    if (_section==0) {
        self.frame=CGRectMake(0, 0, APPScreenWidth, 50);
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 10)];
        view.backgroundColor=[UIColor colorFromHexRGB:@"e2e2e2"];
        [self addSubview:view];
        
        bt.frame=CGRectMake(bt.frame.origin.x, bt.frame.origin.y+10, bt.frame.size.width, bt.frame.size.height);
        lab.frame =CGRectMake(lab.frame.origin.x, lab.frame.origin.y+10, lab.frame.size.width, lab.frame.size.height);
    }
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame), lab.frame.origin.y, APPScreenWidth-CGRectGetMaxX(lab.frame)-70, lab.frame.size.height)];
    lab1.font=[UIFont systemFontOfSize:15];
    lab1.textColor=[UIColor colorFromHexRGB:@"f5a623"];
    [self addSubview:lab1];
    
    lab.text = @"商家名称";
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, APPScreenWidth, 0.5)];
    line.backgroundColor=[UIColor colorFromHexRGB:@"e2e2e2"];
    [self addSubview:line];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"AllSectionsOpreationDid" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if(_viewModel.isSelectAllSection ){
            bt.selected = YES;
        }
        if(!_viewModel.isSelectAllSection){
            bt.selected = NO;
        }
        
    }];
    //接收到通知取消全选状态，同时更改数据源
    [[NSNotificationCenter defaultCenter]addObserverForName:@"cancelSelectAllInOneSection" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSIndexPath*path = note.userInfo[@"indexPath"];
        if (bt.tag == path.section+100) {
            self.viewModel.selectAllInSectionArr[path.section] = @0;
            bt.selected = NO;
        }
    }];
    bt.selected = [self.viewModel.selectAllInSectionArr[_section] boolValue];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)clickAll:(UIButton *)sender{
    _blockBT(sender);
}
@end
