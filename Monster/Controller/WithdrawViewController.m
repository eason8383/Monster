//
//  WithdrawViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "WithdrawViewController.h"

@interface WithdrawViewController ()
@property(nonatomic,strong)IBOutlet UITextField *units_Field;
@property(nonatomic,strong)IBOutlet UITextField *walletAdds_Field;
@property(nonatomic,strong)IBOutlet UITextField *verify_Field;

@property(nonatomic,strong)IBOutlet UIButton *currency_Btn;
@property(nonatomic,strong)IBOutlet UIButton *scan_Btn;
@property(nonatomic,strong)IBOutlet UIButton *verify_Btn;
@property(nonatomic,strong)IBOutlet UIButton *confirm_Btn;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提币";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [_units_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_walletAdds_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_verify_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    
    _verify_Btn.layer.borderColor = [UIColor colorWithHexString:@"3A29AD"].CGColor;
    _verify_Btn.layer.borderWidth = 1;
    _verify_Btn.layer.cornerRadius = 8;
    
    
    _confirm_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    _confirm_Btn.layer.borderWidth = 1;
    _confirm_Btn.layer.cornerRadius = 4;
    
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
