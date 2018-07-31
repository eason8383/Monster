//
//  ScanViewController.m
//  VMM
//
//  Created by CHEN HAO LI on 2018/3/15.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SDScanView.h"
#import "MRImagePickerController.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate,CALayerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SDScanViewDelegate>

@property(nonatomic,strong)SDScanView *scanView;

@property(nonatomic,strong)IBOutlet UIButton *picsBtn;
@property(nonatomic,strong)IBOutlet UIButton *flasherBtn;
@property(nonatomic,strong)IBOutlet UILabel *flasherLabel;
@property(nonatomic,strong)IBOutlet UIView *bottonView;
@property(nonatomic,strong)UIImageView *scanImageView;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    self.title = @"扫描二维码";
    
    self.navigationController.navigationBar.translucent = NO;
    
    [_picsBtn addTarget:self action:@selector(choicePhoto) forControlEvents:UIControlEventTouchUpInside];
    
#if !TARGET_IPHONE_SIMULATOR
    NSLog(@"You're in simulator");
    _scanView = [[SDScanView alloc] init];
    _scanView.delegate = self;
    [self.view addSubview:_scanView];
#endif
    
    [self.view bringSubviewToFront:_bottonView];
//    [self setupScanQRCode];
    
    [_flasherBtn setImage:[UIImage imageNamed:@"btn_flashlight"] forState:UIControlStateNormal];
    [_flasherBtn setImage:[UIImage imageNamed:@"btn_flashlight"] forState:UIControlStateSelected];
    [_flasherBtn addTarget:self action:@selector(light_buttonAct:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor blackColor];
    
    [self.navigationItem setBackBarButtonItem:backBtn];
}

- (void)light_buttonAct:(UIButton *)button {
    if (button.selected == NO) { // 点击打开照明灯
        
        [_flasherLabel setText:@"关闭手电筒"];
    } else { // 点击关闭照明灯
        [_flasherLabel setText:@"打开手电筒"];
        
    }
    [_scanView light_buttonAction:button];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [_session startRunning];
    self.navigationController.navigationBar.translucent = YES;
    [_scanView readyToScan];
}

- (void)dealloc{
    // 删除预览图层
//    if (_preview) {
//        [_preview removeFromSuperlayer];
//    }
//    if (self.maskLayer) {
//        self.maskLayer.delegate = nil;
//    }
}

- (void)cancelScan{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SDScanViewOutputMetadataObjects:(NSArray *)metadataObjs{
    //
    AVMetadataMachineReadableCodeObject *obj = [metadataObjs objectAtIndex:0];
    NSLog(@"码数据:%@",obj.stringValue);
    NSLog(@"码类型:%@",obj.type);

    NSString *stringValue;

    // 显示遮盖
    [[VWProgressHUD shareInstance]showLoading];

    if ([metadataObjs count ] > 0 ) {
        // 当扫描到数据时，停止扫描
        

        // 将扫描的线从父控件中移除
        //        [_scanImageView removeFromSuperview];

        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjs objectAtIndex : 0 ];

        stringValue = metadataObject. stringValue ;
    }

    if ([stringValue hasPrefix:@"http"]) {
        //開網頁
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //         隐藏遮盖
            [[VWProgressHUD shareInstance] dismiss];
            
            [self justShowAlert:@"此处不支持开启网页" message:@""];

        });
    } else {
        [[VWProgressHUD shareInstance] dismiss];
        [[NSNotificationCenter defaultCenter]postNotificationName:FILLWALLETADDRESS object:stringValue];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)choicePhoto{
    //调用相册
    MRImagePickerController *imagePicker = [[MRImagePickerController alloc]init];

    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [_scanView stopScan];

    [self presentViewController:imagePicker animated:YES completion:nil];
}

//选中图片的回调
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    [[VWProgressHUD shareInstance]showLoading];
    
    NSString *content = @"" ;
    //取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray *feature = [detector featuresInImage:ciImage];
    
    //取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        content = result.messageString;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
         [[NSNotificationCenter defaultCenter]postNotificationName:FILLWALLETADDRESS object:content];
    }];
    
    NSLog(@"%@",content);
    if (content.length > 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:FILLWALLETADDRESS object:content];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self justShowAlert:@"没有数据" message:@"此照片没有数据"];
    }
    //进行处理(音效、网址分析、页面跳转等)
    
}

@end
