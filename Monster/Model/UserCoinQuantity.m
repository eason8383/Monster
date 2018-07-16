//
//  UserCoinQuantity.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/16.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "UserCoinQuantity.h"

@implementation UserCoinQuantity

+ (instancetype)userCoinQuantityWithDict:(NSDictionary *)dict{
    UserCoinQuantity *model = [[UserCoinQuantity alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
