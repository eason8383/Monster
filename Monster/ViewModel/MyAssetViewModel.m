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
#import "UserOrderModel.h"

@interface MyAssetViewModel()

@property(nonatomic,strong)NSMutableArray *userCoinQuantityAry;
@property(nonatomic,strong)NSMutableArray *userCoinInOutAry;

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

- (void)getUserCoinInOutInfo{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getUserCoinInOutInfoAPI];
    });
}

- (void)getUserCoinQuantityAPI{
    [[MRUserInfoClient alloc]getUserCoinQuantitySuccess:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            
            NSMutableArray *tampAry = [NSMutableArray array];
            for (NSDictionary *info in [dic objectForKey:@"resultList"]) {
                NSLog(@"%@",info);
                [tampAry addObject:info];
            }
            [self combineDatas:tampAry];
            NSDictionary *assetInfo = [self getAssetInfo:tampAry];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.delegate getDataSucess:assetInfo];
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

- (NSDictionary*)getAssetInfo:(NSArray*)ary{
    NSMutableDictionary *asstInfo = [NSMutableDictionary dictionary];
    [ary enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
        
        if ([[info objectForKey:@"quantityStatus"] isEqualToString:@"0"]) {
            [asstInfo setObject:[info objectForKey:@"coinQuantity"] forKey:[info objectForKey:@"coinId"]];
        }
    }];
    NSLog(@"getAssetInfo:%@",asstInfo);
    return asstInfo;
}

- (void)combineDatas:(NSArray*)dataAry{
    
    NSMutableArray *newAry = [NSMutableArray array];
    [dataAry enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
        if ([[info objectForKey:@"quantityStatus"]isEqualToString:@"0"] || [[info objectForKey:@"quantityStatus"]isEqualToString:@"2"]) {
            [newAry addObject:info];
        }
    }];
    
    [self.userCoinQuantityAry removeAllObjects];
    [[self sort:newAry] enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
        
        if (idx == 0) {
            NSMutableArray *objAry = [NSMutableArray array];
            UserCoinQuantity *ucq = [UserCoinQuantity userCoinQuantityWithDict:info];
            [objAry addObject:ucq];
            [self.userCoinQuantityAry addObject:objAry];
        } else {
            NSMutableArray *objAry = [self.userCoinQuantityAry lastObject];
            UserCoinQuantity *exUcq = [objAry objectAtIndex:0];
            UserCoinQuantity *ucq = [UserCoinQuantity userCoinQuantityWithDict:info];
            if ([exUcq.coinId isEqualToString:ucq.coinId]) {
                [objAry addObject:ucq];
            } else {
                NSMutableArray *newObjAry = [NSMutableArray array];
                [newObjAry addObject:ucq];
                [self.userCoinQuantityAry addObject:newObjAry];
            }
        }
        
    }];
    NSLog(@"%@",self.userCoinQuantityAry);
//    for (NSDictionary *dic in dataAry) {
//        NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
//
//        CoinPairModel *coModel = [CoinPairModel coinPairWithDict:finalDic];
//        [self.homeDataAry addObject:coModel];
//    }

    
}


- (NSArray*)sort:(NSArray*)dataArray{
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"coinId"
                                                                    ascending:YES
                                                                     selector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    return [dataArray sortedArrayUsingDescriptors:@[firstDescriptor]];
}

- (void)getUserCoinInOutInfoAPI{
    [[MRUserInfoClient alloc]getUserCoinInOutInfo:@"" Success:^(id response) {
        NSDictionary *dic = response;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self.userCoinInOutAry removeAllObjects];
            for (NSDictionary *info in [dic objectForKey:@"resultList"]) {
                UserOrderModel *uom = [UserOrderModel userOrderWithDict:info];
                [self.userCoinInOutAry addObject:uom];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.delegate getUserCoinInOutInfoSucess];
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

- (NSInteger)numberOfRowinSectionForCapital{
    return self.userCoinInOutAry.count;
}

- (NSArray*)getUserCoinInOutHistory{
    return self.userCoinInOutAry;
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

- (NSMutableArray*)userCoinInOutAry{
    if(_userCoinInOutAry == nil){
        _userCoinInOutAry = [NSMutableArray array];
    }
    return _userCoinInOutAry;
}



@end
