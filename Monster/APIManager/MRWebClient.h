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

//md5加密
- (NSString *)md5:(NSString *)input;

//异步请求
- (void)getResponse:(NSString*)controller action:(NSString*)action parametes:(NSString*)parameters isEncrypt:(BOOL)isEncrypt complete:(loginCompleteBlock)complete error:(void(^)(NSError*error))errorBlock;

//- (void)upload:(NSString*)controller action:(NSString*)action parametes:(NSString*)parametes withData:(NSData*)data complete:(loginCompleteBlock)complete error:(void(^)(NSError*error))errorBlock;

- (void)upload:(NSString*)controller action:(NSString*)action parametes:(NSString*)parametes withPath:(NSURL*)path complete:(loginCompleteBlock)complete error:(void(^)(NSError*error))errorBlock;

- (void)getVerifyCode:(NSString*)mobileNo sceneCode:(NSString*)sceneCode success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;


//使用验证码登入
- (void)loginWithMobileNo:(NSString*)mobileNo verifyCode:(NSString*)verifyCode success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;
//使用密码登入
- (void)loginWithMobileNo:(NSString*)mobileNo password:(NSString*)password success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)upLoadImageData:(NSData*)data success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)upLoadImagePath:(NSURL*)path success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

@end

