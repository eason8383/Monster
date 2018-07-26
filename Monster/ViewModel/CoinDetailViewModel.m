//
//  CoinDetailViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/11.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinDetailViewModel.h"
#import "MRHomePageClient.h"
#import "CoinPairModel.h"


@interface CoinDetailViewModel()
@property(nonatomic,strong)NSMutableArray *klineListAry;
@property(nonatomic,strong)NSDictionary *drawKLineInfo;

@end

@implementation CoinDetailViewModel

+ (instancetype)sharedInstance{
    
    static CoinDetailViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoinDetailViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)getKlineList:(NSString*)klineType withLimit:(NSInteger)limit{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MRHomePageClient alloc]getKlienList:@"" withKLineType:@"1" withLimit:limit withBeginBarTimeLong:@"" success:^(id response) {
            NSDictionary *dic = response;
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                self.drawKLineInfo = [dic objectForKey:@"klineBarListMap"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate getDataSucess];
                });
            } else {
                NSError *error = [NSError errorWithDomain:@"getKlineLastBar" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
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

- (NSArray*)getDrawKLineInfoArray:(NSString*)coinPairId{
    NSMutableArray *resultAry = [NSMutableArray array];
    NSArray *ary = [_drawKLineInfo objectForKey:coinPairId];
    
    for (NSDictionary *dic in ary) {
        CoinPairModel *coModel = [CoinPairModel coinPairWithDict:dic];
        [resultAry addObject:coModel];
    }
    return resultAry;
}

- (NSMutableArray*)klineListAry{
    if (_klineListAry == nil) {
        _klineListAry = [NSMutableArray array];
    }
    return _klineListAry;
}

@end
