//
//  MRMyOrderClient.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/14.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRMyOrderClient.h"

@implementation MRMyOrderClient

- (void)getMyOrderSuccess:(NSInteger)page sucess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];

    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId?self.userAccount.userId:@"",
                                 @"sessionId":self.userAccount.sessionId?self.userAccount.sessionId:@"",
                                 @"orderStatus":@"1",
                                 @"pageNo":[NSNumber numberWithInteger:page]
                                 };

    NSString *jsonParameter = [parameters JSONString];

    [self getResponse:MR_QUERYUSERORDERDEAL action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get MyOrder error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)getOrderHistoryWithPage:(NSInteger)page Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId?self.userAccount.userId:@"",
                                 @"sessionId":self.userAccount.sessionId?self.userAccount.sessionId:@"",
                                 @"orderStatus":@"",
                                 @"pageNo":[NSNumber numberWithInteger:page]
                                 
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYUSERORDERDEAL action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get MyOrder error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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
