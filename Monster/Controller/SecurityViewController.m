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
#import "GoogleAuthViewController.h"
#import "SetPswViewController.h"
//#import "JZNavigationExtension.h"

@interface SecurityViewController ()

@property(nonatomic,strong)IBOutlet UIButton *tideMobileBtn;
@property(nonatomic,strong)IBOutlet UIButton *tideGoogleBtn;
@property(nonatomic,strong)IBOutlet UIButton *tideAssetBtn;
@property(nonatomic,strong)IBOutlet UIButton *tideMailBoxBtn;
@property(nonatomic,strong)IBOutlet UIButton *pswBtn;

@property(nonatomic,strong)IBOutlet UILabel *tideMobileLabel;
@property(nonatomic,strong)IBOutlet UILabel *tideGoogleLabel;
@property(nonatomic,strong)IBOutlet UILabel *tideAssetLabel;
@property(nonatomic,strong)IBOutlet UILabel *tideMailBoxLabel;
@property(nonatomic,strong)IBOutlet UILabel *pswLabel;

@property(nonatomic,strong)IBOutlet UILabel *pswLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *mobileLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *googleLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *assetLabel_title;
@property(nonatomic,strong)IBOutlet UILabel *mailBoxLabel_title;

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizeString(@"SECURYTY");
    
    [_mobileLabel_title setText:LocalizeString(@"BINDINGPHONE")];
    [_googleLabel_title setText:LocalizeString(@"GOOGLEAUTH")];
    [_assetLabel_title setText:LocalizeString(@"FUNDPSW")];
    [_mailBoxLabel_title setText:LocalizeString(@"LINKYOUREMAIL")];
    [_pswLabel_title setText:LocalizeString(@"SETUPPSW")];
    
    [self initial];
}

- (void)initial{
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    BOOL googleAuthIsBinding = [[NSUserDefaults standardUserDefaults]boolForKey:GOOGLE_AUTH_BINDING];
    
    NSString *binding = [NSString stringWithFormat:@"%@>",LocalizeString(@"BINDING")];
    NSString *noBind = [NSString stringWithFormat:@"%@>",LocalizeString(@"BINDINYET")];
    
    [_tideGoogleLabel setText:googleAuthIsBinding?binding:noBind];
    if (googleAuthIsBinding) {
        _tideGoogleBtn.enabled = NO;
    }
    [_tideMobileLabel setText:[MRWebClient sharedInstance].userAccount.mobileNo];
//    NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:EMAIL_BINDING];
    
    [_pswLabel setText:[NSString stringWithFormat:@"%@>",LocalizeString(@"SETTINGS")]];
    [_tideAssetLabel setText:[NSString stringWithFormat:@"%@>",LocalizeString(@"FIX")]];
    
    MRUserAccount *userAccount = [MRWebClient sharedInstance].userAccount;
    if (userAccount.userEmail.length > 0) {
        [_tideMailBoxLabel setText:userAccount.userEmail];
        _tideMailBoxBtn.enabled = NO; //绑定后不能更改
    } else {
        [_tideMailBoxLabel setText:[NSString stringWithFormat:@"%@>",LocalizeString(@"SETTINGS")]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (IBAction)tapToVerify:(UIButton*)btn{
    UIViewController *cV = [[UIViewController alloc]init];
    switch (btn.tag) {
        case 0:{
//            BindingMobileViewController *bMobileVc = [[BindingMobileViewController alloc]initWithNibName:@"BindingMobileViewController" bundle:nil];
//            cV = bMobileVc;
        }
            break;
        case 1:{
            SetPswViewController *pswVC = [[SetPswViewController alloc]initWithNibName:@"SetPswViewController" bundle:nil];
            cV = pswVC;
        }
            break;
        case 2:{
            GoogleAuthViewController *googleVc = [[GoogleAuthViewController alloc]initWithNibName:@"GoogleAuthViewController" bundle:nil];
            cV = googleVc;
        }
            
            break;
        case 3:{
            SetFCodeViewController *sfVc = [[SetFCodeViewController alloc]initWithNibName:@"SetFCodeViewController" bundle:nil];
            cV = sfVc;
        }
        case 4:{
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
//    cV.jz_navigationBarHidden = NO;
//    [cV setJz_navigationBarTintColor:[UIColor blackColor]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:cV animated:YES];
}


@end
