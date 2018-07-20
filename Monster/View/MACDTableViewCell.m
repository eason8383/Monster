//
//  MACDTableViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MACDTableViewCell.h"
#import "HighLowLabelView.h"
#import "ZYWLineView.h"
#import "CoinPairModel.h"

@interface MACDTableViewCell()

@property(nonatomic,strong)IBOutlet UILabel *coinTypeLabel;
@property(nonatomic,strong)IBOutlet UILabel *latestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *nowPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *highestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *lowestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *volumLabel;

@property(nonatomic,strong)IBOutlet UIView *backView;
@property(nonatomic,strong)IBOutlet UIView *highLowView;
@property(nonatomic,strong)IBOutlet HighLowLabelView *hlView;
@property(nonatomic,strong)IBOutlet UIView *kLineView;

@property(nonatomic,strong)ZYWLineView *lineView;

@property(nonatomic,strong)NSMutableArray *local_DataAry;



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

- (void)setKLine{
    
    if (_lineView == nil) {
        _lineView = [[ZYWLineView alloc] initWithFrame:CGRectMake(0, 0, _kLineView.width, _kLineView.height)];
        _lineView.lineWidth = 0.5;
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.lineColor = [UIColor clearColor];
        
        _lineView.fillColor = [UIColor colorWithHexString:@"6241D1"];
        _lineView.isFillColor = YES;
        _lineView.useAnimation = NO;
        
        [_kLineView addSubview:_lineView];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineView);
            make.bottom.equalTo(self.kLineView);
            make.left.equalTo(self.kLineView);
            make.right.equalTo(self.kLineView);
            //        make.center.equalTo(self.kLineView);
            //        make.height.equalTo(@(63));
        }];
//        _lineView.dataArray = [self generateDataArray:self.local_DataAry];
        _lineView.dataArray = self.local_DataAry;
        
        _lineView.leftMargin = 0;
        _lineView.rightMargin = 0;
        _lineView.topMargin = 0;
        _lineView.bottomMargin = 0;
        
    } else {
//        _lineView.dataArray = [self generateDataArray:self.local_DataAry];
        _lineView.dataArray = self.local_DataAry;
    }
    [_lineView stockFill];
}

- (void)setContent:(CoinPairModel*)coinInfo dataArray:(NSArray*)ary{
    
    [_latestPriceLabel setText:[NSString stringWithFormat:@"%f",coinInfo.lastPrice]];
    [_nowPriceLabel setText:[NSString stringWithFormat:@"$%.2f",coinInfo.lastPrice*self.multiple]];
    [_highestPriceLabel  setText:[NSString stringWithFormat:@"最高价:$%.2f",coinInfo.maxPrice*self.multiple]];
    [_lowestPriceLabel  setText:[NSString stringWithFormat:@"最低价:$%.2f",coinInfo.minPrice*self.multiple]];
    [_volumLabel  setText:[NSString stringWithFormat:@"24H成交量:%f",coinInfo.totalVolume]];
    if (coinInfo.mainCoinId) {
        [_coinTypeLabel setText:[NSString stringWithFormat:@"%@/%@",coinInfo.mainCoinId,coinInfo.subCoinId]];
    } else {
        [_coinTypeLabel setText:@""];
    }
    
    [self.local_DataAry removeAllObjects];
    [self.local_DataAry addObjectsFromArray:ary];
    if (self.local_DataAry.count > 0) {
        [self setKLine];
    }
    
    BOOL isGoingHigher = [self isEndPriceHigher:coinInfo];
    double result = (coinInfo.endPrice - coinInfo.beginPrice)/coinInfo.beginPrice * 100;
    if (isnan(result)) {      //isnan为系统函数
        result = 0.0;
    }
    [_hlView setValue:[NSString stringWithFormat:@"%@%.2f%@",isGoingHigher?@"+":@"",result,@"%"] withHigh:isGoingHigher?HighLowType_High:HighLowType_Low];
}

- (NSArray*)generateDataArray:(NSArray*)ary{
    NSMutableArray *resultStrAry = [NSMutableArray array];

    for (CoinPairModel *coInfo in ary) {
        NSString *endPriceStr = [NSString stringWithFormat:@"%f",coInfo.endPrice];
        [resultStrAry addObject:endPriceStr];
    }
    
    return resultStrAry;
}

- (BOOL)isEndPriceHigher:(CoinPairModel*)coinInfo{
    double priceGap = coinInfo.endPrice - coinInfo.beginPrice;
    return (priceGap > 0)?YES:NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableArray*)local_DataAry{
    if (_local_DataAry == nil) {
        _local_DataAry = [NSMutableArray array];
    }
    return _local_DataAry;
}

@end
