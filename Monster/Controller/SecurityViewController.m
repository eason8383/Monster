//
//  SecurityViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "SecurityViewController.h"

@interface SecurityViewController ()

@property(nonatomic,strong)IBOutlet UIButton *tideMobileBtn;
@property(nonatomic,strong)IBOutlet UIButton *tideGoogleBtn;
@property(nonatomic,strong)IBOutlet UIButton *tideAssetBtn;
@property(nonatomic,strong)IBOutlet UIButton *tideMailBoxBtn;

@property(nonatomic,strong)IBOutlet UILabel *tideMobileLabel;
@property(nonatomic,strong)IBOutlet UILabel *tideGoogleLabel;
@property(nonatomic,strong)IBOutlet UILabel *tideAssetLabel;
@property(nonatomic,strong)IBOutlet UILabel *tideMailBoxLabel;

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全验证";
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
