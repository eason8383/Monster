//
//  MarketTableViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MarketTableViewCell.h"
#import "HighLowLabelView.h"

@interface MarketTableViewCell()
@property(nonatomic,strong)IBOutlet UILabel *coninLabel;
@property(nonatomic,strong)IBOutlet UILabel *tradeLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *subPriceLabel;
@property(nonatomic,strong)IBOutlet UIView *highLowView;
@property(nonatomic,strong)HighLowLabelView *hlView;

@end

@implementation MarketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowLabelView" owner:self options:nil];
    _hlView = [nib objectAtIndex:0];
    [_hlView setValue:@"+22.2%" withHigh:HighLowType_High];
    [_highLowView addSubview:_hlView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
