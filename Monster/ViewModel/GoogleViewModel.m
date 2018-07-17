//
//  GoogleViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/17.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "GoogleViewModel.h"
#import "MRGoogleClient.h"

@interface GoogleViewModel()


@end

@implementation GoogleViewModel

+ (instancetype)sharedInstance{
    
    static GoogleViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GoogleViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)getBindingCode{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getBindingCodeFromServer];
    });
}

- (void)getBindingCodeFromServer{
    [[MRGoogleClient alloc]getBindingCodeSuccess:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            
            for (NSDictionary *info in [dic objectForKey:@"resultList"]) {
                NSLog(@"%@",info);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.delegate getBindingBack:dic];
            });
            
        } else {
            NSError *error = [NSError errorWithDomain:@"getMyOrder" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
                
            });
        }
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate getDataFalid:error];
        });
    }];
}

- (void)getSmsVerifyCode{
    [[MRGoogleClient alloc]getSmsVerifyCodeBUIdSuccess:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            
            for (NSDictionary *info in [dic objectForKey:@"resultList"]) {
                NSLog(@"%@",info);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getSmsVerifyCode:dic];
                
            });
            
        } else {
            NSError *error = [NSError errorWithDomain:@"getMyOrder" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
                
            });
        }
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate getDataFalid:error];
        });
    }];
}

- (void)confirmAuthCode:(NSString*)authCode verifyCode:(NSString*)verifyCode{
    [[MRGoogleClient alloc]authMyIdentity:authCode verifyCode:verifyCode Success:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            
            for (NSDictionary *info in [dic objectForKey:@"resultList"]) {
                NSLog(@"%@",info);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate confirmSuccess:dic];
               
            });
            
        } else {
            NSError *error = [NSError errorWithDomain:@"confirmAuthCode" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
                
            });
        }
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate getDataFalid:error];
        });
    }];
}

@end
