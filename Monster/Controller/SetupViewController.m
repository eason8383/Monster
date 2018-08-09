//
//  SetupViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "SetupViewController.h"
#import "SelectViewController.h"
#import "LanguageViewController.h"

@interface SetupViewController ()
@property(nonatomic,strong)IBOutlet UIButton *languageBtn;
@property(nonatomic,strong)IBOutlet UIButton *currencyBtn;

@property(nonatomic,strong)IBOutlet UILabel *languageTitleLabel;
@property(nonatomic,strong)IBOutlet UILabel *currencyTitleLabel;

@property(nonatomic,strong)IBOutlet UILabel *languageLabel;
@property(nonatomic,strong)IBOutlet UILabel *currencyLabel;

@property(nonatomic,strong)IBOutlet UIButton *logoutBtn;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizeString(@"SETUP");
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    _logoutBtn.layer.cornerRadius = 4;
    
    [self fillText];
}

- (void)fillText{
    [_languageTitleLabel setText:LocalizeString(@"LANGUAGE")];
    [_currencyTitleLabel setText:LocalizeString(@"PRICE_RATE")];
    [_logoutBtn setTitle:LocalizeString(@"LOGOUT") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    NSString *nowCurrency = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    
    NSString *str = [nowCurrency isEqualToString:CNY]?LocalizeString(@"CNY"):LocalizeString(@"USD");
    
    NSString *resultStr = [NSString stringWithFormat:@"%@>",str];
    
    if (![self.currencyLabel.text isEqualToString:resultStr]) {
        
        self.currencyLabel.text = resultStr;
    }
    
    NSString *nowLan = [[LanguageTool sharedInstance] nowLanguage];
    
    NSString *lanStr = [NSString stringWithFormat:@"%@>",[nowLan isEqualToString:EN]?LocalizeString(@"ENGLISH"):LocalizeString(@"CHINESE")];
    [_languageLabel setText:lanStr];
}

- (IBAction)setLanguage:(id)sender{
    LanguageViewController *sVc = [[LanguageViewController alloc]initWithNibName:@"LanguageViewController" bundle:nil];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    [self.navigationController pushViewController:sVc animated:YES];
}

- (IBAction)setDafaultCurrency:(id)sender{
    
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
