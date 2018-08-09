//
//  ExponentialView.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "ExponentialView.h"

@interface ExponentialView()

@property(nonatomic,strong)IBOutlet UILabel *coinPairLabel;
@property(nonatomic,strong)IBOutlet UILabel *latestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *oneDayHLLabel;

@end

@implementation ExponentialView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_coinPairLabel setText:LocalizeString(@"PAIR")];
    [_latestPriceLabel setText:LocalizeString(@"LATESTPRICE")];
    [_oneDayHLLabel setText:LocalizeString(@"ONDDAYUPDOWN")];
    
}

@end
