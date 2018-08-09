//
//  IdentityViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "IdentityViewController.h"
#import "UpLoadImagView.h"
#import <AVFoundation/AVFoundation.h>
#import "MRImagePickerController.h"
#import "IdentityViewModel.h"
#import "IdInputView.h"

@interface IdentityViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IdentityViewModelDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)IdInputView *idView;
@property(nonatomic,strong)UpLoadImagView *aView;
@property(nonatomic,strong)UpLoadImagView *bView;
@property(nonatomic,strong)UpLoadImagView *cView;
@property(nonatomic,strong)IdentityViewModel *idViewModel;

@property(nonatomic,strong)UIImage *currentImg;
@property(nonatomic,strong)UIButton *confirmBtn;

@property(nonatomic,strong)NSString *frontId;
@property(nonatomic,strong)NSString *backId;
@property(nonatomic,strong)NSString *withId;

@property(nonatomic,assign)BOOL needReset;

@property(nonatomic,strong)NSMutableDictionary *checkPicsDic;

@property UITapGestureRecognizer *tapRecognizer;

@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initial];
}

- (void)fillText{
//    "IDVERIFYCATION" = "身份认证";
//    "ID" = "身份认号";
//    "ICPLACEHOLDER" = "请填写您的身分证号";
//    "UPLOADFORONT" = "请上传您的身份证人面像";
//    "UPLOADBACK" = "请上传您的身份证国徽面";
//    "UPLOADHANDID" = "请上传您的手持身份证";
//    "UPLOADPIC" = "上传照片";
//    "TAPANDREUPLOAD" = "请点击后重新上传";
//    "UNDERREVIEW" = "审查中";
}

- (void)loadView{
    [super loadView];
    self.title = LocalizeString(@"IDVERIFYCATION");
    
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:self.scrollView];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(firstResponder:)];
    //    _tapRecognizer.delegate = self;
    _tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapRecognizer];
}

- (void)initial{
    
    _frontId = @"";
    _backId = @"";
    _withId = @"";
    _needReset = NO;
    _idViewModel = [IdentityViewModel sharedInstance];
    _idViewModel.delegate = self;
    
    _checkPicsDic = [NSMutableDictionary dictionary];
    [[VWProgressHUD shareInstance]showLoading];
    [_idViewModel queryUserInfo];
}

- (void)queryUserInfoSuccess:(NSDictionary *)userInfo{
    [self diceidUpload];
    [[VWProgressHUD shareInstance]dismiss];
    
    NSLog(@"%@",userInfo);
}

- (void)firstResponder:(id)sender{
    [_idView.id_Field resignFirstResponder];
}

- (void)diceidUpload{
    
    MRUserAccount *accInfo = [[MRWebClient sharedInstance]getUserAccount];
    
    NSArray *nibv = [[NSBundle mainBundle] loadNibNamed:@"IdInputView" owner:self options:nil];
    _idView = [nibv objectAtIndex:0];
    [_scrollView addSubview:_idView];
    
    if (accInfo.idCardNo.length > 0) {
        [_idView.id_Field setText:accInfo.idCardNo];
    }
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
    _aView = [nib objectAtIndex:0];
    [_aView setIdentityType:UpLoadID_Front];
    if (accInfo.frontIdCard.length > 0) {
        [_aView setImageUrl:accInfo.frontIdCard];
        _frontId = accInfo.frontIdCard;
    } else {
        [self addTargetToButton:_aView setTag:1];
    }
    [_scrollView addSubview:_aView];
    
    NSArray *nib2 = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
    _bView = [nib2 objectAtIndex:0];
    [_bView setIdentityType:UpLoadID_Back];
    
    if (accInfo.backIdCard.length > 0) {
        [_bView setImageUrl:accInfo.backIdCard];
        _backId = accInfo.backIdCard;
    } else {
        [self addTargetToButton:_bView setTag:2];
    }
    [_scrollView addSubview:_bView];
    
    NSArray *nib3 = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
    _cView = [nib3 objectAtIndex:0];
    [_cView setIdentityType:UpLoadID_Hold];
    if (accInfo.userWithIdCard.length > 0) {
        [_cView setImageUrl:accInfo.userWithIdCard];
        _withId = accInfo.userWithIdCard;
    } else {
        [self addTargetToButton:_cView setTag:3];
    }
    [_scrollView addSubview:_cView];
    
    if (_confirmBtn == nil) {
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(24,0,kScreenWidth - 45, 34)];
        [_confirmBtn setTintColor:[UIColor whiteColor]];
        [_confirmBtn setTitle:LocalizeString(@"ALERT_SUBMIT") forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 4;
        _confirmBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        _confirmBtn.layer.borderWidth = 1;
        _confirmBtn.alpha = 0.6;
        [_confirmBtn addTarget:self action:@selector(submmitAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.enabled = NO;
        
        [_scrollView addSubview:_confirmBtn];
    }
    
    if (accInfo.frontIdCard.length > 1 && accInfo.backIdCard.length > 1 && accInfo.userWithIdCard.length > 1) {
        
        if (accInfo.idCardAuditStatus.length > 0 && [accInfo.idCardAuditStatus isEqualToString:@"8"]) {
            [_confirmBtn setFrame:CGRectMake(24, 100, kScreenWidth - 45, 34)];
            [_confirmBtn setTitle:LocalizeString(@"SUCCESS") forState:UIControlStateNormal];
        } else if (accInfo.idCardAuditStatus.length > 0 && [accInfo.idCardAuditStatus isEqualToString:@"9"]) {
            [_confirmBtn setFrame:CGRectMake(24, 100, kScreenWidth - 45, 34)];
            [_confirmBtn setTitle:LocalizeString(@"TAPANDREUPLOAD") forState:UIControlStateNormal];
            _needReset = YES;
            [self setCommitBtnEnableWhenReady:YES];
        } else {
            [_confirmBtn setFrame:CGRectMake(24, 100, kScreenWidth - 45, 34)];
            [_confirmBtn setTitle:LocalizeString(@"UNDERREVIEW") forState:UIControlStateNormal];
        }
        _idView.id_Field.enabled = NO;
        
    } else {
        [_confirmBtn setTitle:LocalizeString(@"ALERT_SUBMIT") forState:UIControlStateNormal];
        _idView.id_Field.enabled = YES;
    }
    
    
    
//    if (accInfo.idCardAuditStatus.length > 0 && [accInfo.idCardAuditStatus isEqualToString:@"1"]) {
//        [_confirmBtn setFrame:CGRectMake(24, 100, kScreenWidth - 45, 34)];
//        [_confirmBtn setTitle:@"已验证" forState:UIControlStateNormal];
//    } else if (accInfo.frontIdCard.length > 0 && accInfo.backIdCard.length > 0 && accInfo.userWithIdCard.length > 0) {
//        [_confirmBtn setFrame:CGRectMake(24, 100, kScreenWidth - 45, 34)];
//        [_confirmBtn setTitle:@"审查中" forState:UIControlStateNormal];
//    } else {
//        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
//    }
    
//    [self setPostions];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self setPostions];
    
}

- (void)setPostions{
    float yPos = 28; //起始位置
    
    [_idView setFrame:CGRectMake(0, yPos, kScreenWidth, 79)];
    yPos += _idView.frame.size.height + 11;
    
    [_aView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
    yPos += _aView.frame.size.height + 11;
    
    [_bView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
    yPos += _bView.frame.size.height + 11;
    
    [_cView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
    yPos += _cView.frame.size.height + 33;
    
    [_confirmBtn setFrame:CGRectMake(24,yPos,kScreenWidth - 45, 34)];
    
    yPos += 81;
    
    [_scrollView setContentSize:CGSizeMake(kScreenWidth, yPos)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"212025"]];
}

- (void)setCommitBtnEnableWhenReady:(BOOL)isReady{
    if (isReady) {
        _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"402DDB"];
        _confirmBtn.layer.borderColor = [UIColor clearColor].CGColor;
        _confirmBtn.alpha = 1.0;
    } else {
        _confirmBtn.backgroundColor = [UIColor clearColor];
        _confirmBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        _confirmBtn.alpha = 0.6;
    }
    _confirmBtn.enabled = isReady;
}

- (void)toPickAUploadPic:(UIButton*)upBtn{
    NSLog(@"%ld",(long)upBtn.tag);
    
    //调用选图片
    MRImagePickerController *imagePicker = [[MRImagePickerController alloc]init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.pickerNo = upBtn.tag;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//选中图片的回调
- (void)imagePickerController:(MRImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [[VWProgressHUD shareInstance]showLoading];
    
    //取出选中的图片
    _currentImg = info[UIImagePickerControllerOriginalImage];
    NSLog(@"取出选中的图片:%@",info);
    
    NSString *checkPath = [NSString stringWithFormat:@"%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
    [_checkPicsDic setObject:checkPath forKey:[NSString stringWithFormat:@"%ld",(long)picker.pickerNo]];
    
    //上傳
    [_idViewModel uploadImageByPath:[info objectForKey:@"UIImagePickerControllerImageURL"] withTag:picker.pickerNo];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [info objectForKey:@"UIImagePickerControllerReferenceURL"]
    
}

- (void)uploadSuccess:(NSDictionary*)uploadInfo withTag:(NSInteger)senderTag{
    switch (senderTag) {
        case 1:{
            [_aView.picImgView setImage:_currentImg];
            _frontId = [uploadInfo objectForKey:@"tmpFilePath"];
        }
            break;
        case 2:{
            [_bView.picImgView setImage:_currentImg];
            _backId = [uploadInfo objectForKey:@"tmpFilePath"];
        }
            break;
        case 3:{
            [_cView.picImgView setImage:_currentImg];
            _withId = [uploadInfo objectForKey:@"tmpFilePath"];
        }
            break;
        default:
            break;
    }
    
    if (_frontId.length > 0 && _backId.length > 0 && _withId.length > 0) {
        [self setCommitBtnEnableWhenReady:YES];
    } else {
        [self setCommitBtnEnableWhenReady:NO];
    }
    
    [[VWProgressHUD shareInstance]dismiss];
}

- (void)submmitAction:(id)sender{
    
    if (_needReset) {
        [self reset];
    } else {
        
        if ([self checkIfPicsTheSame]) {
            [self justShowAlert:LocalizeString(@"PHOTOREPEATED") message:LocalizeString(@"PICREPEATWARING")];
        } else if (_idView.id_Field.text.length < 1) {
           [self justShowAlert:LocalizeString(@"IMCOMPLETE") message:LocalizeString(@"PLEASEFILLID")];
        } else {
            [[VWProgressHUD shareInstance]showLoading];
            [_idViewModel saveUserIdentity:_frontId back:_backId withId:_withId withIdNo:_idView.id_Field.text];
        }
    }
}

- (void)reset{
    _needReset = NO;
    _frontId = @"";
    _backId = @"";
    _withId = @"";
    _idView.id_Field.enabled = YES;
    [_aView resetUploadView];
    [self addTargetToButton:_aView setTag:1];
    [_bView resetUploadView];
    [self addTargetToButton:_bView setTag:2];
    [_cView resetUploadView];
    [self addTargetToButton:_cView setTag:3];
    [self setCommitBtnEnableWhenReady:NO];
    [_confirmBtn setTitle:LocalizeString(@"ALERT_SUBMIT") forState:UIControlStateNormal];
}

- (void)addTargetToButton:(UpLoadImagView*)uploadView setTag:(NSInteger)tag{
    [uploadView.uploadBtn addTarget:self action:@selector(toPickAUploadPic:) forControlEvents:UIControlEventTouchUpInside];
    uploadView.uploadBtn.tag = tag;
}

- (BOOL)checkIfPicsTheSame{
    NSString *str1 = [self.checkPicsDic objectForKey:@"1"];
    NSString *str2 = [self.checkPicsDic objectForKey:@"2"];
    NSString *str3 = [self.checkPicsDic objectForKey:@"3"];
    
    if ([str1 isEqualToString:str2]) {
        return YES;
    } else if ([str1 isEqualToString:str3]) {
        return YES;
    } else if ([str2 isEqualToString:str3]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)saveUserIdentitySuccess:(NSDictionary*)verifyInfo{
    [[VWProgressHUD shareInstance]dismiss];
//    [self setCommitBtnEnableWhenReady:NO];
//    [_idViewModel queryUserInfo];
    [self justShowAlert:LocalizeString(@"SUCCESS") message:LocalizeString(@"COMMITSUCESS") handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
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

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"17181C"];
        
        
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}

@end
