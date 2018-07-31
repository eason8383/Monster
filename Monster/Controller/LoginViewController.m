//
//  LoginViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/2.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "LoginViewController.h"
#import "GoogleAuthVerifyVC.h"

@interface LoginViewController () <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)IBOutlet UITextField *mobileNo_field;
@property(nonatomic,strong)IBOutlet UITextField *verifyCode_field;
@property(nonatomic,strong)IBOutlet UIButton *verify_btn;
@property(nonatomic,strong)IBOutlet UIButton *login_btn;
@property(nonatomic,strong)IBOutlet UIView *mobileNo_udLine;
@property(nonatomic,strong)IBOutlet UIView *verifyCode_udLine;
@property(nonatomic,strong)IBOutlet NSLayoutConstraint *bottom_distance;

@property(nonatomic,assign)float keyboardHeight;
@property(nonatomic, copy) LoginHandler loginHandler;
@property UITapGestureRecognizer *tapRecognizer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(firstResponder:)];
//    _tapRecognizer.delegate = self;
    _tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entringMainPage) name:PASSTHEAUTH object:nil];
    
    [self isLoginBtnReadyToGo:NO];
    
    [self registNotifications];
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
    
    NSLog(@"keyboardWillShow %f",_keyboardHeight);
    
}

- (void)keyboardWillhide:(NSNotification*)notification{
    NSLog(@"keyboardWillhide");
    
}

- (void)mobileNoGetResponder:(BOOL)isBecomeRp{

    _mobileNo_field.alpha = isBecomeRp?1:0.6;
    _mobileNo_udLine.alpha = isBecomeRp?1:0.6;
    [_mobileNo_field setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)verifyCodeGetResponder:(BOOL)isBecomeRp{
    
    _verifyCode_field.alpha = isBecomeRp?1:0.6;
    _verifyCode_udLine.alpha = isBecomeRp?1:0.6;
    _verify_btn.alpha = isBecomeRp?1:0.6;
    [_verifyCode_field setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)isLoginBtnReadyToGo:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        [_login_btn setTitleColor:[UIColor colorWithHexString:@"4E2CE0"] forState:UIControlStateNormal];
        _login_btn.backgroundColor = [UIColor whiteColor];
        _login_btn.alpha = 1.0;
    } else {
        [_login_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _login_btn.backgroundColor = [UIColor colorWithHexString:@"4E2CE0"];
        _login_btn.alpha = 0.6;
    }
    _login_btn.enabled = isGoodToGo;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:2 animations:^{
        if (kScreenHeight == 568) {
            self.bottom_distance.constant -= 120;
        } else {
           self.bottom_distance.constant = 58;
        }
    }];
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
    [UIView animateWithDuration:2 animations:^{
        self.bottom_distance.constant += kScreenHeight==568?120:self.keyboardHeight;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 11) {
        [_mobileNo_field resignFirstResponder];
        [_verifyCode_field becomeFirstResponder];
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
    
    if (_mobileNo_field.text.length > 0 && _verifyCode_field.text.length > 0) {
        [self isLoginBtnReadyToGo:YES];
    } else {
        [self isLoginBtnReadyToGo:NO];
    }
    
    return NO;
}

- (void)firstResponder:(id)sender{
    [_mobileNo_field resignFirstResponder];
    [_verifyCode_field resignFirstResponder];
    [self mobileNoGetResponder:NO];
    [self verifyCodeGetResponder:NO];
}

- (IBAction)getVerifyCode:(id)sender{
    [_verifyCode_field becomeFirstResponder];
    NSString *mobNo = _mobileNo_field.text;
    if ([InputVerifyTool verifyMobileNo:mobNo]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [[MRWebClient sharedInstance]getVerifyCode:mobNo sceneCode:@"001" success:^(id response) {
                NSDictionary *dic = response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([dic objectForKey:@"success"]) {
                        
                        //倒數60秒
                        [self receiveCheckNumButton:[NSNumber numberWithInt:60]];

                    } else {
                        NSDictionary *resDic = [dic objectForKey:@"respCode"];
                        [self justShowAlert:@"" message:[resDic objectForKey:@"desc"]];
                    }
                });

                NSLog(@"response:%@",response);

            } failure:^(NSError *error) {
                //失敗
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self justShowAlert:@"" message:[error.userInfo objectForKey:@"ErrorMsg"]];
                });
            }];

        });
    } else {
        [self justShowAlert:@"输入错误" message:@"请输入正确的电话号码"];
    }
}

- (IBAction)doLogin:(id)sender{
    NSString *mobNo = _mobileNo_field.text;
    NSString *vrCode = _verifyCode_field.text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MRWebClient sharedInstance]loginWithMobileNo:mobNo verifyCode:vrCode success:^(id response) {
            
            MRUserAccount *userInfo = [MRWebClient sharedInstance].userAccount;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (userInfo.success) {
                    
                    //通知appDelegate登入成功
                    BOOL isGoogleBinding = [[NSUserDefaults standardUserDefaults]boolForKey:GOOGLE_AUTH_BINDING];
                    if (isGoogleBinding) {
                        GoogleAuthVerifyVC *gVc = [[GoogleAuthVerifyVC alloc]initWithNibName:@"GoogleAuthVerifyVC" bundle:nil];
//                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:gVc];
                        [self presentViewController:gVc animated:YES completion:nil];
                    } else {
                        [self entringMainPage];
                    }
                    
                } else {
                    
                    NSString *errorMsg = [userInfo.respCode objectForKey:@"respMessage"];
                    NSArray *errorAry = [errorMsg componentsSeparatedByString:@","];
                    [self justShowAlert:@"" message:[errorAry objectAtIndex:0]];
                }
            });
            NSLog(@"response:%@",response);
            
        } failure:^(NSError *error) {
            //登录失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [self justShowAlert:@"" message:[error.userInfo objectForKey:@"ErrorMsg"]];
            });
        }];
        
    });
    
}

- (void)entringMainPage{
//    [MRWebClient sharedInstance].userAccount =
//    self.userAccount = [MRUserAccount accountWithDict:dic];
//    self.userAccount.mobileNo = mobileNo;
//    sessionId = self.userAccount.sessionId;
//
//    //save for auto login
//    [[NSUserDefaults standardUserDefaults]setObject:sessionId forKey:@"sessionId"];
//
//    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.userAccount];
//    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userAccount"];
//#pragma mark
//#pragma mark - 只保存用户信息
//    [self saveUserAccount:self.userAccount];
    
    MRUserAccount *userInfo = [MRWebClient sharedInstance].userAccount;
    self.loginHandler(userInfo.sessionId);
}

- (void)setLoginHandler:(LoginHandler)loginHandler{
    _loginHandler = loginHandler;
}

- (void)receiveCheckNumButton:(NSNumber*)second{
    
    if ([second integerValue] == 0) {
    
        _verify_btn.userInteractionEnabled=YES;
        
        [_verify_btn setTitle:@"重新获取" forState:UIControlStateNormal];
    } else {
        
        _verify_btn.userInteractionEnabled = NO;
        
        int i = [second intValue];
        
        [_verify_btn setTitle:[NSString stringWithFormat:@"%is后获取",i] forState:UIControlStateNormal];
        
        [self performSelector:@selector(receiveCheckNumButton:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

@end
