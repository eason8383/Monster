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
@property(nonatomic,copy)NSDictionary *pairStatus;
@property(nonatomic,assign)float buyFeeRate;
@property(nonatomic,assign)float sellFeeRate;

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


