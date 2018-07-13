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
//"buyFeeRate": 0.0001,
//"coinPairId": "10001",
//"mainCoinId": "ETH",
//"pairStatus": {
//    "code": "1",
//    "desc": "执行中"
//},
//"sellFeeRate": 0.0001,
//"subCoinId": "MR"

@end


