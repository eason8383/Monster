//
//  UserInOutModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInOutModel : NSObject


@property(nonatomic,copy)NSString *blockChainType;
@property(nonatomic,copy)NSString *coinId;
@property(nonatomic,copy)NSString *inOut;
@property(nonatomic,copy)NSString *inOutId;
@property(nonatomic,copy)NSString *inOutName;
@property(nonatomic,copy)NSString *processStatusName;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *toAddress;
@property(nonatomic,assign)double coinQuantity;
@property(nonatomic,copy)NSString *exchangeFee;
@property(nonatomic,copy)NSString *processStatus;
@property(nonatomic,assign)long createTime;

+ (instancetype)userInOutWithDict:(NSDictionary *)dict;

//blockChainType = ETH;
//coinId = ETH;
//coinQuantity = "2433.89339839";
//createTime = 1533190580000;
//exchangeFee = "0.01";
//inOut = O;
//inOutId = INOUT201808021416202492775380872;
//inOutName = "\U63d0\U73b0";
//processStatus = 1;
//processStatusName = "\U6b63\U5728\U5904\U7406";
//toAddress = 23r23f23;
//userId = KID2018071215401611463992919101;

@end
