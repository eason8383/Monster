//
//  CapitalDetailsViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CapitalDetailsViewCell.h"
#import "UserInOutModel.h"

@interface CapitalDetailsViewCell()

@property(nonatomic,strong)IBOutlet UILabel *typeLabel;
@property(nonatomic,strong)IBOutlet UILabel *coinLabel;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)IBOutlet UILabel *measureLabel;

@property(nonatomic,strong)IBOutlet UILabel *feeRateLabel;

@property(nonatomic,strong)IBOutlet UILabel *typeLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *coinLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *measureLabel_title;

@property(nonatomic,strong)IBOutlet UILabel *feeRateLabel_title;


@end

@implementation CapitalDetailsViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self fillText];
}

- (void)fillText{
    [_typeLabel_title setText:LocalizeString(@"TYPE")];
    [_coinLabel_title setText:LocalizeString(@"PAIR")];
    [_timeLabel_title setText:LocalizeString(@"TIME")];
    [_measureLabel_title setText:LocalizeString(@"RECORDAMOUNT")];
    [_feeRateLabel_title setText:LocalizeString(@"FEE")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(UserInOutModel*)userInOutInfo{
//    if ([userOrderInfo.buySell isEqualToString:@"B"]) {
//        [_typeLabel setText:@"买入"];
//        [_typeLabel setTextColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH]];
//    } else {
//        [_typeLabel setText:@"卖出"];
//        [_typeLabel setTextColor:[UIColor colorWithHexString:MRCOLORHEX_LOW]];
//    }
    
    [_typeLabel setText:userInOutInfo.inOutName];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/China"]];
    [formatter setDateFormat:@"hh:mm MM/dd"];
    // Date to string
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:userInOutInfo.createTime/1000];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    [_coinLabel setText:userInOutInfo.coinId];
    
    [_timeLabel setText:currentDateString];
    
    [_measureLabel setText:[NSString stringWithFormat:@"%.4f",userInOutInfo.coinQuantity]];
    
//    [_transFeeLabel setText:[NSString stringWithFormat:@"%f",userOrderInfo.feeRate]];
}

@end
