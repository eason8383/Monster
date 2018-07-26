//
//  ChoseCoinTableViewCell.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/16.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoinPairModel;

@interface ChoseCoinTableViewCell : UITableViewCell

- (void)setContent:(CoinPairModel*)coinInfo;

@end
