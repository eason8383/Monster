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

@interface HomeViewModel()
@property(nonatomic,strong)NSMutableArray *coinPairAry;
@property(nonatomic,strong)NSMutableArray *kLineBarAry;
@property(nonatomic,strong)NSMutableArray *homeDataAry;

@property(nonatomic,strong)NSMutableArray *kLineInfoAry;

@property(nonatomic,strong)NSDictionary *drawKLineInfo;

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

- (void)getData{
    
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
    [[MRHomePageClient alloc]getKlienList:@"" withKLineType:@"1" withLimit:100 withBeginBarTimeLong:@"" success:^(id response) {
        NSDictionary *dic = response;
//        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                self.drawKLineInfo = [dic objectForKey:@"klineBarListMap"];
            } else {
                
                
            }
//        });
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)combinData{
    
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
    [self getKlineList];
}

- (NSArray*)getDrawKLineInfoArray:(NSString*)coinPairId{
    NSMutableArray *resultAry = [NSMutableArray array];
    NSArray *ary = [_drawKLineInfo objectForKey:@"coinPairId"];
    
    for (NSDictionary *dic in ary) {
        CoinPairModel *coModel = [CoinPairModel coinPairWithDict:dic];
        [resultAry addObject:coModel];
    }
    return resultAry;
}

- (NSInteger)numberOfRowsInSection{
    return self.coinPairAry.count;
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

@end
