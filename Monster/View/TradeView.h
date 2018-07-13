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
@property(nonatomic,strong)IBOutlet UITextField *stepperPriceField;
@property(nonatomic,strong)IBOutlet UITextField *stepperVolumField;
@property(nonatomic,assign)BOOL isHighMode;
@property(nonatomic,assign)float multiple;

- (void)setMode:(BOOL)isHigh;

- (void)setContent:(CoinPairModel*)coinInfo;

- (void)setPriceCrew:(NSArray*)buyAry saleAry:(NSArray*)saleAry;

- (void)setUerCoinQuantity:(NSArray*)userCoinAry;



@end


