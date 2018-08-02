//
//  ChargeViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "ChargeViewController.h"
#import "CAWViewModel.h"

@interface ChargeViewController () <CAWViewModelDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)IBOutlet UILabel *currencyLabel;
@property(nonatomic,strong)IBOutlet UIButton *changeCurreyBtn;
@property(nonatomic,strong)IBOutlet UIView *qrBackView;
@property(nonatomic,strong)IBOutlet UIImageView *qrCodeView;
@property(nonatomic,strong)IBOutlet UIImageView *downBtnView;
@property(nonatomic,strong)IBOutlet UIButton *saveQrPicBtn;
@property(nonatomic,strong)IBOutlet UIButton *coAddressBtn;
@property(nonatomic,strong)IBOutlet UILabel *addressLabel;

@property(nonatomic,strong)IBOutlet UIButton *confirmBtn;

@property(nonatomic,strong)UITableView *coinTableView;

@property(nonatomic,strong)NSString *walletAddress;
@property(nonatomic,strong)NSString *walletId;
@property(nonatomic,strong)NSString *nowCoin;
@property(nonatomic,strong)NSArray *coinArray;

@property(nonatomic,strong)CAWViewModel *cawViewModel;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典

@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充币";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self initial];
    
}

- (void)initial{
    
    _saveQrPicBtn.layer.cornerRadius = 4;
    _coAddressBtn.layer.cornerRadius = 4;
    _confirmBtn.layer.cornerRadius = 4;
    
    _qrBackView.layer.borderWidth = 1;
    _qrBackView.layer.borderColor = [UIColor colorWithHexString:@"3F2DDD"].CGColor;
    
    _cawViewModel = [CAWViewModel sharedInstance];
    _cawViewModel.delegate = self;
    
    [_changeCurreyBtn addTarget:self action:@selector(coinTableView:) forControlEvents:UIControlEventTouchUpInside];
    _coinArray = @[@"ETH",@"MR",@"MON"];
    NSString *nCoin = [[NSUserDefaults standardUserDefaults]objectForKey:CHARGENOWCOIN];
    if (nCoin.length > 0) {
        _nowCoin = nCoin;
    } else {
        _nowCoin = @"ETH";
    }
    
    [_currencyLabel setText:_nowCoin];
    [[VWProgressHUD shareInstance]showLoading];
    [_cawViewModel getWallet];
    [self.view addSubview:self.coinTableView];
}

- (void)getWalletSuccess:(NSDictionary *)info{
    NSLog(@"%@",info);
    [[VWProgressHUD shareInstance]dismiss];
    _walletId = [info objectForKey:@"walletId"];
    _walletAddress = [info objectForKey:@"walletAddress"];
    [_addressLabel setText:_walletAddress];
    
    [self touchesBegan:_walletAddress];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    
    [self dealWithErrorMsg:error];
}

- (IBAction)copyAddress:(id)sender{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = _walletAddress;
    [pab setString:string];
    [self justShowAlert:@"" message:@"已复制地址"];
}

- (void)coinTableView:(id)sender{
    CGRect frame;
    float bottomFix = isiPhoneX?78:44;
    if (_coinTableView.height == 0) {
        frame = CGRectMake(0, bottomFix + 100, kScreenWidth, kScreenHeight - 50 + 5 - bottomFix);
    } else {
        
        frame = CGRectMake(0, bottomFix + 100, kScreenWidth, 0);
    }
    
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

- (IBAction)goCheckCoinRecharge:(id)sender{
    [[VWProgressHUD shareInstance]showLoading];
    [_cawViewModel monitorCoinRecharge:_walletId coinId:_nowCoin];
}

- (void)monitorCoinRecharge:(NSDictionary *)result{
    [[VWProgressHUD shareInstance]dismiss];
    [self justShowAlert:@"感谢您" message:@"充值成功将会通知您"];
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
    self.qrCodeView.image = image;
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
    
    UIImageWriteToSavedPhotosAlbum([self captureScreen:self.qrCodeView], nil, nil, nil);
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
    [[NSUserDefaults standardUserDefaults]setObject:coinStr forKey:CHARGENOWCOIN];
    [self coinTableView:nil];
}

- (UITableView *)coinTableView{
    if (_coinTableView == nil) {
        
        float bottomFix = isiPhoneX?78:44;
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
