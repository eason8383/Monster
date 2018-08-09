//
//  WithdrawViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "WithdrawViewController.h"
#import "CAWViewModel.h"
#import "ScanViewController.h"

@interface WithdrawViewController () <CAWViewModelDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)IBOutlet UITextField *units_Field;
@property(nonatomic,strong)IBOutlet UITextField *walletAdds_Field;
@property(nonatomic,strong)IBOutlet UITextField *verify_Field;
@property(nonatomic,strong)IBOutlet UITextField *tradePsw_Field;
@property(nonatomic,strong)IBOutlet UILabel *currencyLabel;

@property(nonatomic,strong)IBOutlet UIImageView *downBtnView;
@property(nonatomic,strong)IBOutlet UILabel *unit_Label;
@property(nonatomic,strong)IBOutlet UILabel *wFeeExplain_Label;
@property(nonatomic,strong)IBOutlet UIButton *helf_Btn;
@property(nonatomic,strong)IBOutlet UIButton *whole_Btn;

@property(nonatomic,strong)IBOutlet UILabel *chose_Label;
@property(nonatomic,strong)IBOutlet UILabel *amount_Label;
@property(nonatomic,strong)IBOutlet UILabel *fee_Label;
@property(nonatomic,strong)IBOutlet UILabel *foundpsw_Label;
@property(nonatomic,strong)IBOutlet UILabel *address_Label;
@property(nonatomic,strong)IBOutlet UILabel *smsv_Label;

@property(nonatomic,strong)IBOutlet UIButton *currency_Btn;
@property(nonatomic,strong)IBOutlet UIButton *scan_Btn;
@property(nonatomic,strong)IBOutlet UIButton *verify_Btn;
@property(nonatomic,strong)IBOutlet UIButton *confirm_Btn;
@property(nonatomic,strong)IBOutlet UILabel *googleLabel;
@property(nonatomic,strong)IBOutlet UILabel *withdrewFeeLabel;
@property(nonatomic,strong)IBOutlet UITextField *googleField;
@property(nonatomic,assign)BOOL hasGoogleAuth;
@property(nonatomic,strong)UITableView *coinTableView;
@property(nonatomic,strong)CAWViewModel *cawViewModel;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@property UITapGestureRecognizer *tapRecognizer;
@property(nonatomic,strong)NSArray *coinArray;
@property(nonatomic,strong)NSString *nowCoin;
@property(nonatomic,strong)NSString *nowQuantity;
@property(nonatomic,assign)float keyboardHeight;


//@"005"
@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizeString(@"WITHDRAW");
    [self fillText];
    [self initial];
}

- (void)fillText{
    [_chose_Label setText:LocalizeString(@"CHOISEPAIR")];
    
    [_amount_Label setText:LocalizeString(@"AMOUNT")];
    [_units_Field setPlaceholder:LocalizeString(@"AMOUNT_PLACEHOLDER")];
    
    [_whole_Btn setTitle:LocalizeString(@"ALL") forState:UIControlStateNormal];
    
    [_fee_Label setText:LocalizeString(@"WITHDRAWALFEE")];
    
    [_address_Label setText:LocalizeString(@"ADDRESS")];
    [_walletAdds_Field setPlaceholder:LocalizeString(@"ADDRESS_PLACEHOLDER")];
    
    [_smsv_Label setText:LocalizeString(@"VERIFYCODE")];
    [_verify_Field setPlaceholder:LocalizeString(@"SMSCODE_PLACEHOLDER")];
    
    [_foundpsw_Label setText:LocalizeString(@"FOUNDPSW")];
    [_tradePsw_Field setPlaceholder:LocalizeString(@"FOUNDPSWE_PLACEHOLDER")];
    
    [_googleLabel setText:LocalizeString(@"GOOGLEAUTH")];
    [_googleField setPlaceholder:LocalizeString(@"GOOGLEAUTH_PLACEHOLDER")];
    
    [_confirm_Btn setTitle:LocalizeString(@"CONFIRM_WITHDRAW") forState:UIControlStateNormal];
    [_verify_Btn setTitle:LocalizeString(@"GET_VERIFY_CODE") forState:UIControlStateNormal];
//    @property(nonatomic,strong)IBOutlet UILabel *fee_Label;
//    @property(nonatomic,strong)IBOutlet UILabel *foundpsw_Label;
//    @property(nonatomic,strong)IBOutlet UILabel *address_Label;
//    @property(nonatomic,strong)IBOutlet UILabel *smsv_Label;
    
//    "AMOUNT" = "数量";
//    "AMOUNT_PLACEHOLDER" = "请输入提币数量";
//    "AMOUNT_INTRO" = "个起提，当前最多可提取";
//    "ALL" = "全部";
//    "WITHDRAWALFEE" = "提现手续费";
//    "WITHDRAWINTRO" = "单笔提现手续费为";
//    "ADDRESS" = "钱包地址";
//    "ADDRESS_PLACEHOLDER" = "请输入提现的钱包地址或扫描录入";
//    "SMSCODE_PLACEHOLDER" = "请输入验证码";
//    "FOUNDPSW" = "资金密码";
//    "FOUNDPSWE_PLACEHOLDER" = "请输入资金密码";
//    "CONFIRM_WITHDRAW" = "确认提币";
//    "GOOGLEAUTH" = "谷歌验证";
//    "GOOGLEAUTH_PLACEHOLDER" = "请输入谷歌验证码";

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
    
    _helf_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    _helf_Btn.layer.borderWidth = 1;
    _helf_Btn.layer.cornerRadius = 4;
    
    _whole_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    _whole_Btn.layer.borderWidth = 1;
    _whole_Btn.layer.cornerRadius = 4;
    
    _hasGoogleAuth = [[NSUserDefaults standardUserDefaults]boolForKey:GOOGLE_AUTH_BINDING];
    
    _googleField.hidden = !_hasGoogleAuth;
    _googleLabel.hidden = !_hasGoogleAuth;
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(firstResponder:)];
    _tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapRecognizer];
    
    _coinArray = @[@"ETH",@"MR",@"MON"];
    NSString *nCoin = [[NSUserDefaults standardUserDefaults]objectForKey:CHARGENOWCOIN_WITHDREW];
    if (nCoin.length > 0) {
        _nowCoin = nCoin;
    } else {
        _nowCoin = @"ETH";
    }
    [self setWithdrewFee:_nowCoin];
    [_currencyLabel setText:_nowCoin];
    [_currency_Btn addTarget:self action:@selector(coinTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.coinTableView];
    [self registNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fillWalletAddress:) name:FILLWALLETADDRESS object:nil];
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
//    [self.scrollView setContentOffset:CGPointMake(0, keyboardFrameBeginRect.size.height) animated:YES];
    _keyboardHeight = keyboardFrameBeginRect.size.height;
    
    
}

- (void)keyboardWillhide:(NSNotification*)notification{
   
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
   
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    [_scrollView setContentSize:CGSizeMake(kScreenWidth-100, 570)];
}

- (void)setWithdrewFee:(NSString*)nowCoin{
    
//    if ([nowCoin isEqualToString:@"ETH"]) {
//        [_withdrewFeeLabel setText:@"0.01"];
//        [_wFeeExplain_Label setText:[NSString stringWithFormat:@"(%@0.01%@)",LocalizeString(@"WITHDRAWINTRO"),nowCoin]];
//        NSString *coinStr = [_assetInfo objectForKey:@"ETH"]?[_assetInfo objectForKey:@"ETH"]:@"0";
//        _nowQuantity = [NSString stringWithFormat:@"%@",coinStr];
//        [_unit_Label setText:[NSString stringWithFormat:@"(0.01%@%@ETH)",LocalizeString(@"AMOUNT_INTRO"),coinStr]];
//    } else if ([nowCoin isEqualToString:@"MR"]) {
//        [_withdrewFeeLabel setText:@"10"];
//        [_wFeeExplain_Label setText:[NSString stringWithFormat:@"(%@10%@)",LocalizeString(@"WITHDRAWINTRO"),nowCoin]];
//        NSString *coinStr = [_assetInfo objectForKey:@"MR"]?[_assetInfo objectForKey:@"MR"]:@"0";
//        _nowQuantity = [NSString stringWithFormat:@"%@",coinStr];
//        [_unit_Label setText:[NSString stringWithFormat:@"(100%@%@MR)",LocalizeString(@"AMOUNT_INTRO"),coinStr]];
//    } else if ([nowCoin isEqualToString:@"MON"]) {
//        [_withdrewFeeLabel setText:@"500"];
//        [_wFeeExplain_Label setText:[NSString stringWithFormat:@"(%@500%@)",LocalizeString(@"WITHDRAWINTRO"),nowCoin]];
//        NSString *coinStr = [_assetInfo objectForKey:@"MON"]?[_assetInfo objectForKey:@"MON"]:@"0";
//        _nowQuantity = [NSString stringWithFormat:@"%@",coinStr];
//        [_unit_Label setText:[NSString stringWithFormat:@"(1000%@%@MON)",LocalizeString(@"AMOUNT_INTRO"),coinStr]];
//    }
    
    NSString *feeStr = @"";
    NSString *minTradeStr = @"";
    if ([nowCoin isEqualToString:@"ETH"]) {
        feeStr = @"0.01";
        minTradeStr = @"0.01";
    } else if ([nowCoin isEqualToString:@"MR"]) {
        feeStr = @"10";
        minTradeStr = @"100";
    } else if ([nowCoin isEqualToString:@"MON"]) {
        feeStr = @"500";
        minTradeStr = @"1000";
    } else {
        feeStr = @"0.0";
        minTradeStr = @"0.0";
    }
    
    [self setFee:feeStr minTrade:minTradeStr pair:nowCoin];
    
    if (_helf_Btn.selected == YES) {
        [_units_Field setText:[self decimalDividing:_nowQuantity with:@"2"]];
    }
    if (_whole_Btn.selected == YES) {
        [_units_Field setText:_nowQuantity];
    }
}

- (void)setFee:(NSString*)fee minTrade:(NSString*)minStr pair:(NSString*)pair{
    [_withdrewFeeLabel setText:fee];
    [_wFeeExplain_Label setText:[NSString stringWithFormat:@"(%@ %@ %@)",LocalizeString(@"WITHDRAWINTRO"),fee,pair]];
    NSString *coinStr = [_assetInfo objectForKey:pair]?[_assetInfo objectForKey:pair]:@"0";
    _nowQuantity = [NSString stringWithFormat:@"%@",coinStr];
    
    [_unit_Label setText:[NSString stringWithFormat:@"(%@ %@ %@ %@)",minStr,LocalizeString(@"AMOUNT_INTRO"),coinStr,pair]];
}

- (IBAction)tapHelfOrwholeBtn:(UIButton*)btn{
    btn.selected = !btn.selected;
    
    if (btn.tag == 12) {
        [self isBtnSelect:_helf_Btn isSelect:btn.selected];
        if (_whole_Btn.selected == YES) {
            [self isBtnSelect:_whole_Btn isSelect:NO];
        }
        if(_helf_Btn.selected == YES) {
            [_units_Field setText:[self decimalDividing:_nowQuantity with:@"2"]];
        }
        
    } else {
        
        [self isBtnSelect:_whole_Btn isSelect:btn.selected];
        if (_helf_Btn.selected == YES) {
            [self isBtnSelect:_helf_Btn isSelect:NO];
        }
        
        if (_whole_Btn.selected == YES) {
            [_units_Field setText:_nowQuantity];
        }
    }
    
    if (_helf_Btn.selected == NO && _whole_Btn.selected == NO) {
        [_units_Field setText:@""];
    }
}

- (NSString*)decimalDividing:(NSString*)numStr1 with:(NSString*)numStr2{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:numStr1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:numStr2];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundUp
                                       scale:8
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    
    NSDecimalNumber *result = [num1 decimalNumberByDividingBy:num2 withBehavior:roundUp];
    
    return [result stringValue];
}

- (void)titleDownBtnAnticlockwiseRotation{
    
    //逆时针 旋转180度
    _downBtnView.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
    CGAffineTransform transform = _downBtnView.transform;
    transform = CGAffineTransformScale(transform, 1,1);
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         
                         self.downBtnView.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)titleDownBtnclockwiseRotation{
    //顺时针 旋转180度
    
    _downBtnView.transform = CGAffineTransformMakeRotation(0*M_PI/180);
    CGAffineTransform transform = _downBtnView.transform;
    transform = CGAffineTransformScale(transform, 1,1);
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         
                         self.downBtnView.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)isBtnSelect:(UIButton*)btn isSelect:(BOOL)isSelect{
    if (isSelect) {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"3A29AD"]];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        
        btn.alpha = 1;
    } else {
        btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        [btn setBackgroundColor:[UIColor clearColor]];
        
        btn.alpha = 0.4;
    }
    btn.selected = isSelect;
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
    [_tradePsw_Field resignFirstResponder];
}

- (IBAction)commitApply:(id)sender{
    [[VWProgressHUD shareInstance]showLoading];
    NSString *googleAuthCode = _hasGoogleAuth?_googleField.text:@"";
    
    NSDictionary *commitInfo = @{
                                 @"verifyCode":_verify_Field.text,
                                 @"tradePassword":_tradePsw_Field.text,
                                 @"blockChainType":@"1",
                                 @"CoinId":_nowCoin,
                                 @"coinQuantity":_units_Field.text,
                                 @"toAddress":_walletAdds_Field.text,
                                 @"googleAuthCode":googleAuthCode
                                 };
    [_cawViewModel withdrewApply:commitInfo];
}

- (void)withdrewApplySuccess:(NSDictionary *)info{
    [[VWProgressHUD shareInstance]dismiss];
    
    [self justShowAlert:@"申请成功" message:@"申请提现成功" handler:^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    [self dealWithErrorMsg:error];
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
        
        [_verify_Btn setTitle:LocalizeString(@"RESEND_VERIFY_CODE") forState:UIControlStateNormal];
    } else {
        
        _verify_Btn.userInteractionEnabled = NO;
        
        int i = [second intValue];
        
        [_verify_Btn setTitle:[NSString stringWithFormat:@"%is%@",i,LocalizeString(@"RESEND")] forState:UIControlStateNormal];
        
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    float hidePosY = kScreenHeight - _keyboardHeight;
    
    float textFieldPosY = textField.frame.origin.y + textField.frame.size.height +_scrollView.frame.origin.y;
    
    if (hidePosY - textFieldPosY < 0) { //means擋到
        [_scrollView setContentOffset:CGPointMake(0, _keyboardHeight)];
    }
}

- (void)isAuthReadyToGo:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        _confirm_Btn.layer.borderColor = [UIColor clearColor].CGColor;
        _confirm_Btn.backgroundColor = [UIColor colorWithHexString:@"402DDB"];
        _confirm_Btn.alpha = 1.0;
    } else {
        _confirm_Btn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        _confirm_Btn.backgroundColor = [UIColor clearColor];
        _confirm_Btn.alpha = 0.4;
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
    _nowCoin = coinStr;
    [self setWithdrewFee:_nowCoin];
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
                         if (self.coinTableView.height == 0) {
                             [self titleDownBtnclockwiseRotation];
                         } else {
                             [self titleDownBtnAnticlockwiseRotation];
                         }
                     }];
}

- (IBAction)callScanView:(id)sender{
    ScanViewController *scanView = [[ScanViewController alloc]initWithNibName:@"ScanViewController" bundle:nil];
    [self.navigationController pushViewController:scanView animated:YES];
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
