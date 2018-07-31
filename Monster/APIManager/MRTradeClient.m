//
//  MRTradeClient.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRTradeClient.h"

@implementation MRTradeClient

- (void)getOrderDepth:(NSString*)coinPairId withPage:(NSInteger)page success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"coinPairId":coinPairId,
                                 @"pageNo":[NSNumber numberWithInteger:page],
                                 @"itemPerPage":@5
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYORDERDEPTH action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get OrderDepth error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
            failureBlock(error);
            
        } else {
            successBlock(dic);
        }
        
    } error:^(NSError *error) {
        if (error) {
            failureBlock(error);
        }
    }];
}

- (void)getUserOrder:(NSString*)orderId coinPairId:(NSString*)coinPairId otherPara:(NSDictionary*)op success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    NSDictionary *parameter = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId?self.userAccount.userId:@"",
                                 @"sessionId":self.userAccount.sessionId?self.userAccount.sessionId:@"",
                                 @"orderId":orderId,
                                 @"coinPairId":coinPairId,
                                 @"orderStatus":@"1"
                                 };
//    orderId：选输，订单Id
//    coinPairId：选输，代币对Id
//    buySell：选输，买卖方向 (先不傳)
//    orderStatus：选输，订单状态 可翻页 “1”
    
    [paramaters addEntriesFromDictionary:parameter];
    if ([op count] > 0) {
        [paramaters addEntriesFromDictionary:op];
    }
    NSString *jsonParameter = [paramaters JSONString];
    
    [self getResponse:MR_QUERYUSERORDER action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get getUserOrder error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
            failureBlock(error);
            
        } else {
            successBlock(dic);
        }
        
    } error:^(NSError *error) {
        if (error) {
            failureBlock(error);
        }
    }];
}



- (void)oderRequest:(NSString*)coinPairId withCoinId:(NSString*)coinId coinQuantity:(NSString*)coinQuantity orderPrice:(NSString*)orderPrice buyOrSale:(BOOL)isBuy Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    NSDictionary *parameters = @{
                                        @"source":@"03",
                                        @"version":@"1.0",
                                        @"userId":self.userAccount.userId?self.userAccount.userId:@"",
                                        @"sessionId":self.userAccount.sessionId?self.userAccount.sessionId:@"",
                                        @"coinPairId":coinPairId,
                                        @"buySell":isBuy?@"B":@"S",
                                        @"coinId":coinId,
                                        @"coinQuantity":coinQuantity,
                                        @"orderPrice":orderPrice
                                        };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_ORDERREQUEST action:ERORDER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get oderRequest error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
            failureBlock(error);
            
        } else {
            successBlock(dic);
        }
        
    } error:^(NSError *error) {
        if (error) {
            failureBlock(error);
        }
    }];
}

- (void)cancelOder:(NSString*)orderId withCoinPair:(NSString*)coinPairId Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"coinPairId":coinPairId,
                                 @"orderId":orderId,
                                 @"userId":self.userAccount.userId?self.userAccount.userId:@"",
                                 @"sessionId":self.userAccount.sessionId?self.userAccount.sessionId:@""
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_ORDERCANCEL action:ERORDER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"cancelOder error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
            failureBlock(error);
            
        } else {
            successBlock(dic);
        }
        
    } error:^(NSError *error) {
        if (error) {
            failureBlock(error);
        }
    }];
}

@end
