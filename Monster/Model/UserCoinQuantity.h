//
//  UserCoinQuantity.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/16.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCoinQuantity : NSObject

@property(nonatomic,strong)NSString *coinId;
@property(nonatomic,strong)NSString *quantityStatusName;
@property(nonatomic,strong)NSString *userId;

@property(nonatomic,assign)double coinQuantity;
@property(nonatomic,assign)NSInteger quantityStatus;


+ (instancetype)userCoinQuantityWithDict:(NSDictionary *)dict;
//"coinId": "MON",
//"quantityStatusName": "普通",
//"coinQuantity": 100,
//"userId": "KID2018071014254112526883540120",
//"quantityStatus": "0"

@end
