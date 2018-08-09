//
//  EntrustNowViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "EntrustNowViewCell.h"
#import "UserOrderModel.h"

@interface EntrustNowViewCell ()

@property(nonatomic,strong)IBOutlet UILabel *buySaleLabel;
@property(nonatomic,strong)IBOutlet UILabel *coinLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)IBOutlet UILabel *measureLabel;

@property(nonatomic,strong)IBOutlet UILabel *priceLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *measureLabel_title;

@end

@implementation EntrustNowViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.cornerRadius = 8;
    [self fillText];
}

- (void)fillText{

    [_priceLabel_title setText:LocalizeString(@"ORDERPRICE")];
    [_timeLabel_title setText:LocalizeString(@"TIME")];
    [_measureLabel_title setText:LocalizeString(@"PRDERAMOUNT")];
    [_cancelBtn setTitle:LocalizeString(@"ABORT") forState:UIControlStateNormal];
}

- (void)setContent:(UserOrderModel*)orderInfo{
    if ([orderInfo.buySell isEqualToString:@"B"]) {
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
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:orderInfo.createTime/1000];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    NSDictionary *coinPairTable = [[NSUserDefaults standardUserDefaults]objectForKey:COINPAIRTABLE];
    
    [_coinLabel setText:[NSString stringWithFormat:@"MR/%@",[coinPairTable objectForKey:orderInfo.coinPairId]]];
    [_priceLabel setText:[NSString stringWithFormat:@"%f",orderInfo.orderPrice]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",currentDateString]];
    [_measureLabel setText:[NSString stringWithFormat:@"%f",orderInfo.orderQuantity]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
