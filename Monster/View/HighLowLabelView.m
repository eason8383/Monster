//
//  HighLowLabelView.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "HighLowLabelView.h"

@interface HighLowLabelView()

@property(nonatomic,strong)IBOutlet UILabel *numberLabel;

@end

@implementation HighLowLabelView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
}

- (void)setValue:(NSString*)value withHigh:(HighLowLabelViewType)type{
    [_numberLabel setText:value];
    switch (type) {
        case HighLowType_Low:
            [self setBackgroundColor:[UIColor colorWithHexString:MRCOLORHEX_LOW]];
            break;
        case HighLowType_High:
            [self setBackgroundColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH]];
            break;
        default:
            [self setBackgroundColor:[UIColor colorWithHexString:MRCOLORHEX_HIGH]];
            break;
    }
}

@end
