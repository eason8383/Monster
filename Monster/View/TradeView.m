//
//  TradeView.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "TradeView.h"
#import "CoinPairModel.h"

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
@property(nonatomic,strong)IBOutlet UIView *tagView;

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
    _buyBtn.layer.cornerRadius = 4;
    _saleBtn.layer.cornerRadius = 4;
    _comfirmBtn.layer.cornerRadius = 4;
    _tagView.layer.cornerRadius = 4;
}

- (void)highMode{
    _buyBtn.backgroundColor = [UIColor  colorWithHexString:MRCOLORHEX_HIGH];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _comfirmBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_HIGH];
    _saleBtn.backgroundColor = [UIColor clearColor];
    _saleBtn.layer.borderColor = [UIColor colorWithHexString:MRCOLORHEX_LOW].CGColor;
    _saleBtn.layer.borderWidth = 1;
    [_saleBtn setTitleColor:[UIColor colorWithHexString:MRCOLORHEX_LOW] forState:UIControlStateNormal];
}

- (void)lowMode{
    _buyBtn.backgroundColor = [UIColor  clearColor];
    
    [_buyBtn setTitleColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH] forState:UIControlStateNormal];
    _buyBtn.layer.borderWidth = 1;
    _buyBtn.layer.borderColor  = [UIColor  colorWithHexString:MRCOLORHEX_HIGH].CGColor;
    _comfirmBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_LOW];
    _saleBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_LOW];
    [_saleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setMode:(BOOL)isHigh{
    self.isHighMode = isHigh;
    if (self.isHighMode) {
        [self highMode];
    } else {
        [self lowMode];
    }
}

- (void)setContent:(CoinPairModel*)coinInfo{
    [_titleLabel setText:[NSString stringWithFormat:@"%@/%@",coinInfo.mainCoinId,coinInfo.subCoinId]];
    [_priceLabel setText:[NSString stringWithFormat:@"%f",coinInfo.lastPrice]];
    [_subPriceLabel setText:[NSString stringWithFormat:@"%f",coinInfo.lastPrice*self.multiple]];
//    BOOL isGoingHigher = [self isEndPriceHigher:coinInfo];
    double result = (coinInfo.endPrice - coinInfo.beginPrice)/coinInfo.beginPrice * 100;
    if (isnan(result)) {      //isnan为系统函数
        result = 0.0;
    }
    
//    [_hlView setValue:[NSString stringWithFormat:@"%@%.2f%@",isGoingHigher?@"+":@"",result,@"%"] withHigh:isGoingHigher?HighLowType_High:HighLowType_Low];
}

- (BOOL)isEndPriceHigher:(CoinPairModel*)coinInfo{
    double priceGap = coinInfo.endPrice - coinInfo.beginPrice;
    return (priceGap > 0)?YES:NO;
}


- (IBAction)switchMode:(UIButton*)btn{
    
    if (btn.tag == 1) {
        [self highMode];
    } else {
        [self lowMode];
    }
}

@end
