//
//  CoinCanUseViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinCanUseViewCell.h"

@interface CoinCanUseViewCell()

@property(nonatomic,strong)IBOutlet UILabel *coinLabel;
@property(nonatomic,strong)IBOutlet UILabel *canUseLabel;
@property(nonatomic,strong)IBOutlet UILabel *cannotLabel;

@end

@implementation CoinCanUseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
