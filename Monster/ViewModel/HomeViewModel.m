//
//  HomeViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/10.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "HomeViewModel.h"
#import "MRHomePageClient.h"
#import "CoinPairModel.h"
#import "MRUserInfoClient.h"
#import "UserCoinQuantity.h"

@interface HomeViewModel()
@property(nonatomic,strong)NSMutableArray *coinPairAry;
@property(nonatomic,strong)NSMutableArray *kLineBarAry;
@property(nonatomic,strong)NSMutableArray *homeDataAry;

@property(nonatomic,strong)NSMutableArray *userCoinQuantityAry;

@property(nonatomic,strong)NSMutableArray *kLineInfoAry;

@property(nonatomic,strong)NSDictionary *drawKLineInfo;

@property(nonatomic,strong)NSMutableArray *externalMarketAry;

@property(nonatomic,assign)NSInteger limit;

@end

@implementation HomeViewModel

+ (instancetype)sharedInstance{
    
    static HomeViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HomeViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)getHomeInfo:(NSInteger)limit{
    NSLog(@"%ld",(long)limit);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRHomePageClient alloc]getHomePageInfoSuccess:^(id response) {
            NSDictionary *dic = response;
            [self.coinPairAry removeAllObjects];
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                for (NSDictionary *coInfo in [dic objectForKey:@"coinPairList"]) {
                    CoinPairModel *coModel = [CoinPairModel coinPairWithDict:coInfo];
                    [self.coinPairAry addObject:coModel];
                }
                
                //存起来 Trade的时候用
                NSData *coinPairData = [NSKeyedArchiver archivedDataWithRootObject:self.coinPairAry];
                [[NSUserDefaults standardUserDefaults] setObject:coinPairData forKey:COINPAIRMODEL];
//                {
//                    fwcJoinFlag = 0;
//                    hasGoogleAuth = 0;
//                    hasTradePassword = 1;
//                    inviteCode = Gaka63XFqX;
//                    mobileNo = 13918371413;
//                    success = 0;
//                    totalBalanceETH = "16.60810551";
//                    userId = KID2018071014254112526883540120;
//                };
                self.externalMarketAry = [dic objectForKey:@"priceInfo"];
                
                NSDictionary *userInfo = [dic objectForKey:@"userInfo"];
                
                if (!userInfo) {
                    
                }
                
                NSString *result = @"0";
                NSString *myAsset = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"totalBalanceETH"]];
                NSString *multiple = [self getMultipleWithCurrentCoinId:@"ETH"];
                result = [self decimalMultiply:myAsset with:multiple];
                NSDictionary *myAssetDic = @{@"myAsset":myAsset,@"result":result,@"multiple":multiple};
                
                [[NSUserDefaults standardUserDefaults]setObject:myAssetDic forKey:MYETH];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:MYETH object:nil];
                    
                });
               
                [self getKlineList:limit];
            } else {
                NSError *error = [NSError errorWithDomain:@"getHomePageInfo" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate getDataFalid:error];
                });
            }
            
            NSLog(@"response:%@",response);
            
        } failure:^(NSError *error) {
            //失敗
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
            });
        }];
        
    });
}

//- (void)getCoinPair{
//    [[MRHomePageClient alloc]getCoinPairInfo:@"" withPage:1 success:^(id response) {
//        NSDictionary *dic = response;
//
//        if ([[dic objectForKey:@"success"] integerValue] == 1) {
//            [self.coinPairAry removeAllObjects];
//            for (NSDictionary *coInfo in [dic objectForKey:@"resultList"]) {
//                [self.coinPairAry addObject:coInfo];
//            }
//            [self getKlineLastBar];
//        } else {
//            NSError *error = [NSError errorWithDomain:@"getCoinPairInfo" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate getDataFalid:error];
//            });
//        }
//
//        NSLog(@"response:%@",response);
//
//    } failure:^(NSError *error) {
//        //失敗
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.delegate getDataFalid:error];
//        });
//    }];
//}

//- (void)getKlineLastBar{
//
//    [[MRHomePageClient alloc]getKlineLastBar:@"5" success:^(id response) {
//        NSDictionary *dic = response;
//
//        if ([[dic objectForKey:@"success"] integerValue] == 1) {
//            [self.kLineBarAry removeAllObjects];
//            for (NSDictionary *kBarInfo in [dic objectForKey:@"resultList"]) {
//                [self.kLineBarAry addObject:kBarInfo];
//            }
//            [self combinData];
//        } else {
//            NSError *error = [NSError errorWithDomain:@"getKlineLastBar" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate getDataFalid:error];
//            });
//        }
//
//        NSLog(@"response:%@",response);
//
//    } failure:^(NSError *error) {
//        //失敗
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.delegate getDataFalid:error];
//        });
//    }];
//}

- (void)getKlineList:(NSInteger)limit{
    [[MRHomePageClient alloc]getKlienList:@"" withKLineType:@"1" withLimit:limit withBeginBarTimeLong:@"" success:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self addLatestKLineInfofrom:[dic objectForKey:@"klineBarListMap"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.delegate getDataSucess];
            });
//            [self getExternalMarket];
        } else {
            NSError *error = [NSError errorWithDomain:@"getKlineLastBar" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
            });
        }
        
//        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate getDataFalid:error];
        });
    }];
}

//- (void)getExternalMarket{
//    [[MRHomePageClient alloc]getExternalMarketSuccess:^(id response) {
//        NSDictionary *dic = response;
//        if ([[dic objectForKey:@"success"] integerValue] == 1) {
//            self.externalMarketAry = [dic objectForKey:@"resultList"];
//
//            [self getUserInfo];
//
//        } else {
//            NSError *error = [NSError errorWithDomain:@"getExternalMarket" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate getDataFalid:error];
//            });
//        }
//
//
//        NSLog(@"response:%@",response);
//
//    } failure:^(NSError *error) {
//        //失敗
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.delegate getDataFalid:error];
//        });
//    }];
//}

//- (void)getUserInfo{
//    [[MRUserInfoClient alloc]queryUserInfoSuccess:^(id response) {
//        NSDictionary *dic = response;
//        if ([[dic objectForKey:@"success"] integerValue] == 1) {
////            [self.userCoinQuantityAry removeAllObjects];
////            for (NSDictionary *info in [dic objectForKey:@"resultList"]) {
////                UserCoinQuantity *ucq = [UserCoinQuantity userCoinQuantityWithDict:info];
////                [self.userCoinQuantityAry addObject:ucq];
////            }
//            NSString *result = @"0";
//            NSString *myAsset = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalBalanceETH"]];
//            NSString *multiple = [self getMultipleWithCurrentCoinId:@"ETH"];
//            result = [self decimalMultiply:myAsset with:multiple];
////            for (UserCoinQuantity *ucq in self.userCoinQuantityAry) {
////
////                if ([ucq.coinId isEqualToString:@"ETH"]) {
////
////                    myAsset = [NSString stringWithFormat:@"%.8f",ucq.coinQuantity];
////                    result = [self decimalMultiply:myAsset with:multiple];
////                }
////            }
//            NSDictionary *dic = @{@"myAsset":myAsset,@"result":result};
//
//            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:MYETH];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter]postNotificationName:MYETH object:dic];
//                [self.delegate getDataSucess];
//            });
//
//        } else {
//            NSError *error = [NSError errorWithDomain:@"getUserInfo" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate getDataFalid:error];
//            });
//        }
//
//        NSLog(@"response:%@",response);
//
//    } failure:^(NSError *error) {
//        //失敗
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.delegate getDataFalid:error];
//        });
//    }];
//}

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

- (void)addLatestKLineInfofrom:(NSDictionary*)newDic{
    
    if (self.drawKLineInfo.count == 0) {
        self.drawKLineInfo = newDic;
    } else {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        [self.drawKLineInfo enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
            
            NSMutableArray *ary = [[NSMutableArray alloc]initWithArray:[self.drawKLineInfo objectForKey:key]];
            
            NSArray *newAry = [newDic objectForKey:key];
            if (newAry.count > 0) {
                [ary addObjectsFromArray:newAry];
                if (ary.count > 100) {
                    [ary removeObjectsInRange:NSMakeRange(0,ary.count - 100)];
                }
            }

            [resultDic setObject:ary forKey:key];
        }];
        
        self.drawKLineInfo = resultDic;
    }
}

//- (void)combinData{
//    [self.homeDataAry removeAllObjects];
//    for (NSDictionary *dic in self.coinPairAry) {
//        NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
//        for (NSDictionary *barDic in self.kLineBarAry) {
//            NSString *coinId1 = [finalDic objectForKey:@"coinPairId"];
//            NSString *coinId2 = [barDic objectForKey:@"coinPairId"];
//            if ([coinId1 isEqualToString:coinId2]) {
//                [finalDic addEntriesFromDictionary:barDic];
//            }
//        }
//        CoinPairModel *coModel = [CoinPairModel coinPairWithDict:finalDic];
//        [self.homeDataAry addObject:coModel];
//    }
//
//    //存起来 Trade的时候用
//    NSData *coinPairData = [NSKeyedArchiver archivedDataWithRootObject:self.homeDataAry];
//    [[NSUserDefaults standardUserDefaults] setObject:coinPairData forKey:COINPAIRMODEL];
//
////    [self getKlineList];
//}

- (NSArray*)getDrawKLineInfoArray:(NSString*)coinPairId{
    NSMutableArray *resultAry = [NSMutableArray array];
    NSArray *ary = [_drawKLineInfo objectForKey:coinPairId];
    
    for (NSDictionary *dic in ary) {
        CoinPairModel *coModel = [CoinPairModel coinPairWithDict:dic];
//        NSLog(@"%f",coModel.endPrice);
        [resultAry addObject:coModel];
    }
    return resultAry;
}

- (NSArray*)getExternalMarketInfo{

    return self.externalMarketAry;
}

- (NSDictionary*)getExternalMarketInfoWithCoinId:(NSString*)coinId;{
    NSDictionary *resultDic = [NSDictionary dictionary];
    for (NSDictionary *dic in self.externalMarketAry) {
        if ([[dic objectForKey:@"coinId"]isEqualToString:coinId]) {
            resultDic = dic;
        }
    }
    return resultDic;
}

- (NSString*)getMultipleWithCurrentCoinId:(NSString*)coinId{
    NSString *resultStr = @"0";
    NSString *currencyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    for (NSDictionary *dic in self.externalMarketAry) {
        if ([[dic objectForKey:@"coinId"]isEqualToString:coinId]) {
            resultStr = [NSString stringWithFormat:@"%@",[dic objectForKey:currencyStr]];
        }
    }
    return resultStr;
}

- (NSInteger)numberOfRowsInSection{
    return self.coinPairAry.count;
}

- (NSArray*)getHomeDataArray{
    return _coinPairAry;
}

- (NSMutableArray*)homeDataAry{
    if (_homeDataAry == nil) {
        _homeDataAry = [NSMutableArray array];
    }
    
    return _homeDataAry;
}

- (NSMutableArray*)coinPairAry{
    if (_coinPairAry == nil) {
        _coinPairAry = [NSMutableArray array];
    }
    
    return _coinPairAry;
}

- (NSMutableArray*)kLineBarAry{
    if (_kLineBarAry == nil) {
        _kLineBarAry = [NSMutableArray array];
    }
    
    return _kLineBarAry;
}

- (NSMutableArray*)externalMarketAry{
    if (_externalMarketAry == nil) {
        _externalMarketAry = [NSMutableArray array];
    }
    
    return _externalMarketAry;
}

- (NSMutableArray*)userCoinQuantityAry{
    if (_userCoinQuantityAry == nil) {
        _userCoinQuantityAry = [NSMutableArray array];
    }
    return _userCoinQuantityAry;
}

@end
