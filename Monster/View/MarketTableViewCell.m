//
//  MarketTableViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MarketTableViewCell.h"
#import "HighLowLabelView.h"
#import "CoinPairModel.h"

@interface MarketTableViewCell()
@property(nonatomic,strong)IBOutlet UILabel *coninLabel;
@property(nonatomic,strong)IBOutlet UILabel *volumLabel;
@property(nonatomic,strong)IBOutlet UILabel *latestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *nowPriceLabel;
@property(nonatomic,strong)IBOutlet UIView *highLowView;
@property(nonatomic,strong)HighLowLabelView *hlView;

@end

@implementation MarketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowLabelView" owner:self options:nil];
    _hlView = [nib objectAtIndex:0];
    [_highLowView addSubview:_hlView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setContent:(CoinPairModel*)coinInfo{
    [_coninLabel setText:[NSString stringWithFormat:@"%@/%@",coinInfo.mainCoinId,coinInfo.subCoinId]];
    [_latestPriceLabel setText:[NSString stringWithFormat:@"%.8f",coinInfo.lastPrice]];
    
    NSString *resultStr = [self decimalMultiply:[NSString stringWithFormat:@"%f",coinInfo.lastPrice] with:self.multiple];
    [_nowPriceLabel setText:resultStr];
    
    BOOL isGoingHigher = [self isEndPriceHigher:coinInfo];
    double result = (coinInfo.endPrice - coinInfo.beginPrice)/coinInfo.beginPrice * 100;
    if (isnan(result)) {      //isnan为系统函数
        result = 0.0;
    }
//    NSString *currencyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
//    NSString *dollarSign = [currencyStr isEqualToString:CNY]?@"￥":@"$";
    
    [_hlView setValue:[NSString stringWithFormat:@"%.2f%@",result,@"%"] withHigh:isGoingHigher?HighLowType_High:HighLowType_Low];
    [_volumLabel  setText:[NSString stringWithFormat:@"%@:%.4f",LocalizeString(@"MARKETAMOUNT"),coinInfo.totalVolume]];
}

- (NSString*)decimalMultiply:(NSString*)numStr1 with:(NSString*)numStr2{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:numStr1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:numStr2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       scale:4
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    
    NSDecimalNumber *result = [num1 decimalNumberByMultiplyingBy:num2 withBehavior:roundUp];
    
    return [result stringValue];
}

- (BOOL)isEndPriceHigher:(CoinPairModel*)coinInfo{
    double priceGap = coinInfo.endPrice - coinInfo.beginPrice;
    return (priceGap > 0)?YES:NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
