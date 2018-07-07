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
