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

@end

@implementation EntrustNowViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.cornerRadius = 8;
}

- (void)setContent:(UserOrderModel*)orderInfo{
    if ([orderInfo.buySell isEqualToString:@"B"]) {
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
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:orderInfo.createTime/1000];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    [_coinLabel setText:[NSString stringWithFormat:@"%@/MR",self.subCoinId]];
    [_priceLabel setText:[NSString stringWithFormat:@"%f",orderInfo.orderPrice]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",currentDateString]];
    [_measureLabel setText:[NSString stringWithFormat:@"%f",orderInfo.orderQuantity]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
