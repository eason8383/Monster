//
//  UCoinQuantity.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/13.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCoinQuantity : NSObject


@property(nonatomic,copy)NSString *coinId;
@property(nonatomic,copy)NSString *quantityStatusName;
@property(nonatomic,copy)NSString *userId;

@property(nonatomic,assign)float coinQuantity;
@property(nonatomic,assign)NSInteger quantityStatus;
//"coinId": "ETH",
//"quantityStatusName": "普通",
//"coinQuantity": 10,
//"userId": "KID2018071014254112526883540120",
//"quantityStatus": "0"

+ (instancetype)uCoinQuantityWithDict:(NSDictionary *)dict;

@end
