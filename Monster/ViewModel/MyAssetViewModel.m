//
//  MyAssetViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/16.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MyAssetViewModel.h"
#import "MRUserInfoClient.h"
#import "UserCoinQuantity.h"

@interface MyAssetViewModel()

@property(nonatomic,strong)NSMutableArray *userCoinQuantityAry;

@end

@implementation MyAssetViewModel

+ (instancetype)sharedInstance{
    
    static MyAssetViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyAssetViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)getData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getUserCoinQuantityAPI];
    });
}


- (void)getUserCoinQuantityAPI{
    [[MRUserInfoClient alloc]getUserCoinQuantitySuccess:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self.userCoinQuantityAry removeAllObjects];
            for (NSDictionary *info in [dic objectForKey:@"resultList"]) {
                UserCoinQuantity *ucq = [UserCoinQuantity userCoinQuantityWithDict:info];
                [self.userCoinQuantityAry addObject:ucq];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.delegate getDataSucess];
            });
            
        } else {
            
        }
        
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //失敗
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (NSArray*)getUserCoinQuantity{
    return self.userCoinQuantityAry;
}

- (NSInteger)numberOfRowinSection{
    return self.userCoinQuantityAry.count;
}

- (NSMutableArray*)userCoinQuantityAry{
    if (_userCoinQuantityAry == nil) {
        _userCoinQuantityAry = [NSMutableArray array];
    }
    return _userCoinQuantityAry;
}



@end
