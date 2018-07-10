//
//  CoinDetailViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinDetailViewController.h"
#import "TradeViewController.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "ZYWLineView.h"

@interface CoinDetailViewController ()

@property(nonatomic,strong)IBOutlet UIView *kLineView;
@property(nonatomic,strong)IBOutlet UIImageView *gridImag;

@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
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
    
}

- (void)setStyle{
    if (self.isHighLowKLine) {
        _gridString = @"redGrid";
        _klineColorString = MRCOLORHEX_LOW;
        [_buyBtn setBackgroundColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH]];
        [_saleBtn setBackgroundColor:[UIColor colorWithHexString:MRCOLORHEX_LOW]];
    } else {
        [_buyBtn setBackgroundColor:[UIColor colorWithHexString:@"5100E3"]];
        [_saleBtn setBackgroundColor:[UIColor colorWithHexString:@"5100E3"]];
        
        _gridString = @"purpleGrid";
        _klineColorString = @"6241D1";
    }
}


- (void)loadView{
    [super loadView];
    [self setStyle];
    [self setKLine];
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
    
    [_kLineView addSubview:_lineView];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.kLineView);
        make.left.right.equalTo(self.kLineView);
        make.height.equalTo(@(self.kLineView.height));
    }];
//    [_lineView layoutIfNeeded];
//        _dataArray = @[@"12",@"33",@"26",@"10",@"7",@"30",@"21"];
    
    _lineView.dataArray = @[@"12",@"33",@"26",@"18",@"25",@"30",@"25",@"33",@"26",@"27",@"25",@"30",@"32",@"33",@"26",@"18",@"25",@"30",@"38",@"44",@"46"];
    _lineView.leftMargin = 0;
    _lineView.rightMargin = 0;
    _lineView.topMargin = 0;
    _lineView.bottomMargin = 0;
    [_lineView stockFill];
}


- (IBAction)openTrade:(UIButton*)btn{
    
    TradeViewController *tdVC = [[TradeViewController alloc]initWithNibName:@"TradeViewController" bundle:nil];
    tdVC.isHigh = (btn.tag == 1)?YES:NO;
    tdVC.title = @"交易";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tdVC];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
}

@end
