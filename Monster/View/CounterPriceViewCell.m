//
//  CounterPriceViewCell.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/27.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CounterPriceViewCell.h"

@interface CounterPriceViewCell()

@property (nonatomic,strong)IBOutlet UIImageView *checkImgView;
@property (nonatomic,strong)IBOutlet UILabel *titleLabel;

@end


@implementation CounterPriceViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setContent:(NSString*)title isChecked:(BOOL)checked{
    [_titleLabel setText:title];
    _checkImgView.hidden = !checked;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
