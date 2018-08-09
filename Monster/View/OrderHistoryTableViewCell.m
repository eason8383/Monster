//
//  OrderHistoryTableViewCell.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "OrderHistoryTableViewCell.h"
#import "UserOrderModel.h"

@interface OrderHistoryTableViewCell()

@property(nonatomic,strong)IBOutlet UIButton *orderStateBtn;
@property(nonatomic,strong)IBOutlet UILabel *buySaleLabel;
@property(nonatomic,strong)IBOutlet UILabel *coinLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)IBOutlet UILabel *measureLabel;

@property(nonatomic,strong)IBOutlet UILabel *totalDealLabel;
@property(nonatomic,strong)IBOutlet UILabel *avegDealLabel;
@property(nonatomic,strong)IBOutlet UILabel *meanDealLabel;

@property(nonatomic,strong)IBOutlet UILabel *totalDealLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *measureLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *avegDealLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *meanDealLabel_title;

@end

@implementation OrderHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self fillText];
}

- (void)fillText{
    
    [_timeLabel_title setText:LocalizeString(@"TIME")];
    [_priceLabel_title setText:LocalizeString(@"ORDERPRICE")];
    [_measureLabel_title setText:LocalizeString(@"PRDERAMOUNT")];
    
    [_totalDealLabel_title setText:LocalizeString(@"TOTALDEAL")];
    [_avegDealLabel_title setText:LocalizeString(@"AVERAGEPRICE")];
    [_meanDealLabel_title setText:LocalizeString(@"TOTALAMOUNT")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setContent:(UserOrderModel*)userOrderInfo{
    if ([userOrderInfo.buySell isEqualToString:@"B"]) {
        [_buySaleLabel setText:LocalizeString(@"BUY")];
        [_buySaleLabel setTextColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH]];
    } else {
        [_buySaleLabel setText:LocalizeString(@"SALE")];
        [_buySaleLabel setTextColor:[UIColor colorWithHexString:MRCOLORHEX_LOW]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/China"]];
    [formatter setDateFormat:@"hh:mm MM/dd"];
    // Date to string
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:userOrderInfo.createTime/1000];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    NSDictionary *coinPairTable = [[NSUserDefaults standardUserDefaults]objectForKey:COINPAIRTABLE];
    
    [_coinLabel setText:[NSString stringWithFormat:@"MR/%@",[coinPairTable objectForKey:userOrderInfo.coinPairId]]];
    [_priceLabel setText:[NSString stringWithFormat:@"%.8f",userOrderInfo.orderPrice]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",currentDateString]];
    
    [_measureLabel setText:[NSString stringWithFormat:@"%.4f",userOrderInfo.orderQuantity]];
    
    //    [_transFeeLabel setText:[NSString stringWithFormat:@"%f",userOrderInfo.feeRate]];
    
    [_orderStateBtn setTitle:userOrderInfo.orderStatusName forState:UIControlStateNormal];
    
    [_totalDealLabel setText:[NSString stringWithFormat:@"%.8f",userOrderInfo.dealAmount]];
    [_avegDealLabel setText:[NSString stringWithFormat:@"%.8f",userOrderInfo.dealPrice]];
    [_meanDealLabel setText:[NSString stringWithFormat:@"%.4f",userOrderInfo.dealQuantity]];
}

@end
