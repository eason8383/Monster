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

- (void)getBindingCodeSuccess:(NSDictionary*)bindingInfo;
- (void)getSmsVerifyCode:(NSDictionary*)verifyInfo;
- (void)bindingSuccess:(NSDictionary*)bindingInfo;
- (void)identitySuccess:(NSDictionary*)identityInfo;

- (void)getDataFalid:(NSError*)error;
@end

@interface GoogleViewModel : NSObject
@property(nonatomic,weak) id<GoogleViewModelDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)getBindingCode;

- (void)getSmsVerifyCode;

- (void)identityAuthCode:(NSString*)authCode;

- (void)bindingAuthCode:(NSString*)authCode verifyCode:(NSString*)verifyCode;

@end
