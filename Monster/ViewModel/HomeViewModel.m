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

- (void)getData:(NSInteger)limit{
    _limit = limit;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCoinPair];
        
    });
}

- (void)getCoinPair{
    [[MRHomePageClient alloc]getCoinPairInfo:@"" withPage:1 success:^(id response) {
        NSDictionary *dic = response;
        
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self.coinPairAry removeAllObjects];
            for (NSDictionary *coInfo in [dic objectForKey:@"resultList"]) {
                [self.coinPairAry addObject:coInfo];
            }
            [self getKlineLastBar];
        } else {
            
        }
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)getKlineLastBar{
    
    [[MRHomePageClient alloc]getKlineLastBar:@"1" success:^(id response) {
        NSDictionary *dic = response;
        
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self.kLineBarAry removeAllObjects];
            for (NSDictionary *kBarInfo in [dic objectForKey:@"resultList"]) {
                [self.kLineBarAry addObject:kBarInfo];
            }
            [self combinData];
        } else {
            
        }
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)getKlineList{
    [[MRHomePageClient alloc]getKlienList:@"" withKLineType:@"1" withLimit:_limit withBeginBarTimeLong:@"" success:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self addLatestKLineInfofrom:[dic objectForKey:@"klineBarListMap"]];
        } else {
            
        }
        [self getExternalMarket];
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)getExternalMarket{
    [[MRHomePageClient alloc]getExternalMarketSuccess:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            self.externalMarketAry = [dic objectForKey:@"resultList"];
        } else {
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getUserInfo];
        });
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)getUserInfo{
    [[MRUserInfoClient alloc]getUserCoinQuantitySuccess:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self.userCoinQuantityAry removeAllObjects];
            for (NSDictionary *info in [dic objectForKey:@"resultList"]) {
                UserCoinQuantity *ucq = [UserCoinQuantity userCoinQuantityWithDict:info];
                [self.userCoinQuantityAry addObject:ucq];
            }
            float result = 0;
            double myAsset = 0;
            for (UserCoinQuantity *ucq in self.userCoinQuantityAry) {
                
                if ([ucq.coinId isEqualToString:@"ETH"]) {
                    float multiple = [self getMultipleWithCurrentCoinId:@"ETH"];
                    myAsset = ucq.coinQuantity;
                    result = myAsset * multiple;
                }
            }
            NSDictionary *dic = @{@"myAsset":[NSNumber numberWithDouble:myAsset],@"result":[NSNumber numberWithFloat:result]};
            
            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:MYETH];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:MYETH object:dic];
                [self.delegate getDataSucess];
            });
            
        } else {
            
        }
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
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

- (void)combinData{
    [self.homeDataAry removeAllObjects];
    for (NSDictionary *dic in self.coinPairAry) {
        NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        for (NSDictionary *barDic in self.kLineBarAry) {
            NSString *coinId1 = [finalDic objectForKey:@"coinPairId"];
            NSString *coinId2 = [barDic objectForKey:@"coinPairId"];
            if ([coinId1 isEqualToString:coinId2]) {
                [finalDic addEntriesFromDictionary:barDic];
            }
        }
        CoinPairModel *coModel = [CoinPairModel coinPairWithDict:finalDic];
        [self.homeDataAry addObject:coModel];
    }
    
    //存起来 Trade的时候用
    NSData *coinPairData = [NSKeyedArchiver archivedDataWithRootObject:self.homeDataAry];
    [[NSUserDefaults standardUserDefaults] setObject:coinPairData forKey:COINPAIRMODEL];
    
    [self getKlineList];
}

- (NSArray*)getDrawKLineInfoArray:(NSString*)coinPairId{
    NSMutableArray *resultAry = [NSMutableArray array];
    NSArray *ary = [_drawKLineInfo objectForKey:coinPairId];
    
    for (NSDictionary *dic in ary) {
        CoinPairModel *coModel = [CoinPairModel coinPairWithDict:dic];
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

- (float)getMultipleWithCurrentCoinId:(NSString*)coinId{
    float result = 0;
    NSString *currencyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    for (NSDictionary *dic in self.externalMarketAry) {
        if ([[dic objectForKey:@"coinId"]isEqualToString:coinId]) {
            result = [[dic objectForKey:currencyStr] floatValue];
        }
    }
    return result;
}

- (NSInteger)numberOfRowsInSection{
    return self.coinPairAry.count;
}

- (NSArray*)getHomeDataArray{
    return _homeDataAry;
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
