//
//  CoinDetailViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/11.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoinDetailVMDelegate <NSObject>

@optional

- (void)getDataSucess;
- (void)getDataFalid:(NSError*)error;

@end

@interface CoinDetailViewModel : NSObject
@property(nonatomic,weak) id<CoinDetailVMDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getData;



@end
