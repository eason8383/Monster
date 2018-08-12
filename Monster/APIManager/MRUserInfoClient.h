//
//  MRUserInfoClient.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRWebClient.h"

@interface MRUserInfoClient : MRWebClient

- (void)getUserCoinQuantitySuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)getUserCoinInOutInfo:(NSString*)inOrOut Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)updatePsw:(NSString*)newPsw verifyCode:(NSString*)verifyCode Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)updateFundPsw:(NSString*)newPsw verifyCode:(NSString*)verifyCode Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)saveUserIdentity:(NSString*)frontId backId:(NSString*)backId withId:(NSString*)withId withIdNo:(NSString*)idNo Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)saveEmailIdentity:(NSString*)emailAdds verifyCode:(NSString*)verifyCode Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)queryUserCoinWalletSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)monitorCoinRecharge:(NSString*)walletId coinId:(NSString*)coinId Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)withdrawApply:(NSDictionary*)parameters Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)queryUserInfoSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)userFeedback:(NSString*)content uploadPic:(NSString*)path Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

@end
