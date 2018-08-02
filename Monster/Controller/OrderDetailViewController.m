//
//  OrderDetailViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "UserOrderModel.h"


@interface OrderDetailViewController ()

@property(nonatomic,strong)IBOutlet UIButton *orderStateBtn;
@property(nonatomic,strong)IBOutlet UILabel *buySaleLabel;
@property(nonatomic,strong)IBOutlet UILabel *coinLabel;

@property(nonatomic,strong)IBOutlet UILabel *totalDealLabel;
@property(nonatomic,strong)IBOutlet UILabel *avegDealLabel;
@property(nonatomic,strong)IBOutlet UILabel *meanDealLabel;

@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)IBOutlet UILabel *measureLabel;

@property(nonatomic,strong)IBOutlet UILabel *transFeeLabel;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成交明细";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self initial];
}

- (void)initial{
    if ([self.userOrderInfo.buySell isEqualToString:@"B"]) {
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
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:self.userOrderInfo.createTime/1000];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    NSDictionary *coinPairTable = [[NSUserDefaults standardUserDefaults]objectForKey:COINPAIRTABLE];
    
    [_coinLabel setText:[NSString stringWithFormat:@"MR/%@",[coinPairTable objectForKey:self.userOrderInfo.coinPairId]]];
    [_priceLabel setText:[NSString stringWithFormat:@"%.8f",self.userOrderInfo.dealPrice]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",currentDateString]];
    
    [_measureLabel setText:[NSString stringWithFormat:@"%.4f%@",self.userOrderInfo.dealAmount,[coinPairTable objectForKey:self.userOrderInfo.coinPairId]]];
    
    [_transFeeLabel setText:[NSString stringWithFormat:@"%.2f",self.userOrderInfo.feeRate]];
    
    [_orderStateBtn setTitle:self.userOrderInfo.orderStatusName forState:UIControlStateNormal];
    
    [_totalDealLabel setText:[NSString stringWithFormat:@"%.8f",self.userOrderInfo.orderPrice]];
    [_avegDealLabel setText:[NSString stringWithFormat:@"%.8f",self.userOrderInfo.orderPrice]];
    [_meanDealLabel setText:[NSString stringWithFormat:@"%.8f",self.userOrderInfo.orderQuantity]];
    
    
}



@end
