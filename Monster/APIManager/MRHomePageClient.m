//
//  MRHomePageClient.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/10.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRHomePageClient.h"

@implementation MRHomePageClient

- (void)getCoinPairInfo:(NSString*)coinPairId withPage:(NSInteger)page success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"coinPairId":coinPairId,
                                 @"pairStatus":@"1",
                                 @"pageNo":[NSNumber numberWithInteger:page],
                                 @"itemPerPage":@10
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYCOINPAIR action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get model data error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)getKlineLastBar:(NSString*)klineType success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"klineType":klineType
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYKLINELASTBAR action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get model data error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)getKlienList:(NSString*)coinPairId withKLineType:(NSString*)type withLimit:(NSInteger)limit withBeginBarTimeLong:(NSString*)beginBarTimeLong success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"klineType":type,
                                 @"coinPairId":coinPairId,
                                 @"limit":[NSNumber numberWithInteger:limit],
                                 @"beginBarTimeLong":beginBarTimeLong
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYKLINELIST action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get model data error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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
