//
//  SecurityViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "SecurityViewController.h"
#import "BindingMobileViewController.h"
#import "BindingMailBoxViewController.h"
#import "SetFCodeViewController.h"

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

- (IBAction)tapToVerify:(UIButton*)btn{
    UIViewController *cV = [[UIViewController alloc]init];
    switch (btn.tag) {
        case 0:{
            BindingMobileViewController *bMobileVc = [[BindingMobileViewController alloc]initWithNibName:@"BindingMobileViewController" bundle:nil];
            cV = bMobileVc;
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            SetFCodeViewController *sfVc = [[SetFCodeViewController alloc]initWithNibName:@"SetFCodeViewController" bundle:nil];
            cV = sfVc;
        }
            
            break;
        case 3:{
            BindingMailBoxViewController *bMailVc = [[BindingMailBoxViewController alloc]initWithNibName:@"BindingMailBoxViewController" bundle:nil];
            cV = bMailVc;
        }
            
            break;
            
        default:
            break;
    }
    [self homeDefaultPushController:cV];
}

- (void)homeDefaultPushController:(UIViewController*)cV{
    cV.jz_navigationBarHidden = NO;
    [cV setJz_navigationBarTintColor:[UIColor blackColor]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:cV animated:YES];
}


@end
