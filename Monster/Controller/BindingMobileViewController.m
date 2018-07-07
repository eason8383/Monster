//
//  BindingMobileViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "BindingMobileViewController.h"

@interface BindingMobileViewController ()
@property(nonatomic,strong)IBOutlet UITextField *country_Field;
@property(nonatomic,strong)IBOutlet UITextField *mobileNo_Field;
@property(nonatomic,strong)IBOutlet UITextField *smsVerify_Field;
@property(nonatomic,strong)IBOutlet UITextField *mailVerify_Field;

@property(nonatomic,strong)IBOutlet UIButton *smsVerify_Btn;
@property(nonatomic,strong)IBOutlet UIButton *mailVerify_Btn;
@property(nonatomic,strong)IBOutlet UIButton *confirm_Btn;
@end

@implementation BindingMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置手机号";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [_country_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_mobileNo_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_smsVerify_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_mailVerify_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    
    _smsVerify_Btn.layer.borderColor = [UIColor colorWithHexString:@"3A29AD"].CGColor;
    _smsVerify_Btn.layer.borderWidth = 1;
    _smsVerify_Btn.layer.cornerRadius = 8;
    
    _mailVerify_Btn.layer.borderColor = [UIColor colorWithHexString:@"3A29AD"].CGColor;
    _mailVerify_Btn.layer.borderWidth = 1;
    _mailVerify_Btn.layer.cornerRadius = 8;
    
    _confirm_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    _confirm_Btn.layer.borderWidth = 1;
    _confirm_Btn.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
