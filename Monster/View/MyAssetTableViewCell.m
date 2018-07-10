//
//  MyAssetTableViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MyAssetTableViewCell.h"

@interface MyAssetTableViewCell ()
@property(nonatomic,strong)IBOutlet UILabel *myAssetLabel;
@property(nonatomic,strong)IBOutlet UILabel *subAssetLabel;
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UIImageView *checkBox;
@property(nonatomic,strong)IBOutlet UIView *backView;

@property (nonatomic) CGPoint inputPoint0;
@property (nonatomic) CGPoint inputPoint1;
@property (nonatomic) UIColor *inputColor0;
@property (nonatomic) UIColor *inputColor1;

@end

@implementation MyAssetTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setBtnTarget:(id)target select:(SEL)select{
    [self.chargeBtn addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
    [self.withDrawBtn addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
    [self.capitalBtn addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
