//
//  TrandModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrandModel : NSObject

@property(nonatomic,copy)NSString *coinPairId;
@property(nonatomic,copy)NSString *buySellName;
@property(nonatomic,copy)NSString *buySell;

@property(nonatomic,assign)float orderVolume;
@property(nonatomic,assign)double orderPrice;

+ (instancetype)tradeModelWithDict:(NSDictionary *)dict;

@end
