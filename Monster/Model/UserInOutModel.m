//
//  UserInOutModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.


#import "UserInOutModel.h"

@implementation UserInOutModel

+ (instancetype)userInOutWithDict:(NSDictionary *)dict{
    
    UserInOutModel *model = [[UserInOutModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
