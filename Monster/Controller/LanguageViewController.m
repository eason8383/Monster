//
//  LanguageViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/8/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "LanguageViewController.h"
#import "CounterPriceViewCell.h"

@interface LanguageViewController ()
@property(nonatomic,strong)NSString* nowLanguage;

@end

@implementation LanguageViewController

static NSString *languageCellIdentifier = @"LanguageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizeString(@"LANGUAGE");
    [self initial];
}

- (void)initial{
    _nowLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    [self registerCells];
}

- (void)registerCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CounterPriceViewCell" bundle:nil] forCellReuseIdentifier:languageCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *latestSet = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    
    if (![_nowLanguage isEqualToString:latestSet]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:RELOAD_AFTERSETTING];
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *nowLan = [[LanguageTool sharedInstance] nowLanguage];
    CounterPriceViewCell *cpCell = (CounterPriceViewCell *)[tableView dequeueReusableCellWithIdentifier:languageCellIdentifier];
    
    if (indexPath.row == 0) {
        [cpCell setContent:LocalizeString(@"ENGLISH") isChecked:[nowLan isEqualToString:EN]?YES:NO];
    } else {
        [cpCell setContent:LocalizeString(@"CHINESE") isChecked:[nowLan isEqualToString:EN]?NO:YES];
    }
    
    return cpCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CounterPriceViewCell *cpCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (!cpCell.isChecked) {
        NSString *msg = [NSString stringWithFormat:@"%@%@?",LocalizeString(@"SWITHCHLANGUAGE"),indexPath.row == 0?LocalizeString(@"ENGLISH"):LocalizeString(@"CHINESE")];
        
        UIAlertAction *okBtn = [UIAlertAction actionWithTitle:LocalizeString(@"ALERT_CONFIRM") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[LanguageTool sharedInstance]changeNowLanguage]; //切换语言
        }];
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:LocalizeString(@"ALERT_CANCEL") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [self showAlert:LocalizeString(@"LANGUAGE") withMsg:msg withActions:@[okBtn,cancelBtn]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
