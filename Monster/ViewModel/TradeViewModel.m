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

#import "UCoinQuantity.h"
#import "TrandModel.h"
#import "CoinPairModel.h"

#import "UserOrderModel.h"

@interface TradeViewModel()
@property(nonatomic,strong)NSMutableArray *userQuantityAry;
@property(nonatomic,strong)NSMutableArray *userOrderAry;
@property(nonatomic,strong)NSMutableArray *saleAry;
@property(nonatomic,strong)NSMutableArray *buyAry;
@property(nonatomic,strong)NSString *local_coinPairId;

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
        self.local_coinPairId = coinPairId;
        [self getOrderDepth:coinPairId];
        
    });
}

- (void)getUserCoinQuantity{
    [[MRUserInfoClient alloc]getUserCoinQuantitySuccess:^(id response) {
        NSDictionary *dic = response;
        
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self.userQuantityAry removeAllObjects];
            for (NSDictionary *dicCoin in [dic objectForKey:@"resultList"]) {
                UCoinQuantity *coinInfo = [UCoinQuantity uCoinQuantityWithDict:dicCoin];
                [self.userQuantityAry addObject:coinInfo];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataSucess];
                //接着获取UserOrders
                [self getUserOrder:self.local_coinPairId];
            });
        } else {
            NSError *error = [NSError errorWithDomain:@"getOrderDepth" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
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
}

- (void)getOrderDepth:(NSString*)coinPairId{
    [[MRTradeClient alloc]getOrderDepth:coinPairId withPage:1 success:^(id response) {
        NSDictionary *dic = response;
        
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            NSMutableArray *tradeAry = [dic objectForKey:@"resultList"];
            [self.buyAry removeAllObjects];
            [self.saleAry removeAllObjects];
            for (NSDictionary *tInfo in tradeAry) {
                TrandModel *tModel = [TrandModel tradeModelWithDict:tInfo];
                if ([tModel.buySell isEqualToString:@"B"]) {
                    [self.buyAry addObject:tModel];
                } else {
                    [self.saleAry addObject:tModel];
                }
            }
            [self getUserCoinQuantity];
        } else {
            
            NSError *error = [NSError errorWithDomain:@"getOrderDepth" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
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

- (void)getUserOrder:(NSString*)coinPairId{
    _local_coinPairId = coinPairId;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRTradeClient alloc]getUserOrder:@"" coinPairId:coinPairId otherPara:@{} success:^(id response) {
            NSDictionary *dic = response;
            [self.userOrderAry removeAllObjects];
            NSLog(@"%@",dic);
            for (NSDictionary *dicCoin in [dic objectForKey:@"resultList"]) {
                UserOrderModel *udInfo = [UserOrderModel userOrderWithDict:dicCoin];
                [self.userOrderAry addObject:udInfo];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getUserOrderSucess];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
            });
        }];
    });
}

- (void)oderRequest:(CoinPairModel*)model coinQuantity:(float)coinQuantity orderPrice:(float)orderPrice buyOrSale:(BOOL)isBuy{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRTradeClient alloc]oderRequest:model.coinPairId withCoinId:model.mainCoinId coinQuantity:coinQuantity orderPrice:orderPrice buyOrSale:isBuy Success:^(id response) {
            NSDictionary *dic = response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate orderRequestSucess:dic];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
            });
        }];
    });
}

- (void)cancelOder:(NSString*)orderId coinPair:(NSString*)coinPairId{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRTradeClient alloc]cancelOder:orderId withCoinPair:coinPairId Success:^(id response) {
            NSDictionary *dic = response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate orderCancelSucess:dic];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
            });
        }];
    });
}

- (NSInteger)numberOfRowsInSection{
    return self.userOrderAry.count;
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

- (NSArray*)getUserOrderAry{
    return _userOrderAry;
}

- (NSMutableArray*)userQuantityAry{
    if (_userQuantityAry == nil) {
        _userQuantityAry = [NSMutableArray array];
    }
    
    return _userQuantityAry;
}

- (NSMutableArray*)userOrderAry{
    if (_userOrderAry == nil) {
        _userOrderAry = [NSMutableArray array];
    }
    
    return _userOrderAry;
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
