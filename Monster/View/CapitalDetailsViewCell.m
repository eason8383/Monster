//
//  CapitalDetailsViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CapitalDetailsViewCell.h"
#import "UserOrderModel.h"

@interface CapitalDetailsViewCell()

@property(nonatomic,strong)IBOutlet UIButton *orderStateBtn;
@property(nonatomic,strong)IBOutlet UILabel *buySaleLabel;
@property(nonatomic,strong)IBOutlet UILabel *coinLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)IBOutlet UILabel *measureLabel;

@property(nonatomic,strong)IBOutlet UILabel *totalDealLabel;
@property(nonatomic,strong)IBOutlet UILabel *avegDealLabel;
@property(nonatomic,strong)IBOutlet UILabel *meanDealLabel;

@end

@implementation CapitalDetailsViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(UserOrderModel*)userOrderInfo{
    if ([userOrderInfo.buySell isEqualToString:@"B"]) {
        [_buySaleLabel setText:@"买入"];
        [_buySaleLabel setTextColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH]];
    } else {
        [_buySaleLabel setText:@"卖出"];
        [_buySaleLabel setTextColor:[UIColor colorWithHexString:MRCOLORHEX_LOW]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/China"]];
    [formatter setDateFormat:@"hh:mm MM/dd"];
    // Date to string
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:userOrderInfo.createTime/1000];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    NSDictionary *coinPairTable = [[NSUserDefaults standardUserDefaults]objectForKey:COINPAIRTABLE];
    
    [_coinLabel setText:[NSString stringWithFormat:@"%@/MR",[coinPairTable objectForKey:userOrderInfo.coinPairId]]];
    [_priceLabel setText:[NSString stringWithFormat:@"%fMR",userOrderInfo.dealPrice]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",currentDateString]];
    
    [_measureLabel setText:[NSString stringWithFormat:@"%f",userOrderInfo.dealAmount]];
    
//    [_transFeeLabel setText:[NSString stringWithFormat:@"%f",userOrderInfo.feeRate]];
    
    [_orderStateBtn setTitle:userOrderInfo.orderStatusName forState:UIControlStateNormal];
    
    [_totalDealLabel setText:[NSString stringWithFormat:@"%f",userOrderInfo.orderPrice]];
    [_avegDealLabel setText:[NSString stringWithFormat:@"%f",userOrderInfo.orderPrice]];
    [_meanDealLabel setText:[NSString stringWithFormat:@"%f",userOrderInfo.orderQuantity]];
}

@end
