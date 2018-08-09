//
//  OrderHistoryViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/8.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "OrderHistoryViewModel.h"
#import "MRMyOrderClient.h"
#import "UserOrderModel.h"

@interface OrderHistoryViewModel()

@property(nonatomic,strong)NSMutableArray *orderHistoryAry;

@end

@implementation OrderHistoryViewModel

+ (instancetype)sharedInstance{
    
    static OrderHistoryViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OrderHistoryViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)getOrderHistory:(NSInteger)page{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MRMyOrderClient alloc]getOrderHistoryWithPage:page Success:^(id response) {
            NSDictionary *dic = response;
            
            if ([[dic objectForKey:@"success"] integerValue] == 1) {
                [self.orderHistoryAry removeAllObjects];
                for (NSDictionary *dicOrder in [dic objectForKey:@"resultList"]) {
                    UserOrderModel *model = [UserOrderModel userOrderWithDict:dicOrder];
                    [self.orderHistoryAry addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate getDataSucess];
                });
            } else {
                NSError *error = [NSError errorWithDomain:@"getOrderHistory" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate getDataFalid:error];
                    
                });
            }
            
            NSLog(@"response:%@",response);
            
        } failure:^(NSError *error) {
            //失敗
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataFalid:error];
                
            });
        }];
    });
}

- (NSArray*)getOrderHistoryAry{
    return self.orderHistoryAry;
}

- (NSMutableArray*)orderHistoryAry{
    if (_orderHistoryAry == 0) {
        _orderHistoryAry = [NSMutableArray array];
    }
    return _orderHistoryAry;
}

@end
