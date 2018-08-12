//
//  SetFCodeViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "SetFCodeViewController.h"
#import "updatePswViewModel.h"

@interface SetFCodeViewController () <UITextFieldDelegate,updatePswDelegate>
@property(nonatomic,strong)IBOutlet UITextField *foundPsw_Field;
@property(nonatomic,strong)IBOutlet UITextField *conFirmCode_Field;
@property(nonatomic,strong)IBOutlet UITextField *smsVerify_Field;

@property(nonatomic,strong)IBOutlet UIButton *smsVerify_Btn;
@property(nonatomic,strong)IBOutlet UIButton *confirm_Btn;

@property(nonatomic,strong)IBOutlet UILabel *fundPswLabel;
@property(nonatomic,strong)IBOutlet UILabel *fundPswConfirmLabel;
@property(nonatomic,strong)IBOutlet UILabel *smsVerifyLabel;


@property(nonatomic,strong)updatePswViewModel *udPswViewModel;
@property(nonatomic,strong)UITapGestureRecognizer *tapRecognizer;

@end

@implementation SetFCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizeString(@"SETFUNDPSW");
    
    [self fillText];
    [self initial];
}

- (void)fillText{
    [_fundPswLabel setText:LocalizeString(@"FUNDPSW")];
    [_fundPswConfirmLabel setText:LocalizeString(@"CONFIRMFUNDPASSWORD")];
    [_smsVerifyLabel setText:LocalizeString(@"SMSVERIFYCODE")];
    [_smsVerify_Btn setTitle:LocalizeString(@"GET_VERIFY_CODE") forState:UIControlStateNormal];
    [_smsVerify_Field setPlaceholder:LocalizeString(@"PLEASEENTERVERIFYCODE")];
    [_foundPsw_Field setPlaceholder:LocalizeString(@"FUNDPSWPLACEHOLDER")];
    [_conFirmCode_Field setPlaceholder:LocalizeString(@"FUNDCONFIRMPLACEHOLDER")];
    [_confirm_Btn setTitle:LocalizeString(@"ALERT_SUBMIT") forState:UIControlStateNormal];
}

- (void)initial{
    
    _udPswViewModel = [updatePswViewModel sharedInstance];
    _udPswViewModel.delegate = self;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [_foundPsw_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_conFirmCode_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_smsVerify_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    
    _smsVerify_Btn.layer.borderColor = [UIColor colorWithHexString:@"3A29AD"].CGColor;
    _smsVerify_Btn.layer.borderWidth = 1;
    _smsVerify_Btn.layer.cornerRadius = 8;
    
    _confirm_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    _confirm_Btn.layer.borderWidth = 1;
    _confirm_Btn.layer.cornerRadius = 4;
    
    _tapRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(firstResponder:)];
    //    _tapRecognizer.delegate = self;
    _tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapRecognizer];
}

- (void)firstResponder:(id)sender{
    [_foundPsw_Field resignFirstResponder];
    [_conFirmCode_Field resignFirstResponder];
    [_smsVerify_Field resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [textField setText:text];
    
    if (_foundPsw_Field.text.length > 0 && _conFirmCode_Field.text.length > 0 && _smsVerify_Field.text.length) {
        [self isUpdatReady:YES];
    } else {
        [self isUpdatReady:NO];
    }
    
    return NO;
}

- (void)isUpdatReady:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        [_confirm_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirm_Btn.backgroundColor = [UIColor colorWithHexString:@"402DDB"];
        _confirm_Btn.layer.borderColor = [UIColor colorWithHexString:@"402DDB"].CGColor;
        _confirm_Btn.alpha = 1.0;
    } else {
        [_confirm_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirm_Btn.backgroundColor = [UIColor clearColor];
        _confirm_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        _confirm_Btn.alpha = 0.6;
    }
    _confirm_Btn.enabled = isGoodToGo;
}

- (IBAction)commitUpdate:(id)sender{
    if (![self checkPswForm:_foundPsw_Field.text]) {
        [self justShowAlert:LocalizeString(@"ERROR") message:LocalizeString(@"FUNDPSWPLACEHOLDER")];
    } else if(![_foundPsw_Field.text isEqualToString:_conFirmCode_Field.text]){
        [self justShowAlert:LocalizeString(@"ERROR") message:LocalizeString(@"CONFIRMPSWISNOTTHESAME")];
    } else {
        [[VWProgressHUD shareInstance]showLoading];
        [_udPswViewModel updateFundPsw:_foundPsw_Field.text verifyCode:_smsVerify_Field.text];
    }
}

- (BOOL)checkPswForm:(NSString*)psw{
    NSString *phoneRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:psw];

    return matches;
}

- (void)updateFundPswSuccess:(NSDictionary *)udInfo{
    [[VWProgressHUD shareInstance]dismiss];
    
    NSMutableArray *actions = [NSMutableArray array];
    
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:LocalizeString(@"ALERT_CONFIRM") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [actions addObject:comfirmAction];
    [self showAlert:LocalizeString(@"SUCCESS") withMsg:LocalizeString(@"UPDATEPSWSUCCESS") withActions:actions];
}

- (void)updateFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    [self dealWithErrorMsg:error];
}

- (IBAction)getVerifyCode:(id)sender{
    [_smsVerify_Field becomeFirstResponder];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mobileNo = [MRWebClient sharedInstance].userAccount.mobileNo;
            [[MRWebClient sharedInstance]getVerifyCode:mobileNo sceneCode:@"002" success:^(id response) {
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
}

- (void)receiveCheckNumButton:(NSNumber*)second{
    
    if ([second integerValue] == 0) {
        
        _smsVerify_Btn.userInteractionEnabled=YES;
        
        [_smsVerify_Btn setTitle:LocalizeString(@"RESEND_VERIFY_CODE") forState:UIControlStateNormal];
    } else {
        
        _smsVerify_Btn.userInteractionEnabled = NO;
        
        int i = [second intValue];
        
        [_smsVerify_Btn setTitle:[NSString stringWithFormat:@"%is%@",i,LocalizeString(@"RESEND")] forState:UIControlStateNormal];
        
        [self performSelector:@selector(receiveCheckNumButton:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}

- (void)dealWithErrorMsg:(NSError*)error{
    NSDictionary *dic = error.userInfo;
    NSDictionary *respCode = [dic objectForKey:@"respCode"];
    if ([[respCode objectForKey:@"code"]isEqualToString:@"00207"]) {
        [self justShowAlert:LocalizeString(@"LOGIN_SESSION_FAILE") message:LocalizeString(@"LOGIN_AGAIN")];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    } else {
        NSString *str = [dic objectForKey:@"respMessage"];
        NSArray *errorAry = [str componentsSeparatedByString:@","];
        [self justShowAlert:LocalizeString(@"ERROR") message:[errorAry objectAtIndex:0]];
    }
}

@end
