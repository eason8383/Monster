//
//  MRHomePageClient.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/10.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRWebClient.h"

@interface MRHomePageClient : MRWebClient

- (void)getCoinPairInfo:(NSString*)coinPairId withPage:(NSInteger)page success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)getKlineLastBar:(NSString*)klineType success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

- (void)getKlienList:(NSString*)coinPairId withKLineType:(NSString*)type withLimit:(NSInteger)limit withBeginBarTimeLong:(NSString*)beginBarTimeLong success:(void(^)(id response))successBlock failure:(void(^)(NSError*error))failureBlock;

@end
