//
//  TradeViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CoinPairModel;
@protocol TradeViewModelDelegate <NSObject>

@optional

- (void)getDataSucess;
- (void)getDataFalid:(NSError*)error;

- (void)getUserOrderSucess;

- (void)orderRequestSucess:(NSDictionary*)res;

- (void)orderCancelSucess:(NSDictionary*)res;

@end

@interface TradeViewModel : NSObject
@property(nonatomic,weak) id<TradeViewModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getData:(NSString*)coinPairId;
- (void)getUserOrder:(NSString*)coinPairId;

- (void)oderRequest:(CoinPairModel*)model coinQuantity:(NSString*)coinQuantity orderPrice:(NSString*)orderPrice buyOrSale:(BOOL)isBuy;

- (void)cancelOder:(NSString*)orderId coinPair:(NSString*)coinPairId;

- (NSArray*)getBuyAry;
- (NSArray*)getSaleAry;

- (NSArray*)getCoinPairAry;
- (NSArray*)getUserQuantityAry;
- (NSArray*)getUserOrderAry;

- (NSInteger)numberOfRowsInSection;

@end
