//
//  CoinDetailViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/11.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CoinDetailViewModel.h"
#import "MRHomePageClient.h"

@implementation CoinDetailViewModel

+ (instancetype)sharedInstance{
    
    static CoinDetailViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoinDetailViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)getData{
    
}

@end
