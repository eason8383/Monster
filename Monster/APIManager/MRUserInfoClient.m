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

- (void)getUserCoinInOutInfo:(NSString*)inOrOut Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId,
                                 @"sessionId":self.userAccount.sessionId,
                                 @"inOut":inOrOut,
                                 @"lastInOutId":@""
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYUSERCOININOUTINFO action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get UserCoinInOutInfo error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)updateUserPsw:(NSString*)newPsw verifyCode:(NSString*)verifyCode Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"mobileNo":self.userAccount.mobileNo,
                                 @"sessionId":self.userAccount.sessionId,
                                 @"userId":self.userAccount.userId,
                                 @"verifyCode":verifyCode,
                                 @"newPassword":newPsw,
                                 @"passwordType":@"T"
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_RESETUSERPASSWORD action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"reset user psw error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)saveUserIdentity:(NSString*)frontId backId:(NSString*)backId withId:(NSString*)withId Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"sessionId":self.userAccount.sessionId,
                                 @"userId":self.userAccount.userId,
                                 @"frontIdCard":frontId,
                                 @"backIdCard":backId,
                                 @"userWithIdCard":withId,
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_SAVEIDIDENTITY action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"saveUserIdentity error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)saveEmailIdentity:(NSString*)emailAdds verifyCode:(NSString*)verifyCode Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"sessionId":self.userAccount.sessionId,
                                 @"userId":self.userAccount.userId,
                                 @"userEmail":emailAdds,
                                 @"verifyCode":verifyCode
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_SAVEIDIDENTITY action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"saveUserIdentity error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)queryUserCoinWalletSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"sessionId":self.userAccount.sessionId,
                                 @"userId":self.userAccount.userId,
                                 @"blockChainType":@"1"
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYUSERCOINWALLET action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"user Coin Wallet error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)monitorCoinRecharge:(NSString*)walletId coinId:(NSString*)coinId Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"sessionId":self.userAccount.sessionId,
                                 @"userId":self.userAccount.userId,
                                 @"coinId":coinId,
                                 @"walletId":walletId
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_MONITORCOINRECHARGE action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"monitor coin recharge error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)withdrawApply:(NSDictionary*)parameters Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSMutableDictionary *parames =
    [[NSMutableDictionary alloc]initWithDictionary:@{
                                                     @"source":@"03",
                                                     @"version":@"1.0",
                                                     @"sessionId":self.userAccount.sessionId,
                                                     @"userId":self.userAccount.userId,
                                                     @"mobileNo":self.userAccount.mobileNo
                                                    }];
    [parames addEntriesFromDictionary:parameters];
    
    NSString *jsonParameter = [parames JSONString];
    
    [self getResponse:MR_WITHDREWAPPLY action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"withdraw Apply error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)queryUserInfoSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parames = @{
                             @"source":@"03",
                             @"version":@"1.0",
                             @"sessionId":self.userAccount.sessionId,
                             @"userId":self.userAccount.userId,
                             };
    
    NSString *jsonParameter = [parames JSONString];
    
    [self getResponse:MR_QUERYUSERINFO action:ERQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"queryUserInfo error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
            failureBlock(error);
            
        } else {
            
            self.userAccount.frontIdCard = [dic objectForKey:@"frontIdCard"]?[dic objectForKey:@"frontIdCard"]:@"";
            self.userAccount.backIdCard = [dic objectForKey:@"backIdCard"]?[dic objectForKey:@"backIdCard"]:@"";
            self.userAccount.userWithIdCard = [dic objectForKey:@"userWithIdCard"]?[dic objectForKey:@"userWithIdCard"]:@"";
            self.userAccount.idCardAuditStatus = [dic objectForKey:@"idCardAuditStatus"]?[dic objectForKey:@"idCardAuditStatus"]:@"";
            [self saveUserAccount:self.userAccount];
            successBlock(dic);
        }
        
    } error:^(NSError *error) {
        if (error) {
            failureBlock(error);
        }
    }];
}

- (void)userFeedback:(NSString*)content uploadPic:(NSString*)path Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parames = @{
                              @"source":@"03",
                              @"version":@"1.0",
                              @"sessionId":self.userAccount.sessionId,
                              @"userId":self.userAccount.userId,
                              @"feedbackContent":content,
                              @"uploadPicList":path
                              };
    
    NSString *jsonParameter = [parames JSONString];
    
    [self getResponse:MR_SUBMITUSERFEEDBACK action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"userFeedback error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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
