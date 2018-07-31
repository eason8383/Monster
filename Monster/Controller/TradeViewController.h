//
//  TradeViewController.h
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoinPairModel;

@interface TradeViewController : UIViewController

@property(nonatomic,assign)BOOL isHigh;
@property(nonatomic,strong)CoinPairModel *model;
@property(nonatomic,strong)NSString *multiple;

@end


