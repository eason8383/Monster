//
//  SliderMenuView.m
//  VMM
//
//  Created by CHEN HAO LI on 2018/6/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "SliderMenuView.h"

@interface SliderMenuView ()

@property(nonatomic,strong)IBOutlet UILabel *myWalletLabel;

@property(nonatomic,strong)IBOutlet UILabel *myAssetLabel;
@property(nonatomic,strong)IBOutlet UILabel *myOrderLabel;
@property(nonatomic,strong)IBOutlet UILabel *idVerifyLabel;
@property(nonatomic,strong)IBOutlet UILabel *securityLabel;
@property(nonatomic,strong)IBOutlet UILabel *aboutUsLabel;
@property(nonatomic,strong)IBOutlet UILabel *feedbackLabel;
@property(nonatomic,strong)IBOutlet UILabel *settingLabel;

@property(nonatomic,strong)IBOutlet UILabel *bSecretLabel;
@property(nonatomic,strong)IBOutlet UILabel *sSecretLabel;
@property(nonatomic,strong)IBOutlet UIImageView *eyeImg;
@property(nonatomic,strong)IBOutlet UIButton *hideAssetBtn;
@property(nonatomic,assign)BOOL isNowHideMyAsset;

@end

@implementation SliderMenuView

- (void)awakeFromNib {
    [super awakeFromNib];
    _isNowHideMyAsset = [[NSUserDefaults standardUserDefaults]boolForKey:@"ISNOWHIDEMYASSET"];
    [self setisHideMode:_isNowHideMyAsset];
    [self fillText];
}

- (void)fillText{
    [_myWalletLabel setText:LocalizeString(@"MYWALLETVALUE")];
    [_myAssetLabel setText:LocalizeString(@"MYASSET")];
    [_myOrderLabel setText:LocalizeString(@"MYORDER")];
    [_idVerifyLabel setText:LocalizeString(@"IDVERIFICATIOM")];
    [_securityLabel setText:LocalizeString(@"SECURUTY")];
    [_aboutUsLabel setText:LocalizeString(@"ABOUTUS")];
    [_feedbackLabel setText:LocalizeString(@"FEEDBACK")];
    [_settingLabel setText:LocalizeString(@"SETTINGS")];
    
    //    "MYWALLETVALUE" = "钱包资产估值";
    //    "MYASSET" = "我的资产";
    //    "MYORDER" = "我的订单";
    //    "IDVERIFICATIOM" = "身份认证";
    //    "SECURUTY" = "安全认证";
    //    "ABOUTUS" = "关于我们";
    //    "FEEDBACK" = "问题反馈";
    //    "SETTINGS" = "设置";
}


- (IBAction)tapHideMyAsset:(UIButton*)sender{
    
    _isNowHideMyAsset = !_isNowHideMyAsset;
    
    [self setisHideMode:_isNowHideMyAsset];
    [[NSUserDefaults standardUserDefaults]setBool:_isNowHideMyAsset forKey: @"ISNOWHIDEMYASSET"];
}

- (void)setisHideMode:(BOOL)isHide{
    _asset_Label.hidden =  isHide;
    _subAsset_Label.hidden = isHide;
    [_eyeImg setImage:[UIImage imageNamed:isHide?@"nodisplay":@"display"]];
    _bSecretLabel.hidden = !isHide;
    _sSecretLabel.hidden = !isHide;
}

@end
