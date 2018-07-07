//
//  ChargeViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "ChargeViewController.h"

@interface ChargeViewController ()

@property(nonatomic,strong)IBOutlet UILabel *currencyLabel;
@property(nonatomic,strong)IBOutlet UIButton *changeCurreyBtn;
@property(nonatomic,strong)IBOutlet UIView *qrBackView;
@property(nonatomic,strong)IBOutlet UIView *qrCodeView;
@property(nonatomic,strong)IBOutlet UIButton *saveQrPicBtn;
@property(nonatomic,strong)IBOutlet UIButton *coAddressBtn;
@property(nonatomic,strong)IBOutlet UILabel *addressLabel;


@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充币";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    _saveQrPicBtn.layer.cornerRadius = 4;
    _coAddressBtn.layer.cornerRadius = 4;
}



@end
