//
//  MRUserAccount.h
//  Monster
//
//  Created by eason's macbook on 2018/7/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRBaseModel.h"

@interface MRUserAccount : MRBaseModel

@property (nonatomic, assign)BOOL fwcJoinFlag;

@property (nonatomic, copy) NSString *inviteCode;

@property (nonatomic, copy) NSString *sessionId;

//用户id
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *mobileNo;


+ (instancetype)accountWithDict:(NSDictionary *)dict;


@end


