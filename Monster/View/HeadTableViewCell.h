//
//  HeadTableViewCell.h
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HeadTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *mobileNo_Label;
@property(nonatomic,strong)IBOutlet UIButton *callMenuBtn;
@property(nonatomic,strong)IBOutlet UIButton *audioViewBtn;
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;

- (void)setFilpLabelInfos:(NSArray*)infos;

- (void)setPoaMALabel:(NSString*)text;

@end

