//
//  CapitalDetailsViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CapitalDetailsViewCell.h"

@interface CapitalDetailsViewCell()

@property(nonatomic,strong)IBOutlet UIButton *dealBtn;
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

@end
