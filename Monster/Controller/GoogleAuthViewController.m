//
//  GoogleAuthViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/17.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "GoogleAuthViewController.h"
#import "GoogleViewModel.h"

@interface GoogleAuthViewController () <GoogleViewModelDelegate>

@property (nonatomic,strong)GoogleViewModel *googleViewModel;

@property (nonatomic,strong)IBOutlet UILabel *authCodeLabel;
@property (nonatomic,strong)IBOutlet UIImageView *qRImgView;
@property (nonatomic,strong)IBOutlet UITextField *verifyField;
@property (nonatomic,strong)IBOutlet UITextField *authCodeField;
@property (nonatomic,strong)IBOutlet UIButton *coppyBtn;
@property (nonatomic,strong)IBOutlet UIButton *gainVerifyBtn;
@property (nonatomic,strong)IBOutlet UIButton *commitBtn;


@end

@implementation GoogleAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定谷歌认证";
    
    [self initial];
}

- (void)initial{
    _googleViewModel = [GoogleViewModel sharedInstance];
    _googleViewModel.delegate = self;
    [[VWProgressHUD shareInstance]showLoading];
    [_googleViewModel getBindingCode];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

- (void)bindingSuccess:(NSDictionary *)bindingInfo{
    //Sucess
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:GOOGLE_AUTH_BINDING];
    [[VWProgressHUD shareInstance]dismiss];
    
    NSMutableArray *actions = [NSMutableArray array];
    
    UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [actions addObject:comfirmAction];
    [self showAlert:@"谷歌认证" withMsg:@"绑定成功" withActions:actions];
    
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
        [self justShowAlert:@"错误信息" message:[dic objectForKey:@"respMessage"]];
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


- (IBAction)savePicture{
    
    UIImageWriteToSavedPhotosAlbum([self captureScreen:self.qRImgView], nil, nil, nil);
    [self justShowAlert:@"储存照片" message:@"已储存"];
    
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

@end
