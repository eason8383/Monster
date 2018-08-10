//
//  LoginViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//




#import "LoginViewController.h"
#import "GoogleAuthVerifyVC.h"

#define BGCOLORCODE @"4E2CE0"

@interface LoginViewController () <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)IBOutlet UITextField *mobileNo_field;
@property(nonatomic,strong)IBOutlet UITextField *vCodeOrPsw_field;
@property(nonatomic,strong)IBOutlet UIButton *verify_btn;
@property(nonatomic,strong)IBOutlet UIButton *login_btn;

@property(nonatomic,strong)IBOutlet UIButton *area_btn;
@property(nonatomic,strong)IBOutlet UIView *mobileNo_udLine;
@property(nonatomic,strong)IBOutlet UIView *verifyCode_udLine;

@property(nonatomic,strong)IBOutlet UILabel *swithLoginWay_Label;
@property(nonatomic,strong)IBOutlet UIButton *swithLoginWay_btn;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint *vBaseLine_distance;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint *bottom_distance;

@property(nonatomic,strong)IBOutlet UILabel *welComeLabel;

@property(nonatomic,assign)float keyboardHeight;
@property(nonatomic, copy) LoginHandler loginHandler;
@property UITapGestureRecognizer *tapRecognizer;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillText];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(firstResponder:)];
//    _tapRecognizer.delegate = self;
    _tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entringMainPage) name:PASSTHEAUTH object:nil];
    
    [self isLoginBtnReadyToGo:NO];
    
    [self registNotifications];
    
}

- (void)fillText{
//    [_welComeLabel setText:NSLocalizedString(@"WELCOME_TITLE", comment:@"")];
//    "USEVERIFYCODELOGIN" = "使用验证码登录";
//    "USEPSWLOGIN" = "使用密码登录";
    
    
    [self.swithLoginWay_Label setText:self.verify_btn.hidden?LocalizeString(@"USEVERIFYCODELOGIN"):LocalizeString(@"USEPSWLOGIN")];
    [_welComeLabel setText:LocalizeString(@"WELCOME_TITLE")];
    [_mobileNo_field setPlaceholder:LocalizeString(@"MOBILE_NUMBER")];
    [_vCodeOrPsw_field setPlaceholder:_verify_btn.hidden?LocalizeString(@"PSWPLACEHOLDER"):LocalizeString(@"SMS_VERIFY_CODE")];
    [_verify_btn setTitle:LocalizeString(@"GET_VERIFY_CODE") forState:UIControlStateNormal];
    [_login_btn setTitle:LocalizeString(@"LOGIN") forState:UIControlStateNormal];
}

- (void)loadView{
    [super loadView];
    
    [self mobileNoGetResponder:NO];
    [self verifyCodeGetResponder:NO];
    
    _verify_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    _verify_btn.layer.borderWidth = 1;
    _verify_btn.layer.cornerRadius = 4;
    
    _login_btn.alpha = 0.6;
    _login_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    _login_btn.layer.borderWidth = 1;
    _login_btn.layer.cornerRadius = 4;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)registNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    
    //取得鍵盤高度
//    NSValue * value = [[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey];
//    _keyboardHeight = [value CGRectValue].size.height - 36;//36 是與底部距離
    
    CGRect keyboardFrameBeginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _keyboardHeight = keyboardFrameBeginRect.size.height - 50;//36 是與底部距離
    
//    NSLog(@"keyboardWillShow %f",_keyboardHeight);
    
}

- (void)keyboardWillhide:(NSNotification*)notification{
    self.bottom_distance.constant = 58;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutSubviews];
    }];
//    NSLog(@"keyboardWillhide");
    
}

- (void)mobileNoGetResponder:(BOOL)isBecomeRp{

    _mobileNo_field.alpha = isBecomeRp?1:0.6;
    _mobileNo_udLine.alpha = isBecomeRp?1:0.6;
    [_mobileNo_field setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)verifyCodeGetResponder:(BOOL)isBecomeRp{
    
    _vCodeOrPsw_field.alpha = isBecomeRp?1:0.6;
    _verifyCode_udLine.alpha = isBecomeRp?1:0.6;
    _verify_btn.alpha = isBecomeRp?1:0.6;
    [_vCodeOrPsw_field setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)isLoginBtnReadyToGo:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        [_login_btn setTitleColor:[UIColor colorWithHexString:BGCOLORCODE] forState:UIControlStateNormal];
        _login_btn.backgroundColor = [UIColor whiteColor];
        _login_btn.alpha = 1.0;
    } else {
        [_login_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _login_btn.backgroundColor = [UIColor colorWithHexString:BGCOLORCODE];
        _login_btn.alpha = 0.6;
    }
    _login_btn.enabled = isGoodToGo;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self performSelector:@selector(move) withObject:nil afterDelay:0.2];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 11) { //11 is mobileNo_field
        [self mobileNoGetResponder:YES];
        [self verifyCodeGetResponder:NO];
    } else {
        [self mobileNoGetResponder:NO];
        [self verifyCodeGetResponder:YES];
    }
}

- (void)move{
    self.bottom_distance.constant = kScreenHeight==568?120 + 58:self.keyboardHeight + 58;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 11) {
        [_mobileNo_field resignFirstResponder];
        [_vCodeOrPsw_field becomeFirstResponder];
    } else {
        if (_login_btn.enabled) {
            [self doLogin:nil];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [textField setText:text];
    
    if (_mobileNo_field.text.length > 0 && _vCodeOrPsw_field.text.length > 0) {
        [self isLoginBtnReadyToGo:YES];
    } else {
        [self isLoginBtnReadyToGo:NO];
    }
    
    return NO;
}

- (void)firstResponder:(id)sender{
    [_mobileNo_field resignFirstResponder];
    [_vCodeOrPsw_field resignFirstResponder];
    [self mobileNoGetResponder:NO];
    [self verifyCodeGetResponder:NO];
}

- (IBAction)getVerifyCode:(id)sender{
    [_vCodeOrPsw_field becomeFirstResponder];
//    NSString *mobNo = _mobileNo_field.text;
    
    NSString *mobNo = [NSString stringWithFormat:@"%@%@",_area_btn.titleLabel.text,_mobileNo_field.text];
    if (_mobileNo_field.text && _mobileNo_field.text.length > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [[MRWebClient sharedInstance]getVerifyCode:mobNo sceneCode:@"001" success:^(id response) {
                NSDictionary *dic = response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[dic objectForKey:@"success"] integerValue] == 1) {
                        
                        //倒數60秒
                        [self receiveCheckNumButton:[NSNumber numberWithInt:60]];

                    } else {
                        NSString *str = [dic objectForKey:@"respMessage"];
                        NSArray *errorAry = [str componentsSeparatedByString:@","];
                        [self justShowAlert:LocalizeString(@"ERROR") message:[errorAry objectAtIndex:0]];
                    }
                });

                NSLog(@"response:%@",response);

            } failure:^(NSError *error) {
                //失敗
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self justShowAlert:LocalizeString(@"NEWWORKERROR") message:[error.userInfo objectForKey:@"ErrorMsg"]];
                });
            }];

        });
    } else {
        [self justShowAlert:LocalizeString(@"ERROR") message:LocalizeString(@"PLEASE_INPUT_MOBILENO")];
    }
}

- (IBAction)doLogin:(id)sender{

    NSString *mobNo = [NSString stringWithFormat:@"%@%@",_area_btn.titleLabel.text,_mobileNo_field.text];
    NSString *vrcOrPswStr = _vCodeOrPsw_field.text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.verify_btn.hidden) {
            [self doLogonWithPsw:mobNo password:vrcOrPswStr];
        } else {
            [self doLogonWithVcode:mobNo verifyCode:vrcOrPswStr];
        }
    });
}

- (void)doLogonWithVcode:(NSString*)mobileNo verifyCode:(NSString*)verifyCode{
    [[MRWebClient sharedInstance]loginWithMobileNo:mobileNo verifyCode:verifyCode success:^(id response) {
        
        MRUserAccount *userInfo = [MRWebClient sharedInstance].userAccount;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (userInfo.success) {
                [self entringMainPage];
            } else {
                [self justShowAlert:@"" message:userInfo.respMessage];
            }
        });
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //登录失败
        dispatch_async(dispatch_get_main_queue(), ^{
            [self justShowAlert:@"" message:[error.userInfo objectForKey:@"ErrorMsg"]];
        });
    }];
}

- (void)doLogonWithPsw:(NSString*)mobileNo password:(NSString*)psw{
    [[MRWebClient sharedInstance]loginWithMobileNo:mobileNo password:psw success:^(id response) {
        
        MRUserAccount *userInfo = [MRWebClient sharedInstance].userAccount;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (userInfo.success) {
                [self entringMainPage];
            } else {
                [self justShowAlert:@"" message:userInfo.respMessage];
            }
        });
        NSLog(@"response:%@",response);
        
    } failure:^(NSError *error) {
        //登录失败
        dispatch_async(dispatch_get_main_queue(), ^{
            [self justShowAlert:@"" message:[error.userInfo objectForKey:@"ErrorMsg"]];
        });
    }];
}

- (void)entringMainPage{
    MRUserAccount *userInfo = [MRWebClient sharedInstance].userAccount;
    self.loginHandler(userInfo.sessionId);
}

- (void)setLoginHandler:(LoginHandler)loginHandler{
    _loginHandler = loginHandler;
}

- (void)receiveCheckNumButton:(NSNumber*)second{
    
    if ([second integerValue] == 0) {
    
        _verify_btn.userInteractionEnabled=YES;
        
        [_verify_btn setTitle:LocalizeString(@"RESEND_VERIFY_CODE") forState:UIControlStateNormal];
    } else {
        
        _verify_btn.userInteractionEnabled = NO;
        
        int i = [second intValue];
        
        [_verify_btn setTitle:[NSString stringWithFormat:@"%is%@",i,LocalizeString(@"RESEND")] forState:UIControlStateNormal];
        
        [self performSelector:@selector(receiveCheckNumButton:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}

- (IBAction)areaChoice:(id)sender{
    
        UIAlertAction *usAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"+1 (%@)",LocalizeString(@"AMERICAN")] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
            [self.area_btn setTitle:@"+1" forState:UIControlStateNormal];
        }];
        UIAlertAction *chinaAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"+86 (%@)",LocalizeString(@"CHINA")] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.area_btn setTitle:@"+86" forState:UIControlStateNormal];
        }];

        [self showActionSheet:@"" message:@"" withActions:@[usAction,chinaAction]];
}

- (IBAction)swithLoginWay:(id)sender{
    
    _vBaseLine_distance.constant = (_vBaseLine_distance.constant == 25)?-85:25;
    
    [UIView animateWithDuration:0.6
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         if (self.vBaseLine_distance.constant != 25) {
                             self.verify_btn.hidden = YES;
                         }
                         [self.view layoutSubviews];
                         
                     }
                     completion:^(BOOL finished) {
                         if (self.vBaseLine_distance.constant == 25) {
                             self.verify_btn.hidden = NO;
                         }
                         [self.vCodeOrPsw_field setPlaceholder:self.verify_btn.hidden?LocalizeString(@"PSWPLACEHOLDER"):LocalizeString(@"SMS_VERIFY_CODE")];
                         [self.swithLoginWay_Label setText:self.verify_btn.hidden?LocalizeString(@"USEVERIFYCODELOGIN"):LocalizeString(@"USEPSWLOGIN")];
                     }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

@end
