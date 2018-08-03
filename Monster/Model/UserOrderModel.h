//
//  UserOrderModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/13.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserOrderModel : NSObject

@property(nonatomic,copy)NSString *coinPairId;
@property(nonatomic,copy)NSString *orderStatusName;
@property(nonatomic,copy)NSString *buySellName;
@property(nonatomic,copy)NSString *buySell;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *orderStatus;
@property(nonatomic,copy)NSString *userId;

@property(nonatomic,assign)float dealQuantity;
@property(nonatomic,assign)float dealAmount;
@property(nonatomic,assign)float dealPrice;
@property(nonatomic,assign)long createTime;
@property(nonatomic,assign)float leftQuantity;
@property(nonatomic,assign)float orderQuantity;
@property(nonatomic,assign)float feeRate;
@property(nonatomic,assign)float orderVolume;
@property(nonatomic,assign)double orderPrice;


+ (instancetype)userOrderWithDict:(NSDictionary *)dict;
@end
