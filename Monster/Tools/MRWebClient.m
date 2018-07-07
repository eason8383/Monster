//
//  MRWebClient.m
//  Monster
//
//  Created by eason's macbook on 2018/7/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRWebClient.h"
#import "AppDelegate.h"
#import "MRUserAccount.h"

@interface MRWebClient()

@property (nonatomic,strong)NSMutableURLRequest *request;

@end

@implementation MRWebClient

static NSString *sessionId;

+ (instancetype)sharedInstance{
    
    static MRWebClient *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MRWebClient alloc]init];
        
    });
    
    return instance;
}


- (NSString*)userToken{
    
    return nil;
}


- (void)getVerifyCode:(NSString*)mobileNo success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    NSDictionary *parameters = @{
                            @"version":@"1.0",
                            @"source":@"99",
                            @"mobileNo":mobileNo,
                            @"sceneCode":@"001"
                            };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_SMSVERIFYCODE action:CGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {

        NSDictionary *dic = [self dictionaryWithJsonString:result];

        if ([[dic objectForKey:@"ErrorCode"] intValue] != 0){
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


- (void)loginWithMobileNo:(NSString*)mobileNo verifyCode:(NSString*)verifyCode success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    
    NSDictionary *parameters = @{
                            @"version":@"1.0",
                            @"source":@"99",
                            @"mobileNo":mobileNo,
                            @"verifyCode":verifyCode
                            };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_SMSLOGIN action:CGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        
        if ([[dic objectForKey:@"ErrorCode"] intValue] != 0){
            NSError *error = [NSError errorWithDomain:@"Get model data error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
            failureBlock(error);
            
        } else {
            
            self.userAccount = [MRUserAccount accountWithDict:dic];
            self.userAccount.mobileNo = mobileNo;
            sessionId = self.userAccount.sessionId;
#pragma mark
#pragma mark - 只保存用户信息
            [self saveUserAccount:self.userAccount];
            successBlock(dic);
        }
        
    } error:^(NSError *error) {
        if (error) {
            failureBlock(error);
        }
    }];
    
}

- (void)queryCoinPairSuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    NSDictionary *parameters = @{
                                 @"version":@"1.0",
                                 @"source":@"99",
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_QUERYCOINPAIR action:TEXCHANGEQUERY parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        
        if ([[dic objectForKey:@"ErrorCode"] intValue] != 0){
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

#pragma mark
#pragma mark - 保存对象

-(void)saveUserAccount:(MRUserAccount*)userAccount{
//    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userAccount requiringSecureCoding:YES error:nil];
//    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:FilePath];
}

#pragma mark
#pragma mark - 得到对象
-(MRUserAccount*)getUserAccount{
    NSData *userData = [[NSUserDefaults standardUserDefaults]objectForKey:FilePath];
//    MRUserAccount *userAccount = [NSKeyedUnarchiver unarchivedObjectOfClass:[MRUserAccount class] fromData:userData error:nil];
    return nil;
}

#pragma mark
#pragma mark - 获取数据,所有数据的请求入口

- (void)getResponse:(NSString*)controller action:(NSString*)action parametes:(NSString*)parameters isEncrypt:(BOOL)isEncrypt complete:(loginCompleteBlock)complete error:(void(^)(NSError*error))errorBlock{
    
    //检查网路连线
    if (![self checkReachabilty]) {
        NSDictionary *dic = @{@"ErrorCode":@1,@"ErrorMsg":@"Please check Your Network"};
        NSError *error = [NSError errorWithDomain:@"Network error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
        errorBlock(error);
    }
    
    NSString *urlStr = [self getURLfromRules:action controller:controller];
    
    [self requestPrepares:controller action:action withURL:urlStr parametes:parameters isEncrypt:isEncrypt];
    
    NSURLSessionConfiguration *configuration =  [NSURLSessionConfiguration defaultSessionConfiguration];
    
    [configuration setTimeoutIntervalForRequest:30];
    [configuration setTimeoutIntervalForResource:30];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    //发起网络请求
    [[session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if (!error) {
            if ([res statusCode] == 401) {
                NSInteger code = [res statusCode];
                NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%ld", (long)code] code:401 userInfo:nil];
                errorBlock(error);
            }else {
                NSString* dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

//                if (isEncrypt) {
//                    dataStr = [AESCipher decryptAES:dataStr key:KEY iv:IV];
//                } else {
//                    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
//                }
                
                if (complete) {
                    complete(dataStr);
                }
            }
        } else {
            errorBlock(error);
        }
    }]resume];
}

- (void)requestPrepares:(NSString*)controller action:(NSString*)action withURL:(NSString*)urlStr parametes:(NSString*)parameters isEncrypt:(BOOL)isEncrypt{
    //请求url地址
    
    //设置请求
    self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    //请求格式x
    self.request.HTTPMethod = @"POST";
    [self.request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [self.request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    //目前不使用token
    //Token
    //[self checkTokenFromStorege];
    
    if (parameters != nil) {
        if (isEncrypt) {
//            parameters = [AESCipher encryptAES:parameters key:KEY iv:IV];
        }
//        NSNumber *number = [[NSNumber alloc]initWithBool:isEncrypt];
//        NSDictionary* dic = @{@"IsEncrypt":number,@"Parameters":parameters};
//        NSString* dicJson = [dic JSONString];
        
        self.request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
        [self.request setAllowsCellularAccess:YES];
    }
}

- (BOOL)checkReachabilty{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

- (NSString*)getURLfromRules:(NSString*)action controller:(NSString*)controller {
    //请求url地址
    NSString *urlStr;
    NSString *baseUrlString;
    
    baseUrlString = [[AppDelegate environment] isEqualToString:MREnvironment_TEST]?TEST_URL:PUBLIC_URL;

    urlStr = [NSString stringWithFormat:@"http://%@/%@/%@",baseUrlString,action,controller];
    
    NSLog(@"URL:%@",urlStr);
    return urlStr;
}

#pragma mark
#pragma mark - 转成字典

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                         
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
