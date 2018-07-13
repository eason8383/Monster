//
//  MRUserInfoClient.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/12.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRWebClient.h"

@interface MRUserInfoClient : MRWebClient

- (void)getUserCoinQuantitySuccess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

@end
