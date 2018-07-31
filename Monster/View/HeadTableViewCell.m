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
@property(nonatomic,strong)IBOutlet UILabel *filpLabel;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSString *nowTitle;
@property(nonatomic,strong)NSArray *infoArray;
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
    
    _infoArray = [NSArray array];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSTimer *updatTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                  repeats:YES block:^(NSTimer *timer){
                                                      [self.filpLabel setText:[self filpInfos]];
                                                      [self filpAnimation];
                                                  }];
    [updatTimer fire];
}

- (NSString*)filpInfos{
    if(_infoArray.count > 0){
        if (_infoArray.count > 1) {
            if (_currentIndex + 1 < _infoArray.count) {
                return [_infoArray objectAtIndex:_currentIndex += 1];
            } else {
                return [_infoArray objectAtIndex:0];
            }
        } else {
            return [_infoArray objectAtIndex:0];
        }
    }
    return @"";
}

- (void)filpAnimation{
    
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:1.25f];
    
    [animation setTimingFunction:[CAMediaTimingFunction
                                  
                                  functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    animation.type     =   @"cube";
    
    animation.subtype  =   kCATransitionFromTop;
    
    [_filpLabel.layer addAnimation:animation forKey:@"cube"];
}

- (void)setFilpLabelInfos:(NSArray*)infos{
    _infoArray = infos;
    _currentIndex = 0;
    _filpLabel.text = [infos objectAtIndex:_currentIndex];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
