//
//  UCoinQuantity.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/13.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "UCoinQuantity.h"

@implementation UCoinQuantity

+ (instancetype)uCoinQuantityWithDict:(NSDictionary *)dict;{
    
    UCoinQuantity *model = [[UCoinQuantity alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
