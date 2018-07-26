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

@interface IdentityViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IdentityViewModelDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UpLoadImagView *aView;
@property(nonatomic,strong)UpLoadImagView *bView;
@property(nonatomic,strong)UpLoadImagView *cView;
@property(nonatomic,strong)IdentityViewModel *idViewModel;
@property(nonatomic,strong)UIImage *currentImg;
@property(nonatomic,strong)UIButton *confirmBtn;

@property(nonatomic,strong)NSString *frontId;
@property(nonatomic,strong)NSString *backId;
@property(nonatomic,strong)NSString *withId;

@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份验证";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self initial];
}

- (void)initial{
    _idViewModel = [IdentityViewModel sharedInstance];
    _idViewModel.delegate = self;
    
    [[VWProgressHUD shareInstance]showLoading];
    [_idViewModel queryUserInfo];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)loadView{
    [super loadView];
    
    
    _frontId = @"";
    _backId = @"";
    _withId = @"";
    
    [self.view addSubview:self.scrollView];
    
    
}

- (void)diceidUpload{
    MRUserAccount *accInfo = [[MRWebClient sharedInstance]getUserAccount];
    if (accInfo.frontIdCard.length < 1) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
        _aView = [nib objectAtIndex:0];
        [_aView setIdentityType:UpLoadID_Front];
        [_aView.uploadBtn addTarget:self action:@selector(startUploadImage:) forControlEvents:UIControlEventTouchUpInside];
        _aView.uploadBtn.tag = 1;
        [_scrollView addSubview:_aView];
    } else {
        [_aView removeFromSuperview];
    }
    if (accInfo.backIdCard.length < 1) {
        NSArray *nib2 = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
        _bView = [nib2 objectAtIndex:0];
        [_bView setIdentityType:UpLoadID_Back];
        [_bView.uploadBtn addTarget:self action:@selector(startUploadImage:) forControlEvents:UIControlEventTouchUpInside];
        _bView.uploadBtn.tag = 2;
        [_scrollView addSubview:_bView];
    } else {
        [_bView removeFromSuperview];
    }
    
    if (accInfo.userWithIdCard.length < 1) {
        NSArray *nib3 = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
        _cView = [nib3 objectAtIndex:0];
        [_cView setIdentityType:UpLoadID_Hold];
        [_cView.uploadBtn addTarget:self action:@selector(startUploadImage:) forControlEvents:UIControlEventTouchUpInside];
        _cView.uploadBtn.tag = 3;
        [_scrollView addSubview:_cView];
    } else {
        [_cView removeFromSuperview];
    }
    
    if(_confirmBtn == nil){
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(24,0,kScreenWidth - 45, 34)];
        [_confirmBtn setTintColor:[UIColor whiteColor]];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 4;
        _confirmBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        _confirmBtn.layer.borderWidth = 1;
        _confirmBtn.alpha = 0.6;
        [_confirmBtn addTarget:self action:@selector(submmitAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.enabled = NO;
        
        [_scrollView addSubview:_confirmBtn];
    }
    
    if (accInfo.idCardAuditStatus.length > 0 && [accInfo.idCardAuditStatus isEqualToString:@"1"]) {
        [_confirmBtn setFrame:CGRectMake(24, 100, kScreenWidth - 45, 34)];
        [_confirmBtn setTitle:@"已验证" forState:UIControlStateNormal];
    } else if (accInfo.idCardAuditStatus.length > 0 && [accInfo.idCardAuditStatus isEqualToString:@"0"]) {
        [_confirmBtn setFrame:CGRectMake(24, 100, kScreenWidth - 45, 34)];
        [_confirmBtn setTitle:@"审查中" forState:UIControlStateNormal];
    }
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

- (void)queryUserInfoSuccess:(NSDictionary *)userInfo{
    [self diceidUpload];
    [[VWProgressHUD shareInstance]dismiss];
    
    NSLog(@"%@",userInfo);
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    NSDictionary *dic = error.userInfo;
    NSDictionary *respCode = [dic objectForKey:@"respCode"];
    if ([[respCode objectForKey:@"code"]isEqualToString:@"00207"]) {
        [self justShowAlert:@"登陆会话无效" message:@"请重新登录"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    } else {
        [self justShowAlert:@"错误信息" message:[dic objectForKey:@"respMessage"]];
    }
}

- (void)startUploadImage:(UIButton*)upBtn{
    NSLog(@"%ld",(long)upBtn.tag);
    MRImagePickerController *imagePicker = [[MRImagePickerController alloc]init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.pickerNo = upBtn.tag;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    MRUserAccount *accInfo = [MRWebClient sharedInstance].userAccount;
    
    float yPos = 28; //起始位置
    
//    if (accInfo.frontIdCard) {
        [_aView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
        yPos += _aView.frame.size.height + 11;
//    }
//    if (accInfo.backIdCard) {
        [_bView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
        yPos += _bView.frame.size.height + 11;
//    }
    
//    if (!accInfo.userWithIdCard) {
        [_cView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
        yPos += _cView.frame.size.height + 33;
//    }
    
    
    [_confirmBtn setFrame:CGRectMake(24,yPos,kScreenWidth - 45, 34)];
    
    yPos += 81;
    
    
    [_scrollView setContentSize:CGSizeMake(kScreenWidth, yPos)];
}

//选中图片的回调
- (void)imagePickerController:(MRImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [[VWProgressHUD shareInstance]showLoading];
    
    //取出选中的图片
    _currentImg = info[UIImagePickerControllerOriginalImage];

    [_idViewModel uploadImageByPath:[info objectForKey:@"UIImagePickerControllerImageURL"] withTag:picker.pickerNo];
    [picker dismissViewControllerAnimated:YES completion:nil];

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
    
    if (_frontId.length > 0 || _backId.length > 0 || _withId.length > 0) {
        [self setCommitBtnEnableWhenReady:YES];
    } else {
        [self setCommitBtnEnableWhenReady:NO];
    }
    
    [[VWProgressHUD shareInstance]dismiss];
}

- (void)submmitAction:(id)sender{
    [[VWProgressHUD shareInstance]showLoading];
    [_idViewModel saveUserIdentity:_frontId back:_backId withId:_withId];
}

- (void)saveUserIdentitySuccess:(NSDictionary*)verifyInfo{
//    [[VWProgressHUD shareInstance]dismiss];
    [_idViewModel queryUserInfo];
    [self justShowAlert:@"提交成功" message:@"您的信息已顺利提交 谢谢您"];
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
