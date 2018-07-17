//
//  GoogleAuthVerifyVC.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/17.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "GoogleAuthVerifyVC.h"
#import "GoogleViewModel.h"

@interface GoogleAuthVerifyVC () <GoogleViewModelDelegate>

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

- (void)confirmSuccess:(NSDictionary *)bindingInfo{
    [[VWProgressHUD shareInstance]dismiss];
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
    [_googleViewModel confirmAuthCode:_googleAuth_Field.text verifyCode:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
