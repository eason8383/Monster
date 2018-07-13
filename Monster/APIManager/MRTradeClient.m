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

@end
