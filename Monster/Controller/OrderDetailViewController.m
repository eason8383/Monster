//
//  OrderDetailViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@property(nonatomic,strong)IBOutlet UIButton *dealBtn;
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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
