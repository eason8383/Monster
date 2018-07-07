//
//  TradeView.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "TradeView.h"

@interface TradeView ()
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *subPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *numberLabel;
@property(nonatomic,strong)IBOutlet UILabel *estimateLabel;
@property(nonatomic,strong)IBOutlet UILabel *stepper1Label;
@property(nonatomic,strong)IBOutlet UILabel *stepper2Label;
@property(nonatomic,strong)IBOutlet UILabel *canUseLabel;
@property(nonatomic,strong)IBOutlet UILabel *canBuyLabel;
@property(nonatomic,strong)IBOutlet UILabel *valueLabel;

@property(nonatomic,strong)IBOutlet UIButton *buyBtn;
@property(nonatomic,strong)IBOutlet UIButton *saleBtn;
@property(nonatomic,strong)IBOutlet UIButton *comfirmBtn;

@property(nonatomic,strong)IBOutlet UIButton *add_stepper1Btn;
@property(nonatomic,strong)IBOutlet UIButton *add_stepper2Btn;
@property(nonatomic,strong)IBOutlet UIButton *minus_stepper1Btn;
@property(nonatomic,strong)IBOutlet UIButton *minus_stepper2Btn;
@property(nonatomic,strong)IBOutlet UIButton *limitPriceBtn;

@property(nonatomic,strong)IBOutlet UILabel *up_price1Label;
@property(nonatomic,strong)IBOutlet UILabel *up_price2Label;
@property(nonatomic,strong)IBOutlet UILabel *up_price3Label;
@property(nonatomic,strong)IBOutlet UILabel *up_price4Label;
@property(nonatomic,strong)IBOutlet UILabel *up_price5Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit1Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit2Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit3Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit4Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit5Label;
@property(nonatomic,strong)IBOutlet UILabel *down_price1Label;
@property(nonatomic,strong)IBOutlet UILabel *down_price2Label;
@property(nonatomic,strong)IBOutlet UILabel *down_price3Label;
@property(nonatomic,strong)IBOutlet UILabel *down_price4Label;
@property(nonatomic,strong)IBOutlet UILabel *down_price5Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit1Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit2Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit3Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit4Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit5Label;


@end

@implementation TradeView

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
