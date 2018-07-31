//
//  SetupViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "SetupViewController.h"
#import "SelectViewController.h"

@interface SetupViewController ()
@property(nonatomic,strong)IBOutlet UIButton *languageBtn;
@property(nonatomic,strong)IBOutlet UIButton *currencyBtn;

@property(nonatomic,strong)IBOutlet UILabel *languageLabel;
@property(nonatomic,strong)IBOutlet UILabel *currencyLabel;

@property(nonatomic,strong)IBOutlet UIButton *logoutBtn;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    _logoutBtn.layer.cornerRadius = 4;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    NSString *nowCurrency = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    NSString *str = [nowCurrency isEqualToString:CNY]?@"人民币>":@"美元>";
    if (![self.currencyLabel.text isEqualToString:str]) {
        
        self.currencyLabel.text = str;
    }
    
}

- (IBAction)setDafaultCurrency:(id)sender{
    
//    NSMutableArray *actions = [NSMutableArray array];
//
//    UIAlertAction *CNYAction = [UIAlertAction actionWithTitle:@"人民币" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//        self.currencyLabel.text = [NSString stringWithFormat:@"%@>",action.title];
//        [[NSUserDefaults standardUserDefaults]setObject:CNY forKey:DEFAULTCURRENCY];
//    }];
//    UIAlertAction *USDAction = [UIAlertAction actionWithTitle:@"美元" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//        self.currencyLabel.text = [NSString stringWithFormat:@"%@>",action.title];
//        [[NSUserDefaults standardUserDefaults]setObject:USD forKey:DEFAULTCURRENCY];
//    }];
//    [actions addObject:CNYAction];
//    [actions addObject:USDAction];
//
//
//    [self showActionSheet:@"" message:@"计价方式" withActions:actions];
    
    SelectViewController *sVc = [[SelectViewController alloc]initWithNibName:@"SelectViewController" bundle:nil];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    [self.navigationController pushViewController:sVc animated:YES];
    
    
}

- (IBAction)logout:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:DOLOGOUT object:nil];
}

@end
