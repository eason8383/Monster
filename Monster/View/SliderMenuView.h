//
//  SliderMenuView.h
//  VMM
//
//  Created by CHEN HAO LI on 2018/6/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderMenuView : UIView

@property(nonatomic,strong)IBOutlet UILabel *mobile_Label;
@property(nonatomic,strong)IBOutlet UILabel *asset_Label;
@property(nonatomic,strong)IBOutlet UILabel *subAsset_Label;

@property(nonatomic,strong)IBOutlet UIButton *close_Btn;
@property(nonatomic,strong)IBOutlet UIButton *myAsset_Btn;
@property(nonatomic,strong)IBOutlet UIButton *myOrder_Btn;
@property(nonatomic,strong)IBOutlet UIButton *identy_Btn;
@property(nonatomic,strong)IBOutlet UIButton *security_Btn;
@property(nonatomic,strong)IBOutlet UIButton *aboutus_Btn;
@property(nonatomic,strong)IBOutlet UIButton *setup_Btn;
@property(nonatomic,strong)IBOutlet UIButton *benefit_Btn;
@property(nonatomic,strong)IBOutlet UIButton *reflect_Btn;

@property(nonatomic,strong)IBOutlet UILabel *nowSession;

- (void)setisHideMode:(BOOL)isHide;


@end
