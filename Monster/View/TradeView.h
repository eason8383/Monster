//
//  TradeView.h
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoinPairModel;

@interface TradeView : UIView

@property(nonatomic,strong)IBOutlet UIButton *comfirmBtn;
@property(nonatomic,strong)IBOutlet UIButton *titleDownBtn;
@property(nonatomic,strong)IBOutlet UITextField *stepperPriceField;
@property(nonatomic,strong)IBOutlet UITextField *stepperVolumField;
@property(nonatomic,strong)IBOutlet UIButton *add_stepper1Btn;
@property(nonatomic,strong)IBOutlet UIButton *add_stepper2Btn;
@property(nonatomic,strong)IBOutlet UIButton *minus_stepper1Btn;
@property(nonatomic,strong)IBOutlet UIButton *minus_stepper2Btn;

@property(nonatomic,assign)BOOL isBuyMode;
@property(nonatomic,assign)float multiple;

- (void)setMode:(BOOL)isHigh;

- (void)setContent:(CoinPairModel*)coinInfo;

- (void)setPriceCrew:(NSArray*)buyAry saleAry:(NSArray*)saleAry;

- (void)setUerCoinQuantity:(NSArray*)userCoinAry;

- (void)titleDownBtnAnticlockwiseRotation;
- (void)titleDownBtnclockwiseRotation;


@end


