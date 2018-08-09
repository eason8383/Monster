//
//  OrderHistoryViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/8.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrderHistoryModelDelegate <NSObject>

@optional

- (void)getDataSucess;
- (void)getDataFalid:(NSError*)error;

@end

@interface OrderHistoryViewModel : NSObject
@property(nonatomic,weak) id<OrderHistoryModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getOrderHistory:(NSInteger)page;
- (NSArray*)getOrderHistoryAry;

@end
