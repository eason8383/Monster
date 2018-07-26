//
//  CoinPairModel.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinPairModel.h"

@implementation CoinPairModel

+(instancetype)coinPairWithDict:(NSDictionary *)dict{
    
    CoinPairModel *model = [[CoinPairModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

//@property(nonatomic,copy)NSString *coinPairId;
//@property(nonatomic,copy)NSString *mainCoinId;
//
//@property(nonatomic,copy)NSString *subCoinId;
//@property(nonatomic,copy)NSString *pairStatus;
//
//@property(nonatomic,assign)float buyFeeRate;
//@property(nonatomic,assign)float sellFeeRate;
//
//@property(nonatomic,copy)NSString *klineType;
//@property(nonatomic,copy)NSString *barTime;
//
//@property(nonatomic,assign)double totalVolume;
//@property(nonatomic,assign)double totalAmount;
//@property(nonatomic,assign)long barTimeLong;
//@property(nonatomic,assign)double beginPrice;
//@property(nonatomic,assign)double minPrice;
//@property(nonatomic,assign)double endPrice;
//@property(nonatomic,assign)double maxPrice;
//@property(nonatomic,assign)double lastPrice;

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.coinPairId = [aDecoder decodeObjectForKey:@"coinPairId"];
        self.mainCoinId = [aDecoder decodeObjectForKey:@"mainCoinId"];
        self.subCoinId = [aDecoder decodeObjectForKey:@"subCoinId"];
        self.pairStatus = [aDecoder decodeObjectForKey:@"pairStatus"];
        self.klineType = [aDecoder decodeObjectForKey:@"klineType"];
        self.barTime = [aDecoder decodeObjectForKey:@"barTime"];
        
        self.buyFeeRate = [aDecoder decodeFloatForKey:@"buyFeeRate"];
        self.sellFeeRate = [aDecoder decodeFloatForKey:@"sellFeeRate"];
        
        self.totalVolume = [aDecoder decodeDoubleForKey:@"totalVolume"];
        self.totalAmount = [aDecoder decodeDoubleForKey:@"totalAmount"];
        self.barTimeLong = [aDecoder decodeDoubleForKey:@"barTimeLong"];
        self.beginPrice = [aDecoder decodeDoubleForKey:@"beginPrice"];
        self.minPrice = [aDecoder decodeDoubleForKey:@"minPrice"];
        self.endPrice = [aDecoder decodeDoubleForKey:@"endPrice"];
        self.maxPrice = [aDecoder decodeDoubleForKey:@"maxPrice"];
        self.lastPrice = [aDecoder decodeDoubleForKey:@"lastPrice"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_coinPairId forKey:@"coinPairId"];
    [aCoder encodeObject:_mainCoinId forKey:@"mainCoinId"];
    [aCoder encodeObject:_subCoinId forKey:@"subCoinId"];
    [aCoder encodeObject:_pairStatus forKey:@"pairStatus"];
    [aCoder encodeObject:_klineType forKey:@"klineType"];
    
    [aCoder encodeFloat:_buyFeeRate forKey:@"buyFeeRate"];
    [aCoder encodeFloat:_sellFeeRate forKey:@"sellFeeRate"];
    [aCoder encodeDouble:_totalVolume forKey:@"totalVolume"];
    [aCoder encodeDouble:_totalAmount forKey:@"totalAmount"];
    [aCoder encodeDouble:_barTimeLong forKey:@"barTimeLong"];
    [aCoder encodeDouble:_beginPrice forKey:@"beginPrice"];
    [aCoder encodeDouble:_minPrice forKey:@"minPrice"];
    [aCoder encodeDouble:_endPrice forKey:@"endPrice"];
    [aCoder encodeDouble:_maxPrice forKey:@"maxPrice"];
    [aCoder encodeDouble:_lastPrice forKey:@"lastPrice"];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
