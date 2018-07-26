//
//  UserOrderModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/13.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "UserOrderModel.h"

@implementation UserOrderModel

+ (instancetype)userOrderWithDict:(NSDictionary *)dict;{
    
    UserOrderModel *model = [[UserOrderModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
