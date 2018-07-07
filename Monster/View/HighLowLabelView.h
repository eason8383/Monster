//
//  HighLowLabelView.h
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HighLowLabelViewType) {
    HighLowType_High = 0,
    HighLowType_Low
};

@interface HighLowLabelView : UIView

- (void)setValue:(NSString*)value withHigh:(HighLowLabelViewType)type;

@end


