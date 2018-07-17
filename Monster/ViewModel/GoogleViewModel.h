//
//  GoogleViewModel.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/17.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoogleViewModelDelegate <NSObject>

@optional

- (void)getBindingBack:(NSDictionary*)bindingInfo;
- (void)getSmsVerifyCode:(NSDictionary*)verifyInfo;
- (void)confirmSuccess:(NSDictionary*)bindingInfo;

- (void)getDataFalid:(NSError*)error;
@end

@interface GoogleViewModel : NSObject
@property(nonatomic,weak) id<GoogleViewModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getBindingCode;

- (void)getSmsVerifyCode;

- (void)confirmAuthCode:(NSString*)authCode verifyCode:(NSString*)verifyCode;

@end
