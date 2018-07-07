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

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
