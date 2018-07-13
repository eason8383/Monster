//
//  TrandModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "TrandModel.h"

@implementation TrandModel

+(instancetype)tradeModelWithDict:(NSDictionary *)dict{
    
    TrandModel *model = [[TrandModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
