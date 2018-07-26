//
//  EntrustNowViewCell.h
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserOrderModel;

@interface EntrustNowViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *cancelBtn;

- (void)setContent:(UserOrderModel*)orderInfo;

@end

