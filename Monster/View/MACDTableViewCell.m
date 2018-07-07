//
//  MACDTableViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MACDTableViewCell.h"
#import "HighLowLabelView.h"

@interface MACDTableViewCell()

@property(nonatomic,strong)IBOutlet UILabel *coinTypeLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *nowPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *highestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *lowestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *volumLabel;

@property(nonatomic,strong)IBOutlet UIView *backView;
@property(nonatomic,strong)IBOutlet UIView *highLowView;
@property(nonatomic,strong)IBOutlet HighLowLabelView *hlView;
@property(nonatomic,strong)IBOutlet UIView *kLineView;


@end

@implementation MACDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowLabelView" owner:self options:nil];
    _hlView = [nib objectAtIndex:0];
    [_hlView setValue:@"+22.2%" withHigh:HighLowType_High];
    [_highLowView addSubview:_hlView];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _backView.layer.borderWidth = 1;
    
    _backView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
}

- (void)setContent:(id)info{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
