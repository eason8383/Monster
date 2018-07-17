//
//  MRGoogleClient.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/17.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRWebClient.h"

@interface MRGoogleClient : MRWebClient

- (void)getBindingCodeSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)getSmsVerifyCodeBUIdSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)authMyIdentity:(NSString*)authCode verifyCode:(NSString*)verifyCode Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

@end
