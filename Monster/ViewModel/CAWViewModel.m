//
//  CAWViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/24.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CAWViewModel.h"
#import "MRUserInfoClient.h"

@implementation CAWViewModel

+ (instancetype)sharedInstance{
    
    static CAWViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CAWViewModel alloc]init];
        
    });
    
    return instance;
}


- (void)getWallet{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRUserInfoClient alloc]queryUserCoinWalletSuccess:^(id response){
            NSDictionary *dic = response;
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate getWalletSuccess:dic];
                });
                
            } else {
                NSError *error = [NSError errorWithDomain:@"getWallet" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
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
    });
}

- (void)monitorCoinRecharge:(NSString*)walletId coinId:(NSString*)coin{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRUserInfoClient alloc]monitorCoinRecharge:walletId coinId:coin Success:^(id response){
            NSDictionary *dic = response;
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate monitorCoinRecharge:dic];
                });
                
            } else {
                NSError *error = [NSError errorWithDomain:@"monitor Coin Recharge" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
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
    });
}

- (void)withdrewApply:(NSDictionary*)applyInfo{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRUserInfoClient alloc]withdrawApply:applyInfo Success:^(id response){
            NSDictionary *dic = response;
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate withdrewApplySuccess:dic];
                });
                
            } else {
                NSError *error = [NSError errorWithDomain:@"withdrawApply" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
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
    });
}

@end
