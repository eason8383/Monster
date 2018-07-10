//
//  MACDTableViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MACDTableViewCell.h"
#import "HighLowLabelView.h"
#import "ZYWLineView.h"

@interface MACDTableViewCell()

@property(nonatomic,strong)IBOutlet UILabel *coinTypeLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *nowPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *highestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *lowestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *volumLabel;

@property(nonatomic,strong)IBOutlet UIView *backView;
@property(nonatomic,strong)IBOutlet UIView *highLowView;
@property(nonatomic,strong)IBOutlet HighLowLabelView *hlView;
@property(nonatomic,strong)IBOutlet UIView *kLineView;

@property(nonatomic,strong)ZYWLineView *lineView;


@end

@implementation MACDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowLabelView" owner:self options:nil];
    _hlView = [nib objectAtIndex:0];
    [_hlView setValue:@"+22.2%" withHigh:HighLowType_High];
    [_highLowView addSubview:_hlView];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _backView.layer.borderWidth = 1;
    
    _backView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    [self setKLine];
}

- (void)setKLine{
    _lineView = [[ZYWLineView alloc] initWithFrame:CGRectMake(0, 0, _kLineView.width, _kLineView.height)];
    _lineView.lineWidth = 0.5;
    _lineView.backgroundColor = [UIColor clearColor];
    _lineView.lineColor = [UIColor clearColor];
    
    _lineView.fillColor = [UIColor colorWithHexString:@"6241D1"];
    _lineView.isFillColor = YES;
    _lineView.useAnimation = NO;
    
    [_kLineView addSubview:_lineView];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.kLineView);
        make.bottom.equalTo(self.kLineView);
//        make.center.equalTo(self.kLineView);
        make.left.equalTo(self.kLineView);
        make.right.equalTo(self.kLineView);
//        make.height.equalTo(@(63));
    }];
//    [_lineView layoutIfNeeded];
    //    _dataArray = @[@"12",@"33",@"26",@"10",@"7",@"30",@"21"];
    
    _lineView.dataArray = @[@"12",@"33",@"26",@"18",@"25",@"30",@"21",@"26",@"10",@"7",@"30",@"21",@"26",@"24",@"54",@"30",@"21",@"33",@"37",@"25",@"36",@"33",@"38",@"41",@"47",@"46",@"39",@"44",@"32",@"44",@"40",@"38",@"35",@"33",@"29",@"24",@"19",@"18",@"17",@"16"];
    _lineView.leftMargin = 0;
    _lineView.rightMargin = 0;
    _lineView.topMargin = 0;
    _lineView.bottomMargin = 0;
    [_lineView stockFill];
}

- (void)setContent:(id)info{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
