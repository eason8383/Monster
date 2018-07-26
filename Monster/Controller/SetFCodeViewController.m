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

@property(nonatomic,strong)updatePswViewModel *udPswViewModel;
@property(nonatomic,strong)UITapGestureRecognizer *tapRecognizer;

@end

@implementation SetFCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置资金密码";
    
    
    [self initial];
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
    
    if (_foundPsw_Field.text.length > 0 && _conFirmCode_Field.text.length > 0 && _smsVerify_Field.text.length && [_foundPsw_Field.text isEqualToString:_conFirmCode_Field.text]) {
        [self isAuthReadyToGo:YES];
    } else {
        [self isAuthReadyToGo:NO];
    }
    
    return NO;
}

- (void)isAuthReadyToGo:(BOOL)isGoodToGo{
    
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
    [[VWProgressHUD shareInstance]showLoading];
    [_udPswViewModel updatePsw:_foundPsw_Field.text verifyCode:_smsVerify_Field.text];
}

- (void)updateSuccess:(NSDictionary *)udInfo{
    [[VWProgressHUD shareInstance]dismiss];
    
    NSMutableArray *actions = [NSMutableArray array];
    
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [actions addObject:comfirmAction];
    [self showAlert:@"更新成功" withMsg:@"密码更新成功" withActions:actions];
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
        
        [_smsVerify_Btn setTitle:@"重新获取" forState:UIControlStateNormal];
    } else {
        
        _smsVerify_Btn.userInteractionEnabled = NO;
        
        int i = [second intValue];
        
        [_smsVerify_Btn setTitle:[NSString stringWithFormat:@"再获取(%is)",i] forState:UIControlStateNormal];
        
        [self performSelector:@selector(receiveCheckNumButton:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}

- (void)dealWithErrorMsg:(NSError*)error{
    NSDictionary *dic = error.userInfo;
    NSDictionary *respCode = [dic objectForKey:@"respCode"];
    if ([[respCode objectForKey:@"code"]isEqualToString:@"00207"]) {
        [self justShowAlert:@"登陆会话无效" message:@"请重新登录"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    } else {
        [self justShowAlert:@"错误信息" message:[dic objectForKey:@"respMessage"]];
    }
}

@end
