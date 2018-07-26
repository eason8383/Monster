//
//  ChoseCoinTableViewCell.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/16.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "ChoseCoinTableViewCell.h"
#import "CoinPairModel.h"
@interface ChoseCoinTableViewCell()

@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *upDownLabel;

@end

@implementation ChoseCoinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContent:(CoinPairModel*)coinInfo{
    [_titleLabel setText:[NSString stringWithFormat:@"%@/%@",coinInfo.mainCoinId,coinInfo.subCoinId]];
    [_priceLabel setText:[NSString stringWithFormat:@"%f",coinInfo.lastPrice]];
    
    BOOL isGoingHigher = [self isEndPriceHigher:coinInfo];
    double result = (coinInfo.endPrice - coinInfo.beginPrice)/coinInfo.beginPrice * 100;
    if (isnan(result)) {      //isnan为系统函数
        result = 0.0;
    }
    [_upDownLabel setText:[NSString stringWithFormat:@"$%.2f",result]];
    
    [_upDownLabel setTextColor:[UIColor colorWithHexString:isGoingHigher?MRCOLORHEX_HIGH:MRCOLORHEX_LOW]];
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
