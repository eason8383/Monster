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
#import "CoinPairModel.h"

@interface CoinTrendsCell()

@property(nonatomic,strong)IBOutlet UILabel *coinTitleLabel;
@property(nonatomic,strong)IBOutlet UIView *highLowView;
@property(nonatomic,strong)IBOutlet UIView *kLineView;
@property(nonatomic,strong)HighLowLabelView *hlView;

@property(nonatomic,strong)NSMutableArray *local_DataAry;

@property(nonatomic,strong)ZYWLineView *lineView;

@property(nonatomic,strong)NSString *klineColorString;

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
        _lineView.lineColor = [UIColor colorWithHexString:_klineColorString];
        
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
        _lineView.dataArray = @[];
//        if ([_lineView.dataArray count] < 1) {
//            _lineView.dataArray = @[@"12",@"33",@"26",@"10",@"7",@"30",@"21",@"26",@"10",@"7",@"30",@"21",@"26",@"10",@"7",@"30",@"21"];
//        }
        _lineView.leftMargin = 0;
        _lineView.rightMargin = 0;
        _lineView.topMargin = 0;
        _lineView.bottomMargin = 0;
        [_lineView stockFill];
    }
    
}

- (void)setContent:(CoinPairModel*)coinInfo dataArray:(NSArray*)ary{
    [_coinTitleLabel setText:[NSString stringWithFormat:@"%@/%@",coinInfo.mainCoinId,coinInfo.subCoinId]];
    [self.local_DataAry addObjectsFromArray:ary];
    _lineView.dataArray = [self generateDataArray:self.local_DataAry];
    [_lineView stockFill];
    
    BOOL isGoingHigher = [self isEndPriceHigher:coinInfo];
    double result = (coinInfo.endPrice - coinInfo.beginPrice)/coinInfo.beginPrice * 100;
    [_hlView setValue:[NSString stringWithFormat:@"$%.2f",result] withHigh:isGoingHigher?HighLowType_High:HighLowType_Low];
    
    _klineColorString = isGoingHigher?MRCOLORHEX_HIGH:MRCOLORHEX_LOW;
    _lineView.lineColor = [UIColor colorWithHexString:_klineColorString];
}

- (BOOL)isEndPriceHigher:(CoinPairModel*)coinInfo{
    double priceGap = coinInfo.endPrice - coinInfo.beginPrice;
    return (priceGap > 0)?YES:NO;
}

- (NSArray*)generateDataArray:(NSArray*)ary{
    NSMutableArray *resultStrAry = [NSMutableArray array];

    for (CoinPairModel *coInfo in ary) {
        NSString *endPriceStr = [NSString stringWithFormat:@"%f",coInfo.endPrice];
        [resultStrAry addObject:endPriceStr];
    }
//    NSLog(@"%@",resultStrAry);
    return resultStrAry;
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
