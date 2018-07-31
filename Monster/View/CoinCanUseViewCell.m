//
//  CoinCanUseViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinCanUseViewCell.h"
#import "UserCoinQuantity.h"

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

- (void)setContent:(UserCoinQuantity*)coinInfo{
    
    
//    NSNumber *number = coinInfo.coinQuantity;
//    float coin = [coinInfo.coinQuantity floatValue];
    [_coinLabel setText:coinInfo.coinId];
    if ([coinInfo.quantityStatusName isEqualToString:@"冻结"]) {
        [_cannotLabel setText:[NSString stringWithFormat:@"%.8f",coinInfo.coinQuantity]];
        [_canUseLabel setText:@"0"];
    } else {
        [_canUseLabel setText:[NSString stringWithFormat:@"%.8f",coinInfo.coinQuantity]];
        [_cannotLabel setText:@"0"];
    }
    
    
//    [_cannotLabel setText:[NSString stringWithFormat:@"%.8f",coinInfo.coinQuantity]];
}

- (void)setContentWithAry:(NSArray*)coinAry{
    
    for (UserCoinQuantity *cInfo in coinAry) {
        [_coinLabel setText:cInfo.coinId];
        if ([cInfo.quantityStatusName isEqualToString:@"冻结"]) {
            [_cannotLabel setText:[NSString stringWithFormat:@"%.8f",cInfo.coinQuantity]];
            if (coinAry.count == 1) {
                [_canUseLabel setText:@"0"];
            }
        } else {
            [_canUseLabel setText:[NSString stringWithFormat:@"%.8f",cInfo.coinQuantity]];
            if (coinAry.count == 1) {
                [_cannotLabel setText:@"0"];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
