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
//#import "JZNavigationExtension.h"
#import "InstructionViewController.h"
#define ANGLE_TO_RADIAN(angle) ((angle)/180.0 * M_PI)

@interface CoinDetailViewController () <CoinDetailVMDelegate,ZYWLineViewDelegate>

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

@property(nonatomic,strong)CAKeyframeAnimation *anim;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"212025"]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
     self.navigationController.navigationBar.translucent = YES;
}



- (void)initial{
    _coinDetailViewModel = [CoinDetailViewModel sharedInstance];
    _coinDetailViewModel.delegate = self;
    
    _latestPriceLabel.layer.shadowOffset=CGSizeMake(0,0);//往x方向偏移0，y方向偏移0
    _latestPriceLabel.layer.shadowOpacity = 0.5;//设置阴影透明度
    _latestPriceLabel.layer.shadowColor = [UIColor colorWithHexString:_klineColorString].CGColor;//设置阴影颜色
    _latestPriceLabel.layer.shadowRadius = 5;//设置阴影半径
    
    _pricePointLabel.layer.shadowOffset=CGSizeMake(0,0);//往x方向偏移0，y方向偏移0
    _pricePointLabel.layer.shadowOpacity = 0.5;//设置阴影透明度
    _pricePointLabel.layer.shadowColor = [UIColor colorWithHexString:_klineColorString].CGColor;//设置阴影颜色
    _pricePointLabel.layer.shadowRadius = 5;//设置阴影半径
    
//    UIBarButtonItem *InfoBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(infoMemo)];
    UIBarButtonItem *InfoBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(infoMemo)];
    [InfoBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:InfoBtn];
}

- (void)infoMemo{
    InstructionViewController *inVc = [[InstructionViewController alloc]initWithNibName:@"InstructionViewController" bundle:nil];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%@/%@",_model.mainCoinId,_model.subCoinId] style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:inVc animated:YES];
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
//        _klineColorString = @"6241D1";
        _klineColorString = @"5100E3";
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
    
    [self setTitlePrice:[NSString stringWithFormat:@"%f",_model.lastPrice]];
    
    [_subPrice_Label  setText:[NSString stringWithFormat:@"≈$%.2f",_model.lastPrice*self.multiple]];
    [_height_Label setText:[NSString stringWithFormat:@"$%.2f",_model.maxPrice*self.multiple]];
    [_low_Label  setText:[NSString stringWithFormat:@"$%.2f",_model.minPrice*self.multiple]];
    [_oneDay_Label  setText:[NSString stringWithFormat:@"$%.2f",_model.endPrice*self.multiple]];
    
    [_pesent_Label setText:[NSString stringWithFormat:@"%.2f",result]];
}

- (void)setTitlePrice:(NSString*)priceString{
    NSArray *priceAry = [priceString componentsSeparatedByString:@"."];
    [_latestPriceLabel setText: [NSString stringWithFormat:@"%@.",[priceAry objectAtIndex:0]]];
    [_pricePointLabel setText:[priceAry objectAtIndex:1]];
}

- (void)setBottomGrid{
    if (!self.imageView1) {
        self.imageView1 = [[FLAnimatedImageView alloc] init];
        self.imageView1.contentMode = UIViewContentModeScaleToFill;
        self.imageView1.clipsToBounds = YES;
    }
    [self.gridImag addSubview:_imageView1];
    self.imageView1.frame = CGRectMake(0, 0, kScreenWidth, self.gridImag.bounds.size.height);
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:_gridString withExtension:@"gif"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    self.imageView1.animatedImage = animatedImage1;
}

- (void)setKLine{
    _lineView = [[ZYWLineView alloc] initWithFrame:CGRectMake(0, 0, _kLineView.width, _kLineView.height)];
    _lineView.delegate = self;
    _lineView.lineWidth = 2;
    _lineView.backgroundColor = [UIColor clearColor];
    _lineView.lineColor = [UIColor colorWithHexString:_klineColorString];

//    _lineView.fillColor = [UIColor colorWithHexString:@"6241D1"];
    _lineView.isFillColor = NO;
    _lineView.lightEffect = YES;
    _lineView.useAnimation = NO;
    _lineView.hasDraggableLine = YES;
    [_kLineView addSubview:_lineView];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.kLineView);
        make.left.right.equalTo(self.kLineView);
        make.height.equalTo(@(self.kLineView.height));
    }];
//    [_lineView layoutIfNeeded];
//    _lineView.dataArray = @[@"12",@"23",@"26",@"27",@"28",@"30",@"31",@"32",@"33",@"36",@"39",@"41",@"43",@"44",@"42",@"43",@"46",@"40",@"47",@"49",@"52",@"53",@"54",@"52",@"53",@"56",@"50",@"57",@"59",@"52",@"59",@"64",@"60",@"54",@"53",@"52",@"51",@"50",@"48",@"43",@"42",@"39",@"36",@"34",@"30",@"37",@"39",@"32",@"37",@"30",@"29",@"23",@"26",@"20",@"17",@"19",@"12"];
    
//    _lineView.dataArray = [self generateDataArray:self.klineDataAry];
    _lineView.dataArray = self.klineDataAry;
    _lineView.leftMargin = 0;
    _lineView.rightMargin = 0;
    _lineView.topMargin = 0;
    _lineView.bottomMargin = 0;
    [_lineView stockFill];
}

- (void)returnPrice:(double)price{
    [self setTitlePrice:[NSString stringWithFormat:@"%f",price]];
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
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tdVC];
    tdVC.multiple = self.multiple;
    tdVC.model = self.model;
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:tdVC animated:YES];
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

- (void)touchesBegen{
    [self start];
}

- (void)touchesEnd{
    [self end];
}

//- (void)shackDurtion:(float)durtionTime{
//    _anim.duration = durtionTime;
//}

- (void)dragingWithDuration:(float)duration{
    
    NSLog(@"看這 %f",duration);
    
    [_latestPriceLabel.layer removeAnimationForKey:@"shake"];
    [_pricePointLabel.layer removeAnimationForKey:@"shake"];
    
    _anim.duration = duration;
    
    [_latestPriceLabel.layer addAnimation:_anim forKey:@"shake"];
    [_pricePointLabel.layer addAnimation:_anim forKey:@"shake"];
        
}

- (void)start{
    
    //实例化
    _anim = [CAKeyframeAnimation animation];
    
    //拿到动画 key
    
    _anim.keyPath =@"transform.rotation";
    
    // 动画时间
    
    _anim.duration = 5;
    
    
    // 重复的次数
    
    //anim.repeatCount = 16;
    
    //无限次重复
    
    _anim.repeatCount =MAXFLOAT;
    
    
    //设置抖动数值
    
    _anim.values =@[@(ANGLE_TO_RADIAN(1)),@(ANGLE_TO_RADIAN(4)),@(ANGLE_TO_RADIAN(1))];
    
    
    // 保持最后的状态
    
    _anim.removedOnCompletion =NO;
    
    //动画的填充模式
    
    _anim.fillMode =kCAFillModeForwards;
    
    //layer层实现动画
    
    [_latestPriceLabel.layer addAnimation:_anim forKey:@"shake"];
    [_pricePointLabel.layer addAnimation:_anim forKey:@"shake"];
    
}

- (void)end {
    
    //图标
    
    [_latestPriceLabel.layer removeAnimationForKey:@"shake"];
    [_pricePointLabel.layer removeAnimationForKey:@"shake"];
    
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
