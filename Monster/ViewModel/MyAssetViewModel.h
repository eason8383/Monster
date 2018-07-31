//
//  MyAssetViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/16.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MyAssetViewModelDelegate <NSObject>

@optional

- (void)getDataSucess:(NSDictionary*)info;
- (void)getUserCoinInOutInfoSucess;
- (void)getDataFalid:(NSError*)error;

@end
@interface MyAssetViewModel : NSObject

@property(nonatomic,weak) id<MyAssetViewModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getData;
- (void)getUserCoinInOutInfo;
- (NSInteger)numberOfRowinSectionForCapital;

- (NSInteger)numberOfRowinSection;

- (NSArray*)getUserCoinQuantity;
- (NSArray*)getUserCoinInOutHistory;

@end
