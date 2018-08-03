//
//  HomeViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/10.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HomeModelDelegate <NSObject>

@optional

- (void)getDataSucess;
- (void)getDataFalid:(NSError*)error;

@end

@interface HomeViewModel : NSObject
@property(nonatomic,weak) id<HomeModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getHomeInfo:(NSInteger)limit;

- (NSInteger)numberOfRowsInSection;

- (NSArray*)getHomeDataArray;

- (NSArray*)getDrawKLineInfoArray:(NSString*)coinPairId;

- (NSArray*)getExternalMarketInfo;
- (NSDictionary*)getExternalMarketInfoWithCoinId:(NSString*)coinId;
- (NSString*)getMultipleWithCurrentCoinId:(NSString*)coinId;

@end
