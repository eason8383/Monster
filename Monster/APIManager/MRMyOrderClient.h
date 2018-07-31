//
//  MRMyOrderClient.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/14.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MRWebClient.h"

@interface MRMyOrderClient : MRWebClient

- (void)getMyOrderSuccess:(NSInteger)page sucess:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)getOrderHistoryWithPage:(NSInteger)page Success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

@end
