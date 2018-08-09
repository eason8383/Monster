//
//  MyAssetTableViewCell.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MyAssetTableViewCell.h"

@interface MyAssetTableViewCell ()
@property(nonatomic,strong)IBOutlet UILabel *myAssetLabel;
@property(nonatomic,strong)IBOutlet UILabel *subAssetLabel;
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;

@property(nonatomic,strong)IBOutlet UILabel *chargeLabel;
@property(nonatomic,strong)IBOutlet UILabel *withdrawLabel;
@property(nonatomic,strong)IBOutlet UILabel *recordLabel;
@property(nonatomic,strong)IBOutlet UILabel *detailLabel;
@property(nonatomic,strong)IBOutlet UILabel *pairLabel;
@property(nonatomic,strong)IBOutlet UILabel *avaliLabel;
@property(nonatomic,strong)IBOutlet UILabel *inOrderLabel;

@property(nonatomic,strong)IBOutlet UIImageView *checkBox;
@property(nonatomic,strong)IBOutlet UIView *backView;

@property (nonatomic) CGPoint inputPoint0;
@property (nonatomic) CGPoint inputPoint1;
@property (nonatomic) UIColor *inputColor0;
@property (nonatomic) UIColor *inputColor1;

@end

@implementation MyAssetTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self fillText];
}

- (void)fillText{
    [_titleLabel setText:LocalizeString(@"MARKETABLEASSETS")];
    [_chargeLabel setText:LocalizeString(@"CHARGE")];
    [_withdrawLabel setText:LocalizeString(@"WITHDRAW")];
    [_recordLabel setText:LocalizeString(@"MONEY_RECORD")];
    [_detailLabel setText:LocalizeString(@"ASSETDETAIL")];
    
    [_pairLabel setText:LocalizeString(@"PAIR")];
    [_avaliLabel setText:LocalizeString(@"AVAILABLE")];
    [_inOrderLabel setText:LocalizeString(@"INORDER")];

//    "MYASSET" = "我的资产";
//    "MARKETABLEASSETS" = "我的资产折合 (ETH)";
//    "CHARGE" = "充值";
//    "WITHDRAW" = "提币";
//    "MONEY_RECORD" = "资金纪录";
//    "ASSETDETAIL" = "资产明细";
//    "PAIR" = "币种";
//    "AVAILABLE" = "可用";
//    "INORDER" = "冻结";
}

- (void)setContent:(NSDictionary *)info{
//    float asset = [[info objectForKey:@"myAsset"] floatValue];
    
    [_myAssetLabel setText:[info objectForKey:@"myAsset"]];
    NSString *currencyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    NSString *dollarSign = [currencyStr isEqualToString:CNY]?@"￥":@"$";
    [_subAssetLabel setText:[NSString stringWithFormat:@"≈%@%@",dollarSign,[info objectForKey:@"result"]]];
}

- (void)setBtnTarget:(id)target select:(SEL)select{
    [self.chargeBtn addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
    [self.withDrawBtn addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
    [self.capitalBtn addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
