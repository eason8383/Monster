//
//  TradeView.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "TradeView.h"
#import "CoinPairModel.h"
#import "TrandModel.h"
#import "UCoinQuantity.h"
#import "HighLowLabelView.h"

@interface TradeView ()
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *subPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *numberLabel;
@property(nonatomic,strong)IBOutlet UILabel *estimateLabel;
@property(nonatomic,strong)IBOutlet UILabel *canUseLabel;
@property(nonatomic,strong)IBOutlet UILabel *canBuyLabel;
@property(nonatomic,strong)IBOutlet UILabel *valueLabel;

@property(nonatomic,strong)HighLowLabelView *hlView;
@property(nonatomic,strong)IBOutlet UIView *highLowViewBack;
@property(nonatomic,strong)IBOutlet UIView *tagView;
@property(nonatomic,strong)IBOutlet UIView *steppView1;
@property(nonatomic,strong)IBOutlet UIView *steppView2;

@property(nonatomic,strong)IBOutlet UIButton *buyBtn;
@property(nonatomic,strong)IBOutlet UIButton *saleBtn;

@property(nonatomic,strong)IBOutlet UIButton *add_stepper1Btn;
@property(nonatomic,strong)IBOutlet UIButton *add_stepper2Btn;
@property(nonatomic,strong)IBOutlet UIButton *minus_stepper1Btn;
@property(nonatomic,strong)IBOutlet UIButton *minus_stepper2Btn;
@property(nonatomic,strong)IBOutlet UIButton *limitPriceBtn;

@property(nonatomic,strong)IBOutlet UIButton *upBtn_price1;
@property(nonatomic,strong)IBOutlet UIButton *upBtn_price2;
@property(nonatomic,strong)IBOutlet UIButton *upBtn_price3;
@property(nonatomic,strong)IBOutlet UIButton *upBtn_price4;
@property(nonatomic,strong)IBOutlet UIButton *upBtn_price5;
@property(nonatomic,strong)IBOutlet UILabel *up_unit1Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit2Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit3Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit4Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit5Label;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price1;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price2;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price3;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price4;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price5;
@property(nonatomic,strong)IBOutlet UILabel *down_unit1Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit2Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit3Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit4Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit5Label;

@property UITapGestureRecognizer *tapRecognizer;

@property(nonatomic,strong)CoinPairModel *model;

@end

@implementation TradeView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _buyBtn.layer.cornerRadius = 4;
    _saleBtn.layer.cornerRadius = 4;
    _comfirmBtn.layer.cornerRadius = 4;
    
    _tagView.layer.borderWidth = 1;
    _tagView.layer.borderColor = [UIColor whiteColor].CGColor;
    _tagView.layer.cornerRadius = 4;
    
    _steppView1.layer.borderWidth = 1;
    _steppView1.layer.borderColor = [UIColor whiteColor].CGColor;
    _steppView1.layer.cornerRadius = 4;
    
    _steppView2.layer.borderWidth = 1;
    _steppView2.layer.borderColor = [UIColor whiteColor].CGColor;
    _steppView2.layer.cornerRadius = 4;
    [_stepperVolumField setValue:[UIColor colorWithWhite:1 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowLabelViewForTrade" owner:self options:nil];
    _hlView = [nib objectAtIndex:0];
    [_hlView setValue:@"+22.2%" withHigh:HighLowType_High];
    [_highLowViewBack addSubview:_hlView];
    
}

- (IBAction)bringPriceToField:(UIButton*)btn{

    [_stepperPriceField setText:btn.titleLabel.text];
}

- (void)highMode{
    _buyBtn.backgroundColor = [UIColor  colorWithHexString:MRCOLORHEX_HIGH];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _comfirmBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_HIGH];
    _saleBtn.backgroundColor = [UIColor clearColor];
    _saleBtn.layer.borderColor = [UIColor colorWithHexString:MRCOLORHEX_LOW].CGColor;
    _saleBtn.layer.borderWidth = 1;
    [_saleBtn setTitleColor:[UIColor colorWithHexString:MRCOLORHEX_LOW] forState:UIControlStateNormal];
    [_comfirmBtn setTitle:[NSString stringWithFormat:@"买入%@",_model.subCoinId] forState:UIControlStateNormal];
}

- (void)lowMode{
    _buyBtn.backgroundColor = [UIColor  clearColor];
    
    [_buyBtn setTitleColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH] forState:UIControlStateNormal];
    _buyBtn.layer.borderWidth = 1;
    _buyBtn.layer.borderColor  = [UIColor  colorWithHexString:MRCOLORHEX_HIGH].CGColor;
    _comfirmBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_LOW];
    _saleBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_LOW];
    [_saleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_comfirmBtn setTitle:[NSString stringWithFormat:@"卖出%@",_model.subCoinId] forState:UIControlStateNormal];
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
    _model = coinInfo;
    [_titleLabel setText:[NSString stringWithFormat:@"%@/%@",coinInfo.mainCoinId,coinInfo.subCoinId]];
    [_priceLabel setText:[NSString stringWithFormat:@"%f",coinInfo.lastPrice]];
    [_subPriceLabel setText:[NSString stringWithFormat:@"%f",coinInfo.lastPrice*self.multiple]];
    BOOL isGoingHigher = [self isEndPriceHigher:coinInfo];
    double result = (coinInfo.endPrice - coinInfo.beginPrice)/coinInfo.beginPrice * 100;
    if (isnan(result)) {      //isnan为系统函数
        result = 0.0;
    }
    [_hlView setValue:[NSString stringWithFormat:@"%@%.2f%@",isGoingHigher?@"+":@"",result,@"%"] withHigh:isGoingHigher?HighLowType_High:HighLowType_Low];
    
    if (self.isHighMode) {
        [self highMode];
    } else {
        [self lowMode];
    }
}

- (void)setPriceCrew:(NSArray*)buyAry saleAry:(NSArray*)saleAry{
    
    [saleAry enumerateObjectsUsingBlock:^(TrandModel *model,NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case 0: {
                [self.upBtn_price1 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit1Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
                [self.stepperPriceField setText:[NSString stringWithFormat:@"%f",model.orderPrice]];
            }
                break;
                
            case 1: {
                [self.upBtn_price2 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit2Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 2: {
                [self.upBtn_price3 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit3Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 3: {
                [self.upBtn_price4 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit4Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 4: {
                [self.upBtn_price5 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit5Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            default:
                break;
        }
        
    }];
    [buyAry enumerateObjectsUsingBlock:^(TrandModel *model,NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case 0: {
                [self.downBtn_price1 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit1Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
                
            case 1: {
                [self.downBtn_price2 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit2Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 2: {
                [self.downBtn_price3 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit3Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 3: {
                [self.downBtn_price4 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit4Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 4: {
                [self.downBtn_price5 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit5Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            default:
                break;
        }
        
    }];
}

- (void)setUerCoinQuantity:(NSArray*)userCoinAry{
    for (UCoinQuantity *uCoin in userCoinAry) {
        if ([uCoin.coinId isEqualToString:@"ETH"]) {
            [_canBuyLabel setText: [NSString stringWithFormat:@"%.2f ETH",uCoin.coinQuantity]];
        } else if ([uCoin.coinId isEqualToString:@"MR"]) {
            [_canUseLabel setText: [NSString stringWithFormat:@"%.2f MR",uCoin.coinQuantity]];
        }
    }
}

- (BOOL)isEndPriceHigher:(CoinPairModel*)coinInfo{
    double priceGap = coinInfo.endPrice - coinInfo.beginPrice;
    return (priceGap > 0)?YES:NO;
}


- (IBAction)switchMode:(UIButton*)btn{
    
    if (btn.tag == 1) {
        [self highMode];
        self.isHighMode = YES;
    } else {
        [self lowMode];
        self.isHighMode = NO;
    }
}

@end
