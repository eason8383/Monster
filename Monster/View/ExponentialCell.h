//
//  ExponentialCell.h
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExponentialCell : UITableViewCell


@property(nonatomic,strong)IBOutlet UIButton *moreDetailBtn;

- (void)setTitle:(NSString*)title subTitle:(NSString*)subTitle;

@end
