//
//  BindingMailBoxViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "BindingMailBoxViewController.h"
#import "IdentityViewModel.h"

@interface BindingMailBoxViewController ()<UITextFieldDelegate,IdentityViewModelDelegate>

@property(nonatomic,strong)IBOutlet UITextField *mailBox_Field;
@property(nonatomic,strong)IBOutlet UITextField *mailVerify_Field;

@property(nonatomic,strong)IBOutlet UIButton *mailVerify_Btn;
@property(nonatomic,strong)IBOutlet UIButton *confirm_Btn;

@property(nonatomic,strong)IBOutlet UILabel *mailVerify_Label;
@property(nonatomic,strong)IBOutlet UILabel *mailBox_Label;

@property(nonatomic,strong)IdentityViewModel *idViewModel;

@end

@implementation BindingMailBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizeString(@"MAILBIND");
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [_mailBox_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_mailVerify_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    
    _mailVerify_Btn.layer.borderColor = [UIColor colorWithHexString:@"3A29AD"].CGColor;
    _mailVerify_Btn.layer.borderWidth = 1;
    _mailVerify_Btn.layer.cornerRadius = 8;
    
    _confirm_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    _confirm_Btn.layer.borderWidth = 1;
    _confirm_Btn.layer.cornerRadius = 4;
    [self fillText];
    [self initial];
}

- (void)fillText{
    [_mailBox_Label setText:LocalizeString(@"MAILBOX")];
    [_mailBox_Field setPlaceholder:LocalizeString(@"MAILBOXCONFIRM")];
    [_mailVerify_Label setText:LocalizeString(@"MAILVERIFY")];
    [_mailVerify_Field setPlaceholder:LocalizeString(@"PLEASEENTERVERIFYCODE")];
    [_confirm_Btn setTitle:LocalizeString(@"ALERT_SUBMIT") forState:UIControlStateNormal];
    [_mailVerify_Btn setTitle:LocalizeString(@"GET_VERIFY_CODE") forState:UIControlStateNormal];
}

- (void)initial{
    _idViewModel = [IdentityViewModel sharedInstance];
    _idViewModel.delegate = self;
}

- (void)getBindingCodeSuccess:(NSDictionary*)bindingInfo{
    NSLog(@"%@",bindingInfo);
    [[VWProgressHUD shareInstance]dismiss];
    
}

- (IBAction)commitiVerifyAuth{
    if (_mailBox_Field.text.length > 0 && _mailVerify_Field.text.length > 0) {
        [[VWProgressHUD shareInstance]showLoading];
        [_idViewModel userEmailIdentity:_mailBox_Field.text verifyCode:_mailVerify_Field.text];
    } else {
        
        [self justShowAlert:LocalizeString(@"ERROR") message:@"请填入完整信息"];
    }
}

- (IBAction)getVerifyCode:(id)sender{
    if (_mailBox_Field.text.length) {
        [_mailVerify_Field becomeFirstResponder];
        NSString *mailAddress = self.mailBox_Field.text;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[MRWebClient sharedInstance]getVerifyCode:mailAddress sceneCode:@"004" success:^(id response) {
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
        [self justShowAlert:LocalizeString(@"IMCOMPLETE") message:@"请填入邮箱地址"];
    }
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    NSLog(@"Home get data Falid:%@",error.userInfo);
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


- (void)receiveCheckNumButton:(NSNumber*)second{
    
    if ([second integerValue] == 0) {
        
        _mailVerify_Btn.userInteractionEnabled=YES;
        
        [_mailVerify_Btn setTitle:LocalizeString(@"RESEND_VERIFY_CODE") forState:UIControlStateNormal];
    } else {
        
        _mailVerify_Btn.userInteractionEnabled = NO;
        
        int i = [second intValue];
        
        [_mailVerify_Btn setTitle:[NSString stringWithFormat:@"%is%@",i,LocalizeString(@"RESEND")] forState:UIControlStateNormal];
        
        [self performSelector:@selector(receiveCheckNumButton:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}

- (void)userEmailIdentitySuccess:(NSDictionary*)verifyInfo;{
    //Success
    
    MRUserAccount *userAccount = [MRWebClient sharedInstance].userAccount;
    userAccount.userEmail = _mailBox_Field.text;
    [[MRWebClient sharedInstance]saveUserAccount:userAccount];
//    [[NSUserDefaults standardUserDefaults]setObject:_mailBox_Field.text forKey:EMAIL_BINDING];
    [[VWProgressHUD shareInstance]dismiss];
    
    NSMutableArray *actions = [NSMutableArray array];
    
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [actions addObject:comfirmAction];
    [self showAlert:@"邮箱验证" withMsg:@"验证成功" withActions:actions];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [textField setText:text];
    
    if (_mailBox_Field.text.length > 0 && _mailVerify_Field.text.length > 0) {
        [self isReadyToGo:YES];
    } else {
        [self isReadyToGo:NO];
    }
    
    return NO;
}

- (void)isReadyToGo:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        
        _confirm_Btn.backgroundColor = [UIColor colorWithHexString:@"402DDB"];
        _confirm_Btn.alpha = 1.0;
    } else {
        
        _confirm_Btn.backgroundColor = [UIColor clearColor];
        _confirm_Btn.alpha = 0.6;
    }
    _confirm_Btn.enabled = isGoodToGo;
}

@end
