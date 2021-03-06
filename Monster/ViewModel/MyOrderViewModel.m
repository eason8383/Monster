//
//  MyOrderViewModel.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/14.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MyOrderViewModel.h"
#import "MRMyOrderClient.h"
#import "UserOrderModel.h"

@interface MyOrderViewModel()

@property(nonatomic,strong)NSMutableArray *orderAry;

@end

@implementation MyOrderViewModel

+ (instancetype)sharedInstance{
    
    static MyOrderViewModel *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyOrderViewModel alloc]init];
        
    });
    
    return instance;
}

- (void)getData:(NSInteger)page{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getMyOrderDeal:page];
    });
}

- (void)getMyOrderDeal:(NSInteger)page{
    [[MRMyOrderClient alloc]getMyOrderSuccess:page sucess:^(id response) {
        NSDictionary *dic = response;
        
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self.orderAry removeAllObjects];
            for (NSDictionary *dicOrder in [dic objectForKey:@"resultList"]) {
                UserOrderModel *model = [UserOrderModel userOrderWithDict:dicOrder];
                [self.orderAry addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate getDataSucess];
            });
        } else {
            NSError *error = [NSError errorWithDomain:@"getMyOrder" code:[[dic objectForKey:@"ErrorCode"]intValue] userInfo:dic];
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
}

- (NSArray*)getOrderAry{
    return self.orderAry;
}

- (NSInteger)numberOfRowsInSection{
    return [self.orderAry count];
}

- (NSMutableArray*)orderAry{
    if (_orderAry == nil) {
        _orderAry = [NSMutableArray array];
    }
    return _orderAry;
}


@end
