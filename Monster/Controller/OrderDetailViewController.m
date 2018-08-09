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

@property(nonatomic,strong)IBOutlet UILabel *totalDealLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *avegDealLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *meanDealLabel_title;

@property(nonatomic,strong)IBOutlet UILabel *time_title;
@property(nonatomic,strong)IBOutlet UILabel *dealPrice_title;
@property(nonatomic,strong)IBOutlet UILabel *dealAmount_title;
@property(nonatomic,strong)IBOutlet UILabel *transFee_title;

@property(nonatomic,strong)IBOutlet UILabel *transFeeLabel;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizeString(@"ORDERDETAIL");
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self fillText];
    [self initial];
}

- (void)fillText{
    [_totalDealLabel_title setText:LocalizeString(@"TOTALDEAL")];
    [_avegDealLabel_title setText:LocalizeString(@"AVERAGEPRICE")];
    [_meanDealLabel_title setText:LocalizeString(@"TOTALAMOUNT")];
    
    [_time_title setText:LocalizeString(@"TIME")];
    [_dealPrice_title setText:LocalizeString(@"DEARPRICE")];
    [_dealAmount_title setText:LocalizeString(@"MARKETAMOUNT")];
    [_transFee_title setText:LocalizeString(@"FEE")];

}

- (void)initial{
    if ([self.userOrderInfo.buySell isEqualToString:@"B"]) {
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
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:self.userOrderInfo.createTime/1000];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    NSDictionary *coinPairTable = [[NSUserDefaults standardUserDefaults]objectForKey:COINPAIRTABLE];
    
    [_coinLabel setText:[NSString stringWithFormat:@"MR/%@",[coinPairTable objectForKey:self.userOrderInfo.coinPairId]]];
    
    [_priceLabel setText:[NSString stringWithFormat:@"%.8f",self.userOrderInfo.orderPrice]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",currentDateString]];
    
    [_measureLabel setText:[NSString stringWithFormat:@"%.4f%@",self.userOrderInfo.orderQuantity,[coinPairTable objectForKey:self.userOrderInfo.coinPairId]]];
    
    [_transFeeLabel setText:[NSString stringWithFormat:@"%.2f",self.userOrderInfo.feeRate]];
    
    [_orderStateBtn setTitle:self.userOrderInfo.orderStatusName forState:UIControlStateNormal];
        
    [_totalDealLabel setText:[NSString stringWithFormat:@"%.8f",self.userOrderInfo.dealAmount]];
    [_avegDealLabel setText:[NSString stringWithFormat:@"%.8f",self.userOrderInfo.dealPrice]];
    [_meanDealLabel setText:[NSString stringWithFormat:@"%.4f",self.userOrderInfo.dealQuantity]];
    
    
}



@end
