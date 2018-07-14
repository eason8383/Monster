//
//  MyOrderViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/14.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyOrderViewModelDelegate <NSObject>

@optional

- (void)getDataSucess;
- (void)getDataFalid:(NSError*)error;

@end

@interface MyOrderViewModel : NSObject
@property(nonatomic,weak) id<MyOrderViewModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getData;
- (void)getOrderHistory:(NSInteger)page;
- (NSArray*)getOrderAry;
- (NSArray*)getOrderHistoryAry;
- (NSInteger)numberOfRowsInSection;

@end
