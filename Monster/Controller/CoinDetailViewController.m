//
//  CoinDetailViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinDetailViewController.h"
#import "TradeViewController.h"

@interface CoinDetailViewController ()

@end

@implementation CoinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)openTrade:(id)sender{
    
    TradeViewController *tdVC = [[TradeViewController alloc]initWithNibName:@"TradeViewController" bundle:nil];
    tdVC.title = @"交易";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tdVC];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
