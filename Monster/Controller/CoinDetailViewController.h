//
//  CoinDetailViewController.h
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoinPairModel;


@interface CoinDetailViewController : UIViewController

@property(nonatomic,assign)BOOL isHighLowKLine;
@property(nonatomic,strong)CoinPairModel *model;
@property(nonatomic,strong)NSMutableArray *klineDataAry;
@property(nonatomic,strong)NSString *multiple;

@end

