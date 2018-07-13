//
//  MRWebClient.h
//  Monster
//
//  Created by eason's macbook on 2018/7/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MRUserAccount;

typedef void(^loginCompleteBlock)(NSString*result);

@interface MRWebClient : NSObject

@property (nonatomic,strong)MRUserAccount *userAccount;

+ (instancetype)sharedInstance;

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

- (void)saveUserAccount:(MRUserAccount*)userAccount;
//获取到useraccount
- (MRUserAccount*)getUserAccount;

//异步请求
- (void)getResponse:(NSString*)controller action:(NSString*)action parametes:(NSString*)parameters isEncrypt:(BOOL)isEncrypt complete:(loginCompleteBlock)complete error:(void(^)(NSError*error))errorBlock;


- (void)getVerifyCode:(NSString*)mobileNo success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;


- (void)loginWithMobileNo:(NSString*)mobileNo verifyCode:(NSString*)verifyCode success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;


@end

