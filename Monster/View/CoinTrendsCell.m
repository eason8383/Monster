//
//  CoinTrendsCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinTrendsCell.h"
#import "HighLowLabelView.h"
#import "ZYWLineView.h"

@interface CoinTrendsCell()

@property(nonatomic,strong)IBOutlet UIView *highLowView;
@property(nonatomic,strong)IBOutlet UIView *kLineView;
@property(nonatomic,strong)HighLowLabelView *hlView;

@property(nonatomic,strong)ZYWLineView *lineView;

@end

@implementation CoinTrendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowLabelView" owner:self options:nil];
    _hlView = [nib objectAtIndex:0];
    [_hlView setValue:@"+22.2%" withHigh:HighLowType_High];
    [_highLowView addSubview:_hlView];
    
    if(_lineView == nil) {
        NSLog(@"init ZYWLineView");
        _lineView = [[ZYWLineView alloc] initWithFrame:CGRectMake(0, 0, _kLineView.width, _kLineView.height)];
        _lineView.lineWidth = 2;
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.lineColor = [UIColor colorWithHexString:@"0BC09E"];
        
        _lineView.isFillColor = NO;
        _lineView.useAnimation = NO;
        
        [_kLineView addSubview:_lineView];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.kLineView);
            make.left.right.equalTo(self.kLineView);
            make.height.equalTo(@(self.kLineView.height));
        }];
    //     [_lineView layoutIfNeeded];
    //    _dataArray = @[@"12",@"33",@"26",@"10",@"7",@"30",@"21"];
        if ([_lineView.dataArray count] < 1) {
            _lineView.dataArray = @[@"12",@"33",@"26",@"10",@"7",@"30",@"21",@"26",@"10",@"7",@"30",@"21",@"26",@"10",@"7",@"30",@"21"];
        }
        _lineView.leftMargin = 0;
        _lineView.rightMargin = 0;
        _lineView.topMargin = 0;
        _lineView.bottomMargin = 0;
        [_lineView stockFill];
    }
    
}


- (void)setContent:(id)info{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
