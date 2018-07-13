//
//  SetupViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "SetupViewController.h"

@interface SetupViewController ()
@property(nonatomic,strong)IBOutlet UIButton *languageBtn;
@property(nonatomic,strong)IBOutlet UIButton *currencyBtn;

@property(nonatomic,strong)IBOutlet UILabel *languageLabel;
@property(nonatomic,strong)IBOutlet UILabel *currencyLabel;
@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    NSString *nowCurrency = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    if ([nowCurrency isEqualToString:CNY]) {
        self.currencyLabel.text = @"人民币>";
    } else {
        self.currencyLabel.text = @"美元>";
    }
}

- (IBAction)setDafaultCurrency:(id)sender{
    
    NSMutableArray *actions = [NSMutableArray array];

    UIAlertAction *CNYAction = [UIAlertAction actionWithTitle:@"人民币" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.currencyLabel.text = [NSString stringWithFormat:@"%@>",action.title];
        [[NSUserDefaults standardUserDefaults]setObject:CNY forKey:DEFAULTCURRENCY];
    }];
    UIAlertAction *USDAction = [UIAlertAction actionWithTitle:@"美元" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
        self.currencyLabel.text = [NSString stringWithFormat:@"%@>",action.title];
        [[NSUserDefaults standardUserDefaults]setObject:USD forKey:DEFAULTCURRENCY];
    }];
    [actions addObject:CNYAction];
    [actions addObject:USDAction];

    
    [self showActionSheet:@"" message:@"计价方式" withActions:actions];
    
}

@end
