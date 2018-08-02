//
//  CoinPairModel.h
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRBaseModel.h"



@interface CoinPairModel : NSObject

@property(nonatomic,copy)NSString *coinPairId;
@property(nonatomic,copy)NSString *mainCoinId;

@property(nonatomic,copy)NSString *subCoinId;
@property(nonatomic,copy)NSString *pairStatus;

@property(nonatomic,assign)float buyFeeRate;
@property(nonatomic,assign)float sellFeeRate;

@property(nonatomic,copy)NSString *klineType;
@property(nonatomic,copy)NSString *barTime;

@property(nonatomic,assign)double totalVolume;
@property(nonatomic,assign)double totalAmount;
@property(nonatomic,assign)long barTimeLong;
@property(nonatomic,assign)double beginPrice;
@property(nonatomic,assign)double minPrice;
@property(nonatomic,assign)double endPrice;
@property(nonatomic,assign)double maxPrice;
@property(nonatomic,assign)double lastPrice;

+(instancetype)coinPairWithDict:(NSDictionary *)dict;
//{
//    barTime = 20180801000000;
//    barTimeLong = 1533052800000;
//    beginPrice = "0.00066";
//    buyFeeRate = "0.001";
//    coinPairId = 10001;
//    endPrice = "0.00066";
//    klineType = 5;
//    lastPrice = "0.00066";
//    mainCoinId = MR;
//    maxPrice = "0.00066";
//    minPrice = "0.00066";
//    pairStatus = 1;
//    sellFeeRate = "0.001";
//    subCoinId = ETH;
//    totalAmount = "0.64086";
//    totalVolume = 971;
//}

@end


