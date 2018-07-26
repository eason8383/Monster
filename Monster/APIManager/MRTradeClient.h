//
//  MRTradeClient.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRWebClient.h"

@interface MRTradeClient : MRWebClient

- (void)getOrderDepth:(NSString*)coinPairId withPage:(NSInteger)page success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)getUserOrder:(NSString*)orderId coinPairId:(NSString*)coinPairId otherPara:(NSDictionary*)op success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)oderRequest:(NSString*)coinPairId withCoinId:(NSString*)coinId coinQuantity:(float)coinQuantity orderPrice:(float)orderPrice buyOrSale:(BOOL)isBuy Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)cancelOder:(NSString*)orderId withCoinPair:(NSString*)coinPairId Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

@end
