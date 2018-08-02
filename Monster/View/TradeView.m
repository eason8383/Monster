//
//  TradeView.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "TradeView.h"
#import "CoinPairModel.h"
#import "TrandModel.h"
#import "UCoinQuantity.h"
#import "MRButton.h"

@interface TradeView () <UITextFieldDelegate>
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)IBOutlet UILabel *subPriceLabel;
@property(nonatomic,strong)IBOutlet UILabel *numberLabel;
@property(nonatomic,strong)IBOutlet UILabel *estimateLabel;
@property(nonatomic,strong)IBOutlet UILabel *canUseLabel;
@property(nonatomic,strong)IBOutlet UILabel *canBuyLabel;
@property(nonatomic,strong)IBOutlet UILabel *valueLabel;

@property(nonatomic,strong)IBOutlet UIView *tagView;
@property(nonatomic,strong)IBOutlet UIView *steppView1;
@property(nonatomic,strong)IBOutlet UIView *steppView2;

@property(nonatomic,strong)IBOutlet UIButton *buyBtn;
@property(nonatomic,strong)IBOutlet UIButton *saleBtn;

@property(nonatomic,strong)IBOutlet UIButton *limitPriceBtn;

@property(nonatomic,strong)IBOutlet UIButton *upBtn_price1;
@property(nonatomic,strong)IBOutlet UIButton *upBtn_price2;
@property(nonatomic,strong)IBOutlet UIButton *upBtn_price3;
@property(nonatomic,strong)IBOutlet UIButton *upBtn_price4;
@property(nonatomic,strong)IBOutlet UIButton *upBtn_price5;
@property(nonatomic,strong)IBOutlet UILabel *up_unit1Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit2Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit3Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit4Label;
@property(nonatomic,strong)IBOutlet UILabel *up_unit5Label;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price1;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price2;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price3;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price4;
@property(nonatomic,strong)IBOutlet UIButton *downBtn_price5;
@property(nonatomic,strong)IBOutlet UILabel *down_unit1Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit2Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit3Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit4Label;
@property(nonatomic,strong)IBOutlet UILabel *down_unit5Label;

@property(nonatomic,strong)IBOutlet MRButton *quickDividBtn1;
@property(nonatomic,strong)IBOutlet MRButton *quickDividBtn2;
@property(nonatomic,strong)IBOutlet MRButton *quickDividBtn3;
@property(nonatomic,strong)IBOutlet MRButton *quickDividBtn4;
@property(nonatomic,strong)IBOutlet MRButton *quickDividBtn5;

@property(nonatomic,strong)NSArray *userCoinAry;

@property UITapGestureRecognizer *tapRecognizer;

@property(nonatomic,strong)CoinPairModel *model;

@property(nonatomic,strong)NSString *nowRate;

@end

@implementation TradeView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _buyBtn.layer.cornerRadius = 4;
    _saleBtn.layer.cornerRadius = 4;
    _comfirmBtn.layer.cornerRadius = 4;
    
    _tagView.layer.borderWidth = 1;
    _tagView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    _tagView.layer.cornerRadius = 4;
    
    _steppView1.layer.borderWidth = 1;
    _steppView1.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    _steppView1.layer.cornerRadius = 4;
    
    _steppView2.layer.borderWidth = 1;
    _steppView2.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    _steppView2.layer.cornerRadius = 4;
    [_stepperVolumField setValue:[UIColor colorWithWhite:1 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowLabelView" owner:self options:nil];
    _hlView = [nib objectAtIndex:0];
    [_hlView setValue:@"+22.2%" withHigh:HighLowType_High];
    [_highLowViewBack addSubview:_hlView];
    
    _quickDividBtn1.layer.cornerRadius = 6;
    _quickDividBtn2.layer.cornerRadius = 6;
    _quickDividBtn3.layer.cornerRadius = 6;
    _quickDividBtn4.layer.cornerRadius = 6;
    _quickDividBtn5.layer.cornerRadius = 6;
    
    _nowRate = @"0";
}

- (IBAction)addOrMinesPrice:(UIButton*)btn{
    
    float price = 0;
    if (_stepperPriceField.text.length > 0) {
        price = [_stepperPriceField.text floatValue];
    }

    if (btn.tag == 1) { //add;
        price += 0.000001;
    } else { //mines
        price -= 0.000001;
    }
    
    [_stepperPriceField setText:[NSString stringWithFormat:@"%f",price]];
    if (self.isBuyMode) {
        [self setUerCoinQuantity:_userCoinAry];
        [self resetVolumField];
    }
}

- (IBAction)addOrMinesNum:(UIButton*)btn{
    
    float num = 0;
    
    if (_stepperVolumField.text.length > 0) {
        num = [_stepperVolumField.text floatValue];
    }
    
    if (btn.tag == 1) { //add
        
        NSArray *tampAry = [_valueLabel.text componentsSeparatedByString:@" "];
        NSString *result = [self decimalSubtracting:[tampAry objectAtIndex:0] with:_stepperVolumField.text];
        if ([result floatValue] > 1) { //确认总数够1
            
            NSString *result = [self decimalAdding:_stepperVolumField.text with:@"1"];
            [_stepperVolumField setText:[NSString stringWithFormat:@"%@",result]];
        }
        _add_stepper2Btn.enabled = ([result floatValue] > 1)?YES:NO;
        _minus_stepper2Btn.enabled = YES;
    } else { //mines
        if (num > 0) {
            num -= 1;
            NSString *result = [self decimalSubtracting:_stepperVolumField.text with:@"1"];
            [_stepperVolumField setText:[NSString stringWithFormat:@"%@",result]];
        }
        _add_stepper2Btn.enabled = YES;
        _minus_stepper2Btn.enabled = (num > 0)?YES:NO;
        
    }
}

- (void)setDividBtns:(UIButton*)btn{
    [self changImag:btn];
//    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changImag:(UIButton*)btn{
    
    [btn setImage:[UIImage imageNamed:self.isBuyMode?@"btn_green":@"btn_red"] forState:UIControlStateSelected];
}

- (void)handleButtonPress:(UIButton*)btn{

    [self setAllQuickDividBtnUnselect:_quickDividBtn1];
    [self setAllQuickDividBtnUnselect:_quickDividBtn2];
    [self setAllQuickDividBtnUnselect:_quickDividBtn3];
    [self setAllQuickDividBtnUnselect:_quickDividBtn4];
    [self setAllQuickDividBtnUnselect:_quickDividBtn5];
    
    if (btn.selected == NO) {
        btn.selected = YES;
        CGRect frame = btn.frame;
        frame.origin.x -= 2.5;
        frame.origin.y -= 2.5;
        frame.size.width = 17;
        frame.size.height = 17;
        [btn setFrame:frame];
        [btn setBackgroundColor:[UIColor clearColor]];
    }
    
    switch (btn.tag) {
        case 1:
            _nowRate = @"0";
            break;
        case 2:
            _nowRate = @"0.25";
            break;
        case 3:
            _nowRate = @"0.5";
            break;
        case 4:
            _nowRate = @"0.75";
            break;
        case 5:
            _nowRate = @"1";
            break;
        default:
            _nowRate = @"0";
            break;
    }
    
    _add_stepper2Btn.enabled = btn.tag == 5?NO:YES;
    _minus_stepper2Btn.enabled = btn.tag == 1?NO:YES;
    
    [self resetVolumField];
}

- (void)resetVolumField{
    NSArray *tampAry = [_valueLabel.text componentsSeparatedByString:@" "];
    NSString *result = [self decimalMultiply:[tampAry objectAtIndex:0] with:_nowRate];
    [_stepperVolumField setText:result];
}

- (void)setAllQuickDividBtnUnselect:(UIButton*)btn{
    if (btn.selected == YES) {
        btn.selected = NO;
        CGRect frame = btn.frame;
        frame.origin.x += 2.5;
        frame.origin.y += 2.5;
        frame.size.width = 12;
        frame.size.height = 12;
        [btn setFrame:frame];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"A9A9A9"]];
    }
}

- (void)titleDownBtnAnticlockwiseRotation{
    //arrowLeft 是要旋转的控件
    //逆时针 旋转180度
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.5]; //动画时长
//    _titleDownBtn.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
//    CGAffineTransform transform = _titleDownBtn.transform;
//    //第二个值表示横向放大的倍数，第三个值表示纵向缩小的程度
//    transform = CGAffineTransformScale(transform, 1,1);
//    _titleDownBtn.transform = transform;
//    [UIView commitAnimations];
    
    self.titleDownBtn.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
    CGAffineTransform transform = self.titleDownBtn.transform;
    transform = CGAffineTransformScale(transform, 1,1);
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         
                         self.titleDownBtn.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             
                         }];
                     }];
    
}

- (void)titleDownBtnclockwiseRotation{
    //顺时针 旋转180度
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.5]; //动画时长
    _titleDownBtn.transform = CGAffineTransformMakeRotation(0*M_PI/180);
    CGAffineTransform transform = _titleDownBtn.transform;
    transform = CGAffineTransformScale(transform, 1,1);
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         
                         self.titleDownBtn.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             
                         }];
                     }];
}

- (IBAction)bringPriceToField:(UIButton*)btn{

    [_stepperPriceField setText:btn.titleLabel.text];
    if (self.isBuyMode) {
        [self setUerCoinQuantity:_userCoinAry];
        [self resetVolumField];
    }
}

- (void)highMode{
    _buyBtn.backgroundColor = [UIColor  colorWithHexString:MRCOLORHEX_HIGH];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _comfirmBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_HIGH];
    _saleBtn.backgroundColor = [UIColor clearColor];
    _saleBtn.layer.borderColor = [UIColor colorWithHexString:MRCOLORHEX_LOW].CGColor;
    _saleBtn.layer.borderWidth = 1;
    [_saleBtn setTitleColor:[UIColor colorWithHexString:MRCOLORHEX_LOW] forState:UIControlStateNormal];
    [_comfirmBtn setTitle:[NSString stringWithFormat:@"买入%@",_model.subCoinId] forState:UIControlStateNormal];
}

- (void)lowMode{
    _buyBtn.backgroundColor = [UIColor  clearColor];
    
    [_buyBtn setTitleColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH] forState:UIControlStateNormal];
    _buyBtn.layer.borderWidth = 1;
    _buyBtn.layer.borderColor  = [UIColor  colorWithHexString:MRCOLORHEX_HIGH].CGColor;
    _comfirmBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_LOW];
    _saleBtn.backgroundColor = [UIColor colorWithHexString:MRCOLORHEX_LOW];
    [_saleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_comfirmBtn setTitle:[NSString stringWithFormat:@"卖出%@",_model.subCoinId] forState:UIControlStateNormal];
}

- (void)setMode:(BOOL)isHigh{
    self.isBuyMode = isHigh;
    if (self.isBuyMode) {
        [self highMode];
    } else {
        [self lowMode];
    }
    [self setDividBtns:_quickDividBtn1];
    [self setDividBtns:_quickDividBtn2];
    [self setDividBtns:_quickDividBtn3];
    [self setDividBtns:_quickDividBtn4];
    [self setDividBtns:_quickDividBtn5];
}

- (void)setContent:(CoinPairModel*)coinInfo{
    _model = coinInfo;
    [_titleLabel setText:[NSString stringWithFormat:@"%@/%@",coinInfo.mainCoinId,coinInfo.subCoinId]];
    [_priceLabel setText:[NSString stringWithFormat:@"%f",coinInfo.lastPrice]];
    
    NSString *currencyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    NSString *dollarSign = [currencyStr isEqualToString:CNY]?@"￥":@"$";
    
    [_subPriceLabel setText:[NSString stringWithFormat:@"≈%@%f",dollarSign,coinInfo.lastPrice*self.multiple]];
    BOOL isGoingHigher = [self isEndPriceHigher:coinInfo];
    double result = (coinInfo.endPrice - coinInfo.beginPrice)/coinInfo.beginPrice * 100;
    if (isnan(result)) {      //isnan为系统函数
        result = 0.0;
    }
    [_stepperVolumField setText:[NSString stringWithFormat:@"数量(%@)",coinInfo.mainCoinId]];
    [_hlView setValue:[NSString stringWithFormat:@"%@%.2f%@",isGoingHigher?@"+":@"",result,@"%"] withHigh:isGoingHigher?HighLowType_High:HighLowType_Low];
    
    if (self.isBuyMode) {
        [self highMode];
    } else {
        [self lowMode];
    }
    UIButton *fBtn = [[UIButton alloc]init];
    fBtn.tag = 0;
    [self handleButtonPress:fBtn];
}

- (void)setPriceCrew:(NSArray*)buyAry saleAry:(NSArray*)saleAry{
    
    [saleAry enumerateObjectsUsingBlock:^(TrandModel *model,NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case 0: {
                [self.upBtn_price1 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit1Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
                [self.stepperPriceField setText:[NSString stringWithFormat:@"%f",model.orderPrice]];
            }
                break;
                
            case 1: {
                [self.upBtn_price2 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit2Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 2: {
                [self.upBtn_price3 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit3Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 3: {
                [self.upBtn_price4 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit4Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 4: {
                [self.upBtn_price5 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.up_unit5Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            default:
                break;
        }
        
    }];
    [buyAry enumerateObjectsUsingBlock:^(TrandModel *model,NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case 0: {
                [self.downBtn_price1 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit1Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
                
            case 1: {
                [self.downBtn_price2 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit2Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 2: {
                [self.downBtn_price3 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit3Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 3: {
                [self.downBtn_price4 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit4Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            case 4: {
                [self.downBtn_price5 setTitle:[NSString stringWithFormat:@"%f",model.orderPrice] forState:UIControlStateNormal];
                [self.down_unit5Label setText:[NSString stringWithFormat:@"%.2f",model.orderVolume]];
            }
                break;
            default:
                break;
        }
        
    }];
}

- (void)setUerCoinQuantity:(NSArray*)userCoinAry{
    _userCoinAry = [NSArray array];
    _userCoinAry = userCoinAry;
    if (self.isBuyMode) {
        for (UCoinQuantity *uCoin in _userCoinAry) {
            if ([uCoin.coinId isEqualToString:@"ETH"] && [uCoin.quantityStatusName isEqualToString:@"普通"]) {
                [_canUseLabel setText:[NSString stringWithFormat:@"%.2f ETH",uCoin.coinQuantity]];
                
                NSString *canBuyResult = [self decimalDividing:[NSString stringWithFormat:@"%.6f",uCoin.coinQuantity] with:_stepperPriceField.text];
                [_canBuyLabel setText:[NSString stringWithFormat:@"%@ %@",canBuyResult,self.model.mainCoinId]];
                [_valueLabel setText:[NSString stringWithFormat:@"%@ %@",canBuyResult,self.model.mainCoinId]];
            }
        }
        
    } else {
        for (UCoinQuantity *uCoin in _userCoinAry) {
            if ([uCoin.coinId isEqualToString:@"MR"] && [uCoin.quantityStatusName isEqualToString:@"普通"]) {
                
                [_canBuyLabel setText:[NSString stringWithFormat:@"%.2f MR",uCoin.coinQuantity]];
                [_valueLabel setText:[NSString stringWithFormat:@"%.2f MR",uCoin.coinQuantity]];
            }
        }
    }
}

- (NSString*)decimalAdding:(NSString*)numStr1 with:(NSString*)numStr2{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:numStr1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:numStr2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    
    NSDecimalNumber *result = [num1 decimalNumberByAdding:num2 withBehavior:roundUp];
    
    return [result stringValue];
}

- (NSString*)decimalSubtracting:(NSString*)numStr1 with:(NSString*)numStr2{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:numStr1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:numStr2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    
    NSDecimalNumber *result = [num1 decimalNumberBySubtracting:num2 withBehavior:roundUp];
    
    return [result stringValue];
}

- (NSString*)decimalDividing:(NSString*)numStr1 with:(NSString*)numStr2{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:numStr1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:numStr2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    
    NSDecimalNumber *result = [num1 decimalNumberByDividingBy:num2 withBehavior:roundUp];
    
    return [result stringValue];
}

- (NSString*)decimalMultiply:(NSString*)numStr1 with:(NSString*)numStr2{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:numStr1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:numStr2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    
    NSDecimalNumber *result = [num1 decimalNumberByMultiplyingBy:num2 withBehavior:roundUp];
    
    return [result stringValue];
}



- (BOOL)isEndPriceHigher:(CoinPairModel*)coinInfo{
    double priceGap = coinInfo.endPrice - coinInfo.beginPrice;
    return (priceGap > 0)?YES:NO;
}


- (IBAction)switchMode:(UIButton*)btn{
    
    if (btn.tag == 1) {
        [self highMode];
        self.isBuyMode = YES;
    } else {
        [self lowMode];
        self.isBuyMode = NO;
    }
    
    //重新計算
    [self setUerCoinQuantity:_userCoinAry];
    [self resetVolumField];
    
    //換Btn圖片
    [self changImag:_quickDividBtn1];
    [self changImag:_quickDividBtn2];
    [self changImag:_quickDividBtn3];
    [self changImag:_quickDividBtn4];
    [self changImag:_quickDividBtn5];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self setUerCoinQuantity:_userCoinAry];
    [self resetVolumField];
    return YES;
}

@end
