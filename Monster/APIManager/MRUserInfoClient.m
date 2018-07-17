//
//  MRUserInfoClient.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRUserInfoClient.h"
#import "MRWebClient.h"

@implementation MRUserInfoClient

- (void)getUserCoinQuantitySuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId,
                                 @"sessionId":self.userAccount.sessionId
                                 };
//    {
//        sessionId = SESSION2018071618493999686927460;
//        source = 03;
//        userId = KID2018071014254112526883540120;
//        version = "1.0";
//    }
//    NSDictionary *parameters = @{
//                                 @"source":@"03",
//                                 @"version":@"1.0",
//                                 @"userId":@"KID2018071014254112526883540120",
//                                 @"sessionId":@"SESSION2018071216212075219922130"
//                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYUSERCOINQUANTITY action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get UserCoinQuantity error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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
