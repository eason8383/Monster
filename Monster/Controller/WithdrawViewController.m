//
//  WithdrawViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "WithdrawViewController.h"
#import "CAWViewModel.h"

@interface WithdrawViewController () <CAWViewModelDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)IBOutlet UITextField *units_Field;
@property(nonatomic,strong)IBOutlet UITextField *walletAdds_Field;
@property(nonatomic,strong)IBOutlet UITextField *verify_Field;
@property(nonatomic,strong)IBOutlet UITextField *tradePsw_Field;
@property(nonatomic,strong)IBOutlet UILabel *currencyLabel;

@property(nonatomic,strong)IBOutlet UIButton *currency_Btn;
@property(nonatomic,strong)IBOutlet UIButton *scan_Btn;
@property(nonatomic,strong)IBOutlet UIButton *verify_Btn;
@property(nonatomic,strong)IBOutlet UIButton *confirm_Btn;
@property(nonatomic,strong)IBOutlet UILabel *googleLabel;
@property(nonatomic,strong)IBOutlet UITextField *googleField;
@property(nonatomic,assign)BOOL hasGoogleAuth;
@property(nonatomic,strong)UITableView *coinTableView;
@property(nonatomic,strong)CAWViewModel *cawViewModel;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@property UITapGestureRecognizer *tapRecognizer;
@property(nonatomic,strong)NSArray *coinArray;
@property(nonatomic,strong)NSString *nowCoin;
//@"005"
@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提币";
    
    [self initial];
}

- (void)initial{
    _cawViewModel = [CAWViewModel sharedInstance];
    _cawViewModel.delegate = self;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [_units_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_walletAdds_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_verify_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_googleField setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_tradePsw_Field setValue:[UIColor colorWithWhite:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    
    _verify_Btn.layer.borderColor = [UIColor colorWithHexString:@"3A29AD"].CGColor;
    _verify_Btn.layer.borderWidth = 1;
    _verify_Btn.layer.cornerRadius = 8;
    
    _confirm_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    _confirm_Btn.layer.borderWidth = 1;
    _confirm_Btn.layer.cornerRadius = 4;
    
    _hasGoogleAuth = [[NSUserDefaults standardUserDefaults]boolForKey:GOOGLE_AUTH_BINDING];
    
    _googleField.hidden = !_hasGoogleAuth;
    _googleLabel.hidden = !_hasGoogleAuth;
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(firstResponder:)];
    //    _tapRecognizer.delegate = self;
    _tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapRecognizer];
    
    _coinArray = @[@"ETH",@"MR",@"MON"];
    NSString *nCoin = [[NSUserDefaults standardUserDefaults]objectForKey:CHARGENOWCOIN_WITHDREW];
    if (nCoin.length > 0) {
        _nowCoin = nCoin;
    } else {
        _nowCoin = @"ETH";
    }
    [_currencyLabel setText:_nowCoin];
    [_currency_Btn addTarget:self action:@selector(coinTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.coinTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fillWalletAddress:) name:FILLWALLETADDRESS object:nil];
}

- (void)fillWalletAddress:(NSNotification*)noti{
    NSString *walletAddress = noti.object;
    [_walletAdds_Field setText:walletAddress];
}

- (void)firstResponder:(id)sender{
    [_units_Field resignFirstResponder];
    [_walletAdds_Field resignFirstResponder];
    [_verify_Field resignFirstResponder];
    [_googleField resignFirstResponder];
}

- (IBAction)commitApply:(id)sender{
    [[VWProgressHUD shareInstance]showLoading];
    NSString *googleAuthCode = @"";
    if (_hasGoogleAuth) {
        googleAuthCode = _googleField.text;
    }
    NSDictionary *commitInfo = @{
                                 @"verifyCode":_verify_Field.text,
                                 @"tradePassword":_tradePsw_Field.text,
                                 @"blockChainType":@1,
                                 @"CoinId":_nowCoin,
                                 @"coinQuantity":_units_Field.text,
                                 @"toAddress":_walletAdds_Field.text,
                                 @"googleAuthCode":googleAuthCode
                                 };
    [_cawViewModel withdrewApply:commitInfo];
}

- (void)withdrewApplySuccess:(NSDictionary *)info{
    [[VWProgressHUD shareInstance]dismiss];
    [self justShowAlert:@"申请成功" message:@"申请提现成功"];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    [self dealWithErrorMsg:error];
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

- (IBAction)getVerifyCode:(id)sender{
    [_verify_Field becomeFirstResponder];

    NSString *mobileNo = [MRWebClient sharedInstance].userAccount.mobileNo;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MRWebClient sharedInstance]getVerifyCode:mobileNo sceneCode:@"005" success:^(id response) {
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
        
        _verify_Btn.userInteractionEnabled=YES;
        
        [_verify_Btn setTitle:@"重新获取" forState:UIControlStateNormal];
    } else {
        
        _verify_Btn.userInteractionEnabled = NO;
        
        int i = [second intValue];
        
        [_verify_Btn setTitle:[NSString stringWithFormat:@"再获取(%is)",i] forState:UIControlStateNormal];
        
        [self performSelector:@selector(receiveCheckNumButton:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [textField setText:text];
    
    if (_units_Field.text.length > 0 && _walletAdds_Field.text.length > 0 && _verify_Field.text.length > 0 && _tradePsw_Field.text.length > 0) {
        [self isAuthReadyToGo:YES];
    } else {
        [self isAuthReadyToGo:NO];
    }
    
    return NO;
}

- (void)isAuthReadyToGo:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        
        _confirm_Btn.backgroundColor = [UIColor colorWithHexString:@"402DDB"];
        _confirm_Btn.alpha = 1.0;
    } else {
        
        _confirm_Btn.backgroundColor = [UIColor clearColor];
        _confirm_Btn.alpha = 0.6;
    }
    _confirm_Btn.enabled = isGoodToGo;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if (height != nil) {
        return height.floatValue;
    } else {
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    [tableViewCell setBackgroundColor:[UIColor blackColor]];
    NSString *coinName = [_coinArray objectAtIndex:indexPath.row];
    [tableViewCell.textLabel setText:coinName];
    [tableViewCell.textLabel setTextColor:[UIColor whiteColor]];
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *coinStr = [_coinArray objectAtIndex:indexPath.row];
    [_currencyLabel setText:coinStr];
    [[NSUserDefaults standardUserDefaults]setObject:coinStr forKey:CHARGENOWCOIN_WITHDREW];
    [self coinTableView:nil];
}

- (void)coinTableView:(id)sender{
    CGRect frame;
    float bottomFix = isiPhoneX?88:44;
    if (_coinTableView.height == 0) {
        _tapRecognizer.enabled = NO;
        frame = CGRectMake(0, bottomFix + 100, kScreenWidth, kScreenHeight - 50 + 5 - bottomFix);
    } else {
        _tapRecognizer.enabled = YES;
        frame = CGRectMake(0, bottomFix + 100, kScreenWidth, 0);
    }
    //    if (self.coinTableView.height == 0) {
    //        [self.tradeView titleDownBtnAnticlockwiseRotation];
    //    } else {
    //        [self.tradeView titleDownBtnclockwiseRotation];
    //    }
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.coinTableView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             
                         }];
                     }];
}

- (UITableView *)coinTableView{
    if (_coinTableView == nil) {
        
        float bottomFix = isiPhoneX?88:44;
        CGRect frame = CGRectMake(0, bottomFix + 100, kScreenWidth, 0);
        _coinTableView = [[UITableView alloc] initWithFrame:frame
                                                      style:UITableViewStylePlain];
        _coinTableView.backgroundColor = [UIColor colorWithHexString:@"212025"];
        _coinTableView.rowHeight = UITableViewAutomaticDimension;
        _coinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _coinTableView.estimatedRowHeight = 100;
        
        _coinTableView.delegate = self;
        _coinTableView.dataSource = self;
    }
    return _coinTableView;
}

@end
