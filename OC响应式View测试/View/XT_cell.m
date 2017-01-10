//
//  XT_cell.m
//  OC响应式View测试
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "UIColor+XT_Color.h"
#import "UIImageView+WebCache.h"
#import "XT_cellModel.h"
#import "XT_countView.h"
#import "XT_cell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#define APPScreenHeight [[UIScreen mainScreen] bounds].size.height
#define APPScreenWidth [[UIScreen mainScreen] bounds].size.width

static CGFloat CELL_HEIGHT = 100;

@interface XT_cell () <UITextFieldDelegate>

@property(nonatomic,strong)UIButton *selectBt;
@property(nonatomic,strong)UIImageView *shoppingImgView;
@property(nonatomic,strong)UIImageView *spuImgView;
@property(nonatomic,strong)UILabel *title ;
@property(nonatomic,strong)XT_countView *changeView;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *sizeLab;
@property(nonatomic,assign)CGRect tableVieFrame;
@property(nonatomic,strong)UILabel *soldoutLab;

@end

@implementation XT_cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self initCellView];
    }
    return self;
}
- (void)initCellView
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImage *btimg = [UIImage imageNamed:@"Unselected.png"];
    UIImage *selectImg = [UIImage imageNamed:@"Selected.png"];
    
    _selectBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btimg.size.width+20, CELL_HEIGHT)];
    [_selectBt setImage:btimg forState:UIControlStateNormal];
    [_selectBt setImage:selectImg forState:UIControlStateSelected];
//    [_selectBt addTarget:self action:@selector(dianji) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBt];
    
    
    _shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_selectBt.frame)+7, 12, 70, 70)];
    _shoppingImgView.layer.cornerRadius = 2;
    _shoppingImgView.layer.borderWidth = 1;
    _shoppingImgView.layer.borderColor = [UIColor colorFromHexRGB:@"e2e2e2"].CGColor;
    [self.contentView addSubview:_shoppingImgView];

    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingImgView.frame)+10, 10, APPScreenWidth-CGRectGetMaxX(_shoppingImgView.frame)-15, 21)];
    _title.font=[UIFont systemFontOfSize:15];
    _title.textColor=[UIColor colorFromHexRGB:@"666666"];
    
    
    [self.contentView addSubview:_title];
    
    
    _sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_title.frame), 200, 17)];
    _sizeLab.font=[UIFont systemFontOfSize:12];
    _sizeLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    [self.contentView addSubview:_sizeLab];
    
    
    
    _soldoutLab = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+15, 100, 17)];
    _soldoutLab.hidden =YES;
    _soldoutLab.text=@"无货";
    _soldoutLab.font =  [UIFont systemFontOfSize:14];
    _soldoutLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    [self.contentView addSubview:_soldoutLab];
    
    
    _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(APPScreenWidth-18-100, CGRectGetMaxY(_sizeLab.frame)+5+5, 100, 17)];
    _priceLab.textAlignment=NSTextAlignmentRight;
    _priceLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    _priceLab.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLab];
    
    
    
    
    //如果放在下面的setModel方法里面，会导致每次从重用池里面取出cell的时候都增加一个订阅者，最后导致重复订阅很多次
    @weakify(self);
    //绑定isSelect属性和按钮的选择状态，
    [[RACObserve(self,model.isSelect)skip:1] subscribeNext:^(id x) {
        @strongify(self);
        self.selectBt.selected = [x boolValue];
        
    }];
    
    //选择按钮点击事件
    [[self.selectBt rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.selectedDelegate) {
            [self.selectedDelegate sendNext:self];
        }
    }];
    
    //绑定count和self.choosedCount
    [RACObserve(self,model.count) subscribeNext:^(NSString * x) {
        @strongify(self);
        self.choosedCount = x.integerValue;
    }];
    
    [RACObserve(self,model.item_info.full_name) subscribeNext:^(id x) {
        @strongify(self);
        self.title.text = x;
    }];
    
    [RACObserve(self,model.item_info.icon)subscribeNext:^(id x) {
        @strongify(self);
        [self.shoppingImgView sd_setImageWithURL:[NSURL URLWithString:x] placeholderImage:[UIImage imageNamed:@"default"]];
    }];
    
    [RACObserve(self,model.item_size)subscribeNext:^(id x) {
        @strongify(self);
        self.sizeLab.text = [NSString stringWithFormat:@"规格:%@",x];
    }];
    
    [RACObserve(self, model.item_info.is_spu) subscribeNext:^(id x) {
        @strongify(self);
        if([x intValue] == 1){
            self.priceLab.text = [NSString stringWithFormat:@"套装价￥%@",self.model.item_info.sale_price];
        }
        else{
            self.priceLab.text = [NSString stringWithFormat:@"￥%@",self.model.item_info.sale_price];
        }
    }];
    [[RACObserve(self, model.item_info.sale_state) skip:1] subscribeNext:^(NSString * x) {
        @strongify(self);
//        NSLog(@"售出状态信息为:%@",x);
        if ([x isEqualToString:@"3"]) {
            _soldoutLab.hidden=NO;
            _selectBt.enabled=NO;
            if (self.isEdit) {
                //编辑状态
                _selectBt.enabled=YES;
            }
        }else{
            [self setupchangeView];
        }
        
    }];
}
-(void)setupchangeView{
    _selectBt.enabled=YES;
    _changeView = [[XT_countView alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+5, 160, 35) chooseCount:self.choosedCount totalCount: [self.model.item_info.stock_quantity integerValue]];
    
    @weakify(self);
    [RACObserve(self, choosedCount)subscribeNext:^(id x) {
        @strongify(self);
        self.changeView.subButton.enabled = YES;
        self.changeView.addButton.enabled = YES;
        self.changeView.numberFD.text = [NSString stringWithFormat:@"%@",x];
        if ([x integerValue] >= self.model.item_info.stock_quantity.integerValue) {
            self.changeView.addButton.enabled = NO;
        }
        if ([x integerValue] <= 1) {
            self.changeView.subButton.enabled = NO;
        }
    }];
    [[self.changeView.subButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.subDelegate) {
            [self.subDelegate sendNext:self];
        }
    }];
    
    [[self.changeView.addButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.addDelegate) {
            [self.addDelegate sendNext:self];
        }
    }];
    
    [self.changeView.numberFD.rac_newTextChannel subscribeNext:^(NSString * value) {
        @strongify(self);
        if (self.textDelegate) {
            [self.textDelegate sendNext:value];
        }
    }];
    
    [self.contentView addSubview:_changeView];

}
- (void)setModel:(XT_cellModel *)model
{
    _model = model;
}
























- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
