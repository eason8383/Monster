//
//  HeadTableViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "HeadTableViewCell.h"

@interface HeadTableViewCell()
@property(nonatomic,strong)IBOutlet UIImageView *bannerBallImgView;
@end

@implementation HeadTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
//    CAShapeLayer *border = [CAShapeLayer layer];
//    
//    //虚线的颜色
//    border.strokeColor = [UIColor whiteColor].CGColor;
//    //填充的颜色
//    border.fillColor = [UIColor clearColor].CGColor;
//    
//    //设置路径
//    border.path = [UIBezierPath bezierPathWithRect:_bannerBallImgView.bounds].CGPath;
//    
//    border.frame = _bannerBallImgView.bounds;
//    //虚线的宽度
//    border.lineWidth = 1.f;
//    
//    
//    //设置线条的样式
//    //    border.lineCap = @"square";
//    //虚线的间隔
//    border.lineDashPattern = @[@4, @2];
//    
//    [_bannerBallImgView.layer addSublayer:border];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
