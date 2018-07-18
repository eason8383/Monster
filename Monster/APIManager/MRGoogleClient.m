//
//  MRGoogleClient.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/17.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRGoogleClient.h"

@implementation MRGoogleClient

- (void)getBindingCodeSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId,
                                 @"sessionId":self.userAccount.sessionId,
                                 };
//    {
//        sessionId = SESSION2018071618493999686927460;
//        source = 03;
//        userId = KID2018071014254112526883540120;
//        version = "1.0";
//    }
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:GOOGLEAUTHGEN action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get BindingCode error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)getSmsVerifyCodeBUIdSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId,
                                 @"sessionId":self.userAccount.sessionId,
                                 @"sceneCode":@"006"
                                 };
//        {
//            sessionId = SESSION2018071618493999686927460;
//            source = 03;
//            userId = KID2018071014254112526883540120;
//            version = "1.0";
//        }
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:GOOGLESMSVERIFY action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Get SmsVerifyCode error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)authBinding:(NSString*)authCode verifyCode:(NSString*)verifyCode Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId,
                                 @"sessionId":self.userAccount.sessionId,
                                 @"authCode":authCode,
                                 @"verifyCode":verifyCode
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:GOOGLEAUTHBIND action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Auth Binding error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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

- (void)authMyIdentity:(NSString*)authCode Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId,
                                 @"sessionId":self.userAccount.sessionId,
                                 @"authCode":authCode,
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:GOOGLEAUTHCHECK action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        NSDictionary *resdic = [dic objectForKey:@"respCode"];
        if (![[resdic objectForKey:@"code"] isEqualToString:@"00000"]) {
            NSError *error = [NSError errorWithDomain:@"Auth MyIdentity error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
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
