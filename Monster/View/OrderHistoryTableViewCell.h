//
//  OrderHistoryTableViewCell.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserOrderModel;

@interface OrderHistoryTableViewCell : UITableViewCell

- (void)setContent:(UserOrderModel*)userOrderInfo;

@end
