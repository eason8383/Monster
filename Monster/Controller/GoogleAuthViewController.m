//
//  GoogleAuthViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/17.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "GoogleAuthViewController.h"
#import "GoogleViewModel.h"

@interface GoogleAuthViewController () <GoogleViewModelDelegate,UITextFieldDelegate>

@property (nonatomic,strong)GoogleViewModel *googleViewModel;

@property (nonatomic,strong)IBOutlet UILabel *authCodeLabel;
@property (nonatomic,strong)IBOutlet UIImageView *qRImgView;
@property (nonatomic,strong)IBOutlet UITextField *verifyField;
@property (nonatomic,strong)IBOutlet UITextField *authCodeField;
@property (nonatomic,strong)IBOutlet UIButton *coppyBtn;
@property (nonatomic,strong)IBOutlet UIButton *gainVerifyBtn;
@property (nonatomic,strong)IBOutlet UIButton *commitBtn;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint *top_distance;

@property(nonatomic,assign)float keyboardHeight;
@property UITapGestureRecognizer *tapRecognizer;

@end

@implementation GoogleAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定谷歌认证";
    
    [self initial];
}

- (void)initial{
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(firstResponder:)];
    //    _tapRecognizer.delegate = self;
    _tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapRecognizer];
    
    _googleViewModel = [GoogleViewModel sharedInstance];
    _googleViewModel.delegate = self;
    [[VWProgressHUD shareInstance]showLoading];
    [_googleViewModel getBindingCode];
    
    [self registNotifications];
}

- (void)loadView{
    [super loadView];
    _coppyBtn.layer.cornerRadius = 4;
    
    _gainVerifyBtn.layer.cornerRadius = 4;
    _gainVerifyBtn.layer.borderColor = [UIColor colorWithHexString:@"4532E4"].CGColor;;
    _gainVerifyBtn.layer.borderWidth = 1;
    
    _commitBtn.layer.cornerRadius = 4;
    _commitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _commitBtn.layer.borderWidth = 1;
    
    [_verifyField setValue:[UIColor colorWithWhite:1 alpha:0.4] forKeyPath:@"_placeholderLabel.textColor"];
    [_authCodeField setValue:[UIColor colorWithWhite:1 alpha:0.4] forKeyPath:@"_placeholderLabel.textColor"];
    
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:2 animations:^{
//        self.top_distance.constant += kScreenHeight==568?180:self.keyboardHeight;
        self.top_distance.constant += self.keyboardHeight;
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self performSelector:@selector(move) withObject:nil afterDelay:0.2];
    return YES;
}

- (void)move{
    [UIView animateWithDuration:2 animations:^{
//        self.top_distance.constant -= kScreenHeight==568?180:self.keyboardHeight;
        self.top_distance.constant -= self.keyboardHeight;
    }];

}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (textField.tag == 11) {
//        [_verifyField resignFirstResponder];
//        [_authCodeField becomeFirstResponder];
//    } else {
//        if (_commitBtn.enabled) {
//            [self commitiVerifyAuth];
//        }
//    }
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstResponder:(id)sender{
    [_verifyField resignFirstResponder];
    [_authCodeField resignFirstResponder];
}

- (void)getBindingCodeSuccess:(NSDictionary*)bindingInfo{
    NSLog(@"%@",bindingInfo);
    [[VWProgressHUD shareInstance]dismiss];
    [self touchesBegan:[bindingInfo objectForKey:@"oauthUrl"]];
    [_authCodeLabel setText:[bindingInfo objectForKey:@"secret"]];
}

- (IBAction)commitiVerifyAuth{
    if (_authCodeField.text.length > 0 && _verifyField.text.length > 0) {
        [[VWProgressHUD shareInstance]showLoading];
        [_googleViewModel bindingAuthCode:_authCodeField.text verifyCode:_verifyField.text];
    } else {
        [self justShowAlert:@"错误" message:@"请填入正确验证码"];
    }
}

- (IBAction)StartToGetSmsVerifyCode:(id)sender{
    [[VWProgressHUD shareInstance]showLoading];
    [_googleViewModel getSmsVerifyCode];
}

- (void)getSmsVerifyCode:(NSDictionary *)verifyInfo{
    NSLog(@"%@",verifyInfo);
    [[VWProgressHUD shareInstance]dismiss];
    [self receiveCheckNumButton:[NSNumber numberWithInt:60]];
}

- (void)bindingSuccess:(NSDictionary *)bindingInfo{
    //Sucess
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:GOOGLE_AUTH_BINDING];
    [[VWProgressHUD shareInstance]dismiss];
    [self justShowAlert:@"谷歌认证" message:@"绑定成功" handler:^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    NSLog(@"Home get data Falid:%@",error.userInfo);
    NSDictionary *dic = error.userInfo;
    NSDictionary *respCode = [dic objectForKey:@"respCode"];
    if ([[respCode objectForKey:@"code"]isEqualToString:@"00207"]) {
        [self justShowAlert:@"登陆会话无效" message:@"请重新登录"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    } else {
        NSString *str = [dic objectForKey:@"respMessage"];
        NSArray *errorAry = [str componentsSeparatedByString:@","];
        [self justShowAlert:@"错误信息" message:[errorAry objectAtIndex:0]];
    }
}

- (void)touchesBegan:(NSString*)qrCodeStr{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3.二维码信息
    
    // 4.将字符串转成二进制数据
    NSData *data = [qrCodeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    // 5.通过KVC设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 6.获取滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 7.将CIImage转成UIImage
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:222];
    
    // 8.展示二维码
    self.qRImgView.image = image;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (IBAction)copyCode{
    
//    UIImageWriteToSavedPhotosAlbum([self captureScreen:self.qRImgView], nil, nil, nil);
//    [self justShowAlert:@"储存照片" message:@"已储存"];
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = _authCodeLabel.text;
    [pab setString:string];
    [self justShowAlert:@"" message:@"已复制"];
}

- (UIImage *)captureScreen:(UIView*)targetView
{
    UIView* captureView = targetView;
    UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, captureView.opaque, 0.0);
    [captureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cropRect = CGRectMake(0 ,0 ,captureView.frame.size.width ,captureView.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(cropRect.size, captureView.opaque, 1.2f);
    [screenshot drawInRect:cropRect];
    UIImage * customScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return customScreenShot;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [textField setText:text];
    
    if (_authCodeField.text.length > 0 && _verifyField.text.length > 0) {
        [self isAuthReadyToGo:YES];
    } else {
        [self isAuthReadyToGo:NO];
    }
    
    return NO;
}

- (void)receiveCheckNumButton:(NSNumber*)second{
    
    if ([second integerValue] == 0) {
        
        _gainVerifyBtn.userInteractionEnabled=YES;
        
        [_gainVerifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    } else {
        
        _gainVerifyBtn.userInteractionEnabled = NO;
        
        int i = [second intValue];
        
        [_gainVerifyBtn setTitle:[NSString stringWithFormat:@"%is后获取",i] forState:UIControlStateNormal];
        
        [self performSelector:@selector(receiveCheckNumButton:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}

- (void)isAuthReadyToGo:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        _commitBtn.layer.borderColor = [UIColor clearColor].CGColor;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"402DDB"];
        _commitBtn.alpha = 1.0;
    } else {
        _commitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _commitBtn.backgroundColor = [UIColor clearColor];
        _commitBtn.alpha = 0.6;
    }
    _commitBtn.enabled = isGoodToGo;
}

@end
