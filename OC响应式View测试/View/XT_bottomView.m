//
//  XT_bottomView.m
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "UIColor+XT_Color.h"
#import "XT_bottomView.h"
@interface XT_bottomView ()


@property(nonatomic,strong)UIButton *deleteBt;
@property(nonatomic,strong)UIButton *pushBt;


@end
static CGFloat VIEW_HEIGHT =44;
#define APPScreenHeight [[UIScreen mainScreen] bounds].size.height
#define APPScreenWidth [[UIScreen mainScreen] bounds].size.width
@implementation XT_bottomView
-(instancetype)initWithFrame:(CGRect)frame viewModel:(XT_shopCarVM*)VM
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.viewModel = VM;
        self.backgroundColor = [UIColor whiteColor];
        [self addObserver:self forKeyPath:@"isEdit" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self initView];
    }
    return self;
    
}

-(void)initView
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0.5)];
    line.backgroundColor=[UIColor colorFromHexRGB:@"e2e2e2"];
    [self addSubview:line];
    UIImage *btimg = [UIImage imageNamed:@"Unselected.png"];
    UIImage *selectImg = [UIImage imageNamed:@"Selected.png"];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(5, self.frame.size.height/2-btimg.size.height/2, btimg.size.width+60, btimg.size.height)];
    bt.selected=NO;
    [bt addTarget:self action:@selector(clickAllEnd:) forControlEvents:UIControlEventTouchUpInside];
    [bt setImage:btimg forState:UIControlStateNormal];
    [bt setImage:selectImg forState:UIControlStateSelected];
    
    [bt setTitle:@"全选" forState:UIControlStateNormal];
    bt.titleLabel.font =[UIFont systemFontOfSize:13];
    [bt setTitle:@"取消全选" forState:UIControlStateSelected];
    [bt setTitleColor:[UIColor colorFromHexRGB:@"666666"] forState:UIControlStateNormal];
    [self addSubview:bt];
    
    RAC(bt, selected) = RACObserve(self.viewModel,isSelectAllSection);
    
    _Lab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bt.frame)+10, 0, 150, self.frame.size.height)];
    _Lab.textColor=[UIColor colorFromHexRGB:@"666666"];
    _Lab.text=[NSString stringWithFormat:@"合计: ￥ 0"];
    _Lab.font=[UIFont systemFontOfSize:15];
    [self addSubview:_Lab];
    RAC(self.Lab,text) = [RACObserve(self.viewModel, totalPrice) map:^id(id value) {
        return [NSString stringWithFormat:@"合计: ￥ %@",value];
    }];
    
    _pushBt = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth-15-80, 10, 80, 30)];
    _pushBt.hidden=NO;
    _pushBt.tag=18;
    [_pushBt setTitle:@"结算" forState:UIControlStateNormal];
    _pushBt.titleLabel.font=[UIFont systemFontOfSize:14];
    _pushBt.backgroundColor=[UIColor colorFromHexRGB:@"fb5d5d"];
    [[_pushBt layer]setCornerRadius:3.0];
    [_pushBt addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    [_pushBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_pushBt];
    
    _deleteBt = [[UIButton alloc]initWithFrame:_pushBt.frame];
    _deleteBt.hidden=YES;
    [_deleteBt setTitleColor:[UIColor colorFromHexRGB:@"fb5d5d"] forState:UIControlStateNormal];
    _deleteBt.tag=19;
    [_deleteBt setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBt.titleLabel.font=[UIFont systemFontOfSize:14];
    _deleteBt.backgroundColor=[UIColor whiteColor];
    [[_deleteBt layer]setCornerRadius:3.0];
    [_deleteBt.layer setBorderWidth:0.5];
    [_deleteBt addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBt.layer.borderColor = [[UIColor colorFromHexRGB:@"fb5d5d"] CGColor];
    
    
    [self addSubview:_deleteBt];
    
}
+ (CGFloat)getViewHeight
{
    return VIEW_HEIGHT;
}
-(void)clickAllEnd:(UIButton *)button {
    [self.selectOrCancelAllDelegate sendNext:button];
}
-(void)clickRightBT:(UIButton*)button{
    
    switch (button.tag) {
            
        case 18:
            
            [self.viewModel calculateTotalPrice];
            break;
            
        case 19:
            break;
            
        default:
            break;
    }
}
@end
