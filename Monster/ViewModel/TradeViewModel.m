//
//  TradeViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "TradeViewModel.h"
#import "MRTradeClient.h"
#import "MRUserInfoClient.h"

#import "TrandModel.h"

@interface TradeViewModel()
@property(nonatomic,strong)NSMutableArray *userQuantityAry;
@property(nonatomic,strong)NSMutableArray *saleAry;
@property(nonatomic,strong)NSMutableArray *buyAry;
@end

@implementation TradeViewModel


+ (instancetype)sharedInstance{
    
    static TradeViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TradeViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)getData:(NSString*)coinPairId{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getUserCoinQuantity];
        
    });
}

- (void)getUserCoinQuantity{
    [[MRUserInfoClient alloc]getUserCoinQuantitySuccess:^(id response) {
        NSDictionary *dic = response;
        
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            self.userQuantityAry = [dic objectForKey:@"resultList"];
        } else {
            
        }
        [self getOrderDepth];
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)getOrderDepth{
    [[MRTradeClient alloc]getOrderDepth:@"" withPage:1 success:^(id response) {
        NSDictionary *dic = response;
        
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            NSMutableArray *tradeAry = [dic objectForKey:@"resultList"];
            for (NSDictionary *tInfo in tradeAry) {
                TrandModel *tModel = [TrandModel tradeModelWithDict:tInfo];
                if ([tModel.buySell isEqualToString:@"B"]) {
                    [self.buyAry addObject:tModel];
                } else {
                    [self.saleAry addObject:tModel];
                }
            }
        } else {
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate getDataSucess];
        });
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (NSArray*)getBuyAry{
    return _buyAry;
}

- (NSArray*)getSaleAry{
    return _saleAry;
}

- (NSArray*)getUserQuantityAry{
    return _userQuantityAry;
}

- (NSMutableArray*)userQuantityAry{
    if (_userQuantityAry == nil) {
        _userQuantityAry = [NSMutableArray array];
    }
    
    return _userQuantityAry;
}

- (NSMutableArray*)saleAry{
    if (_saleAry == nil) {
        _saleAry = [NSMutableArray array];
    }
    
    return _saleAry;
}

- (NSMutableArray*)buyAry{
    if (_buyAry == nil) {
        _buyAry = [NSMutableArray array];
    }
    
    return _buyAry;
}

@end
