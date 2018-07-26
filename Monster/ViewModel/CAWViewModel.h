//
//  CAWViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/24.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CAWViewModelDelegate <NSObject>

@optional


- (void)getWalletSuccess:(NSDictionary*)info;
- (void)monitorCoinRecharge:(NSDictionary*)result;
- (void)withdrewApplySuccess:(NSDictionary*)info;
- (void)getDataFalid:(NSError*)error;

@end

@interface CAWViewModel : NSObject

@property(nonatomic,weak) id<CAWViewModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getWallet;

- (void)monitorCoinRecharge:(NSString*)walletId coinId:(NSString*)coin;

- (void)withdrewApply:(NSDictionary*)applyInfo;

@end
