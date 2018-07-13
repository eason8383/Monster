//
//  TradeViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TradeViewModelDelegate <NSObject>

@optional

- (void)getDataSucess;
- (void)getDataFalid:(NSError*)error;

@end

@interface TradeViewModel : NSObject
@property(nonatomic,weak) id<TradeViewModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getData:(NSString*)coinPairId;


- (NSArray*)getBuyAry;
- (NSArray*)getSaleAry;
- (NSArray*)getUserQuantityAry;

@end
