//
//  ExponentialCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "ExponentialCell.h"

@interface ExponentialCell ()
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *subTitleLabel;

@end

@implementation ExponentialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTitle:(NSString*)title subTitle:(NSString*)subTitle{
    [_titleLabel setText:title];
    [_subTitleLabel setText:[NSString stringWithFormat:@"%@>>",subTitle]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
