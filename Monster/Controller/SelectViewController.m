//
//  SelectViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/27.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "SelectViewController.h"
#import "CounterPriceViewCell.h"

@interface SelectViewController ()
@property(nonatomic,strong)NSString* nowSetting;
@end

@implementation SelectViewController

static NSString *counterPriceCellIdentifier = @"CounterPriceCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计价方式";
    [self initial];
}

- (void)initial{
    _nowSetting = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    [self registerCells];
}

- (void)registerCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CounterPriceViewCell" bundle:nil] forCellReuseIdentifier:counterPriceCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *latestSet = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    
    if (![_nowSetting isEqualToString:latestSet]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:RELOAD_AFTERSETTING];
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CounterPriceViewCell *cpCell = (CounterPriceViewCell *)[tableView dequeueReusableCellWithIdentifier:counterPriceCellIdentifier];
    
    NSString *isRmb = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTCURRENCY];
    
    if (indexPath.row == 0) {
        
        [cpCell setContent:@"人民币 (RMB)" isChecked:[isRmb isEqualToString:CNY]?YES:NO];
    } else {
        [cpCell setContent:@"美元 (USD)" isChecked:[isRmb isEqualToString:USD]?YES:NO];
    }
    
    return cpCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:CNY forKey:DEFAULTCURRENCY];
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:USD forKey:DEFAULTCURRENCY];
    }
    [self.tableView reloadData];
    
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
