//
//  CoinDetailViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinDetailViewController.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "TradeViewController.h"
#import "ZYWLineView.h"
#import "CoinPairModel.h"
#import "CoinDetailViewModel.h"

@interface CoinDetailViewController () <CoinDetailVMDelegate>

@property(nonatomic,strong)IBOutlet UIView *kLineView;
@property(nonatomic,strong)IBOutlet UIImageView *gridImag;

@property(nonatomic,strong)IBOutlet UILabel *latestPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *pricePointLabel;

@property(nonatomic,strong)IBOutlet UILabel *height_Label;
@property(nonatomic,strong)IBOutlet UILabel *low_Label;
@property(nonatomic,strong)IBOutlet UILabel *oneDay_Label;
@property(nonatomic,strong)IBOutlet UILabel *subPrice_Label;
@property(nonatomic,strong)IBOutlet UILabel *pesent_Label;

@property(nonatomic,strong)IBOutlet UIButton *buyBtn;
@property(nonatomic,strong)IBOutlet UIButton *saleBtn;

@property(nonatomic,strong)IBOutlet UIButton *timeBtn_min;
@property(nonatomic,strong)IBOutlet UIButton *timeBtn_quter;
@property(nonatomic,strong)IBOutlet UIButton *timeBtn_hour;
@property(nonatomic,strong)IBOutlet UIButton *timeBtn_day;
@property(nonatomic,strong)IBOutlet UIButton *timeBtn_week;
@property(nonatomic,strong)IBOutlet UIButton *timeBtn_month;
@property(nonatomic,strong)NSString *gridString;
@property(nonatomic,strong)NSString *klineColorString;

@property(nonatomic,strong)FLAnimatedImageView *imageView1;

@property(nonatomic,strong)ZYWLineView *lineView;

@property(nonatomic,strong)CoinDetailViewModel *coinDetailViewModel;

@end

@implementation CoinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buyBtn.layer.cornerRadius = 4;
    _saleBtn.layer.cornerRadius = 4;
    _timeBtn_min.layer.cornerRadius = 4;
    _timeBtn_quter.layer.cornerRadius = 4;
    _timeBtn_hour.layer.cornerRadius = 4;
    _timeBtn_day.layer.cornerRadius = 4;
    _timeBtn_week.layer.cornerRadius = 4;
    _timeBtn_month.layer.cornerRadius = 4;
    
    [self initial];
}

- (void)initial{
    _coinDetailViewModel = [CoinDetailViewModel sharedInstance];
    _coinDetailViewModel.delegate = self;
}

- (void)getDataSucess{
    NSArray *info = [_coinDetailViewModel getDrawKLineInfoArray:self.model.coinPairId];
    [self.klineDataAry removeAllObjects];
    [self.klineDataAry addObjectsFromArray:info];
    [_lineView stockFill];
}

- (void)setStyle{
    
    if (self.isHighLowKLine) {
        
        BOOL isGoingHigher = [self isEndPriceHigher:_model];
    
        _gridString = isGoingHigher?@"greenGrid":@"redGrid";
        _klineColorString = isGoingHigher?MRCOLORHEX_HIGH:MRCOLORHEX_LOW;
    
        [_buyBtn setBackgroundColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH]];
        [_saleBtn setBackgroundColor:[UIColor colorWithHexString:MRCOLORHEX_LOW]];
    } else {
        [_buyBtn setBackgroundColor:[UIColor colorWithHexString:@"5100E3"]];
        [_saleBtn setBackgroundColor:[UIColor colorWithHexString:@"5100E3"]];
        
        _gridString = @"purpleGrid";
        _klineColorString = @"6241D1";
    }
    
    [self cleanAlltimeBtn];
    [_timeBtn_min setBackgroundColor:[UIColor colorWithHexString:_klineColorString]];
}

- (BOOL)isEndPriceHigher:(CoinPairModel*)coinInfo{
    double priceGap = coinInfo.endPrice - coinInfo.beginPrice;
    return (priceGap > 0)?YES:NO;
}

- (void)loadView{
    [super loadView];
    [self setStyle];
    [self setContent];
    [self setKLine];
    [self setBottomGrid];
}

- (void)setContent{
    double result = (_model.endPrice - _model.beginPrice)/_model.beginPrice * 100;
    if (isnan(result)) {      //isnan为系统函数
        result = 0.0;
    }
    NSString *priceStr = [NSString stringWithFormat:@"%f",_model.lastPrice];
    NSArray *priceAry = [priceStr componentsSeparatedByString:@"."];
    [_latestPriceLabel setText: [NSString stringWithFormat:@"%@.",[priceAry objectAtIndex:0]]];
    [_pricePointLabel setText:[priceAry objectAtIndex:1]];
    [_subPrice_Label  setText:[NSString stringWithFormat:@"≈$%.2f",_model.lastPrice*self.multiple]];
    [_height_Label setText:[NSString stringWithFormat:@"$%.2f",_model.maxPrice*self.multiple]];
    [_low_Label  setText:[NSString stringWithFormat:@"$%.2f",_model.minPrice*self.multiple]];
    [_oneDay_Label  setText:[NSString stringWithFormat:@"$%.2f",_model.endPrice*self.multiple]];
    
    [_pesent_Label setText:[NSString stringWithFormat:@"%.2f",result]];
    
}

- (void)setBottomGrid{
    if (!self.imageView1) {
        self.imageView1 = [[FLAnimatedImageView alloc] init];
        self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView1.clipsToBounds = YES;
    }
    [self.gridImag addSubview:_imageView1];
    self.imageView1.frame = self.gridImag.bounds;
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:_gridString withExtension:@"gif"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    self.imageView1.animatedImage = animatedImage1;
}

- (void)setKLine{
    _lineView = [[ZYWLineView alloc] initWithFrame:CGRectMake(0, 0, _kLineView.width, _kLineView.height)];
    _lineView.lineWidth = 2;
    _lineView.backgroundColor = [UIColor clearColor];
    _lineView.lineColor = [UIColor colorWithHexString:_klineColorString];
    
//    _lineView.fillColor = [UIColor colorWithHexString:@"6241D1"];
    _lineView.isFillColor = NO;
    _lineView.useAnimation = YES;
    _lineView.hasDraggableLine = YES;
    [_kLineView addSubview:_lineView];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.kLineView);
        make.left.right.equalTo(self.kLineView);
        make.height.equalTo(@(self.kLineView.height));
    }];
//    [_lineView layoutIfNeeded];
//        _dataArray = @[@"12",@"33",@"26",@"10",@"7",@"30",@"21"];
    
    _lineView.dataArray = [self generateDataArray:self.klineDataAry];
    _lineView.leftMargin = 0;
    _lineView.rightMargin = 0;
    _lineView.topMargin = 0;
    _lineView.bottomMargin = 0;
    [_lineView stockFill];
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


- (IBAction)openTrade:(UIButton*)btn{
    
    TradeViewController *tdVC = [[TradeViewController alloc]initWithNibName:@"TradeViewController" bundle:nil];
    tdVC.isHigh = (btn.tag == 1)?YES:NO;
    tdVC.title = @"交易";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tdVC];
    tdVC.multiple = self.multiple;
    tdVC.model = self.model;
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)selectTimeInteval:(UIButton*)btn{
    [self cleanAlltimeBtn];
    [btn setBackgroundColor:[UIColor colorWithHexString:_klineColorString]];
    NSString *klineType;
    switch (btn.tag) {
        case 0:
            klineType = @"0";
            break;
        case 1:
            klineType = @"2";
            break;
        case 2:
            klineType = @"4";
            break;
        case 3:
            klineType = @"5";
            break;
        case 4:
            klineType = @"6";
            break;
        case 5:
            klineType = @"7";
            break;
        default:
            klineType = @"0";
            break;
    }
    [_coinDetailViewModel getKlineList:klineType withLimit:100];
}

- (void)cleanAlltimeBtn{
    _timeBtn_min.backgroundColor = [UIColor clearColor];
    _timeBtn_quter.backgroundColor = [UIColor clearColor];
    _timeBtn_hour.backgroundColor = [UIColor clearColor];
    _timeBtn_day.backgroundColor = [UIColor clearColor];
    _timeBtn_week.backgroundColor = [UIColor clearColor];
    _timeBtn_month.backgroundColor = [UIColor clearColor];
}

@end
