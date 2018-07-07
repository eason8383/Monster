//
//  MyAssetTableViewCell.h
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MyAssetTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *chargeBtn;
@property(nonatomic,strong)IBOutlet UIButton *withDrawBtn;
@property(nonatomic,strong)IBOutlet UIButton *capitalBtn;
@property(nonatomic,strong)IBOutlet UIButton *hideSmallBtn;

- (void)setBtnTarget:(id)target select:(SEL)select;

@end


