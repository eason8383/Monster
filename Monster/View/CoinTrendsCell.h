//
//  CoinTrendsCell.h
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoinPairModel;


@interface CoinTrendsCell : UITableViewCell

- (void)setContent:(CoinPairModel*)coinInfo dataArray:(NSArray*)ary;

@end


