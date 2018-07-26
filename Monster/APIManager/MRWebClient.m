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


- (void)getVerifyCode:(NSString*)mobileNo sceneCode:(NSString*)sceneCode success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    NSDictionary *parameters = @{
                            @"mobileNoOrEmail":mobileNo,
                            @"sceneCode":sceneCode,
                            @"source":@"03",
                            @"version":@"1.0"
                            };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self getResponse:MR_SMSVERIFYCODE action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {

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
    
    [self getResponse:MR_SMSLOGIN action:EGUSER parametes:jsonParameter isEncrypt:NO complete:^(NSString *result) {
        
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        
        if ([[dic objectForKey:@"ErrorCode"] intValue] != 0){
            NSError *error = [NSError errorWithDomain:@"Get model data error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            
            failureBlock(error);
            
        } else {
            
            self.userAccount = [MRUserAccount accountWithDict:dic];
            self.userAccount.mobileNo = mobileNo;
            sessionId = self.userAccount.sessionId;
            
            //save for auto login
            [[NSUserDefaults standardUserDefaults]setObject:sessionId forKey:@"sessionId"];
            
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.userAccount];
            [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userAccount"];
            
            //save user status
            [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"hasGoogleAuth"] forKey:GOOGLE_AUTH_BINDING];
            [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"hasTradePassword"] forKey:TRADEPASSWORD];
            
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

#pragma mark
#pragma mark - 保存对象

- (void)saveUserAccount:(MRUserAccount*)userAccount{
    
//    if (@available(iOS 11.0, *)) {
////        NSError *error;
////        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userAccount requiringSecureCoding:YES error:&error];
////        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:FilePathOS12];
//    } else {
//        self.userAccount = userAccount;
//        [NSKeyedArchiver archiveRootObject:userAccount toFile:FilePath];
//    }
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userAccount];
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userAccount"];
}

#pragma mark
#pragma mark - 得到对象
- (MRUserAccount*)getUserAccount{
//    MRUserAccount *userAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:FilePath];
    
    
    MRUserAccount *userAccount;
//    if (@available(iOS 11.0, *)) {
//        NSData *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAccount"];
//       userAccount = [NSKeyedUnarchiver unarchivedObjectOfClass:[MRUserAccount class] fromData:userData error:nil];
//
//    } else {
//
//    }
    NSData *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAccount"];
    userAccount = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//    userAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:@"userAccount"];
    return userAccount;
}

#pragma mark
#pragma mark - 上传资料

- (void)upLoadImageData:(NSData*)data success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"source":@"03",
                                 @"version":@"1.0",
                                 @"userId":self.userAccount.userId,
                                 @"sessionId":self.userAccount.sessionId
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self upload:MR_UPLOADPIC action:EGUSER parametes:jsonParameter withData:data complete:^(NSString *result) {
        
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

- (void)upLoadImagePath:(NSURL*)path success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock{
    self.userAccount = [[MRWebClient sharedInstance]getUserAccount];
    
    NSDictionary *parameters = @{
                                 @"name":@"file",
                                 };
    
    NSString *jsonParameter = [parameters JSONString];
    
    [self upload:MR_UPLOADPIC action:EGUSER parametes:jsonParameter withPath:path complete:^(NSString *result) {
        
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
                [session invalidateAndCancel];
            }else {
                NSString* dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

//                if (isEncrypt) {
//                    dataStr = [AESCipher decryptAES:dataStr key:KEY iv:IV];
//                } else {
//                    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
//                }
                
                if (complete) {
                    complete(dataStr);
                    [session invalidateAndCancel];
                }
            }
        } else {
            errorBlock(error);
            [session invalidateAndCancel];
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

- (void)upload:(NSString*)controller action:(NSString*)action parametes:(NSString*)parametes withPath:(NSURL*)path complete:(loginCompleteBlock)complete error:(void(^)(NSError*error))errorBlock{
    
    //检查网路连线
    if (![self checkReachabilty]) {
        NSDictionary *dic = @{@"ErrorCode":@1,@"ErrorMsg":@"Please check Your Network"};
        NSError *error = [NSError errorWithDomain:@"Network error" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
        errorBlock(error);
    }
    //请求url地址
    NSString *urlStr = [self getURLfromRules:action controller:controller];
    
    NSMutableURLRequest *request = [self requestWithURL:[NSURL URLWithString:urlStr]  andFilenName:@"image.png" andLocalFilePath:[NSString stringWithFormat:@"%@",path]];
    
    //连接(NSURLSession)
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
////        [SVProgressHUD dismiss];
//        id result=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"post==%@",result);
////        [SVProgressHUD showSuccessWithStatus:result[@"result_msg"]];
//        if (result[@"result_code"]) {
////            [self.navigationController popViewControllerAnimated:YES];
//        }
//
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if (!error) {
            if ([res statusCode] == 401) {
                NSInteger code = [res statusCode];
                NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%ld", (long)code] code:401 userInfo:nil];
                errorBlock(error);
                [session invalidateAndCancel];
            }else {
                NSString* dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                //                if (isEncrypt) {
                //                    dataStr = [AESCipher decryptAES:dataStr key:KEY iv:IV];
                //                } else {
                //                    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
                //                }
                
                if (complete) {
                    complete(dataStr);
                    [session invalidateAndCancel];
                }
            }
        } else {
            errorBlock(error);
            [session invalidateAndCancel];
        }
    }];
    [dataTask resume];
    
    
    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    //发起网络请求
    
//    [session uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
//    NSURL *fileURL = [NSURL fileURLWithPath:path isDirectory:NO];
//    [[session uploadTaskWithRequest:request fromFile:path completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//        if (!error) {
//            if ([res statusCode] == 401) {
//                NSInteger code = [res statusCode];
//                NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%ld", (long)code] code:401 userInfo:nil];
//                errorBlock(error);
//                [session invalidateAndCancel];
//            }else {
//                NSString* dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
//                //                if (isEncrypt) {
//                //                    dataStr = [AESCipher decryptAES:dataStr key:KEY iv:IV];
//                //                } else {
//                //                    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
//                //                }
//
//                if (complete) {
//                    complete(dataStr);
//                    [session invalidateAndCancel];
//                }
//            }
//        } else {
//            errorBlock(error);
//            [session invalidateAndCancel];
//        }
//    }]resume];
    
}

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url andFilenName:(NSString *)fileName andLocalFilePath:(NSString *)localFilePath{
    
    //post请求
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:2.0f];
    request.HTTPMethod=@"POST";//设置请求方法是POST
    request.timeoutInterval=30.0;//设置请求超时
    
    //拼接请求体数据(0-6步)
    NSMutableData *requestMutableData=[NSMutableData data];
    //0.拼接参数
    /*--------------------------------------------------------------------------*/
    NSDictionary *params = @{
                             @"name" : @"file",
                             };
    NSString *boundary = @"efMERrigEFA9A68312weF7106A";
    for (NSString *key in params) {
        
        NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=file\"%@\"\r\n\r\n",boundary,key];
        [requestMutableData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
        
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [requestMutableData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([value isKindOfClass:[NSData class]]){
            [requestMutableData appendData:value];
        }
        [requestMutableData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    /*--------------------------------------------------------------------------*/
    //1.\r\n--Boundary+72D4CD655314C423\r\n   // 分割符，以“--”开头，后面的字随便写，只要不写中文即可
    NSMutableString *myString=[NSMutableString stringWithFormat:@"\r\n--%@\r\n",boundary];
    
    //2. Content-Disposition: form-data; name="image"; filename="001.png"\r\n  // 这里注明服务器接收图片的参数（类似于接收用户名的userName）及服务器上保存图片的文件名
    [myString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fileName]];
    
    //3. Content-Type:image/png \r\n  // 图片类型为png
    [myString appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream\r\n"]];
    
    //4. Content-Transfer-Encoding: binary\r\n\r\n  // 编码方式
    [myString appendString:@"Content-Transfer-Encoding: binary\r\n\r\n"];
    
    //转换成为二进制数据
    [requestMutableData appendData:[myString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //5.文件数据部分
    NSURL *filePathUrl=[NSURL URLWithString:localFilePath];
    
    //转换成为二进制数据
    [requestMutableData appendData:[NSData dataWithContentsOfURL:filePathUrl]];
    
    //6. \r\n--Boundary+72D4CD655314C423--\r\n  // 分隔符后面以"--"结尾，表明结束
    [requestMutableData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    /*--------------------------------------------------------------------------*/
    
    
    //设置请求体
    request.HTTPBody=requestMutableData;
    
    //设置请求头
    NSString *headStr=[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:headStr forHTTPHeaderField:@"Content-Type"];
    
    return request;
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
