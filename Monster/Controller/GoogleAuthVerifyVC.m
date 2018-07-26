//
//  GoogleAuthVerifyVC.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/17.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "GoogleAuthVerifyVC.h"
#import "GoogleViewModel.h"

@interface GoogleAuthVerifyVC () <GoogleViewModelDelegate,UITextFieldDelegate>

@property(nonatomic,strong)GoogleViewModel *googleViewModel;
@property(nonatomic,strong)IBOutlet UITextField *googleAuth_Field;
@property(nonatomic,strong)IBOutlet UIButton *commit_Btn;

@end

@implementation GoogleAuthVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)loadView{
    [super loadView];
    
    _commit_Btn.layer.cornerRadius = 4;
    _commit_Btn.layer.borderColor = [UIColor whiteColor].CGColor;
    _commit_Btn.layer.borderWidth = 1;
    
    [_googleAuth_Field setValue:[UIColor colorWithWhite:1 alpha:0.4] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)initial{
    _googleViewModel = [GoogleViewModel sharedInstance];
    _googleViewModel.delegate = self;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissGoogleConfirm:)];
    cancelBtn.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItem:cancelBtn];
}

- (void)identitySuccess:(NSDictionary *)identityInfo{
    [[VWProgressHUD shareInstance]dismiss];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:LOGINVERIFYWITHGOOGLEAUTH];
    [[NSNotificationCenter defaultCenter]postNotificationName:PASSTHEAUTH object:nil];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    NSDictionary *dic = error.userInfo;
    [self justShowAlert:@"认证错误" message:[dic objectForKey:@"respMessage"]];
}

- (void)dismissGoogleConfirm:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submit:(id)sender{
    [[VWProgressHUD shareInstance]showLoading];
    
    [_googleViewModel identityAuthCode:_googleAuth_Field.text];
    [_googleAuth_Field resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [textField setText:text];
    
    if (_googleAuth_Field.text.length > 0) {
        [self isAuthReadyToGo:YES];
    } else {
        [self isAuthReadyToGo:NO];
    }
    
    return NO;
}

- (void)isAuthReadyToGo:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        
        _commit_Btn.backgroundColor = [UIColor colorWithHexString:@"402DDB"];
        _commit_Btn.alpha = 1.0;
        _commit_Btn.layer.borderColor = [UIColor colorWithHexString:@"402DDB"].CGColor;
    } else {
        _commit_Btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;;
        _commit_Btn.backgroundColor = [UIColor clearColor];
        _commit_Btn.alpha = 0.6;
    }
    _commit_Btn.enabled = isGoodToGo;
}


@end
