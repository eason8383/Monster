//
//  ReflectionViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/25.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "ReflectionViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "FeedbackViewModel.h"

@interface ReflectionViewController () <UITextViewDelegate,FeedbackViewModelDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)IBOutlet UITextView *inputTextView;
@property(nonatomic,strong)IBOutlet UIButton *uploadBtn;
@property(nonatomic,strong)IBOutlet UIButton *commitBtn;
@property(nonatomic,strong)UIImage *currentImg;
@property(nonatomic,strong)IBOutlet UIView *uploadPicView;
@property(nonatomic,strong)IBOutlet UILabel *upv_label;
@property(nonatomic,strong)IBOutlet UIImageView *upv_img;
@property(nonatomic,strong)IBOutlet UIButton *upv_btn;

@property(nonatomic,strong)FeedbackViewModel *fbViewModel;
@property(nonatomic,strong)UITapGestureRecognizer *tapRecognizer;

@property(nonatomic,strong)NSString *picPath;

@end

@implementation ReflectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题反馈";
    [self initial];
}

- (void)initial{
    
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    _uploadBtn.layer.cornerRadius = 4;
    
    _commitBtn.layer.borderWidth = 1;
    _commitBtn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    _commitBtn.layer.cornerRadius = 4;
    
    _uploadPicView.layer.cornerRadius = 4;
    _uploadPicView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    _uploadPicView.layer.borderWidth = 1;
    
    _inputTextView.layer.borderWidth = 1;
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    _inputTextView.layer.cornerRadius = 4;
    
//    [_inputTextView setValue:[UIColor colorWithWhite:1 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
    self.inputTextView.zw_placeHolder = @"*必填 还可以输入500个文字";
    
    _tapRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(firstResponder:)];
    //    _tapRecognizer.delegate = self;
    _tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapRecognizer];
    
    _fbViewModel = [FeedbackViewModel sharedInstance];
    _fbViewModel.delegate = self;
    
    [_upv_btn addTarget:self action:@selector(upvAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    _picPath = @"";
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (kScreenHeight == 568) {
        CGRect frame = _uploadPicView.frame;
        frame.origin.y = _uploadBtn.frame.origin.y;
        _uploadPicView.frame = frame;
    }
    
}

- (IBAction)uploadPics:(id)sender{
   
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;

    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

//选中图片的回调
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [[VWProgressHUD shareInstance]showLoading];
    
    //取出选中的图片
    _currentImg = info[UIImagePickerControllerOriginalImage];
    
    [_fbViewModel uploadImageByPath:[info objectForKey:@"UIImagePickerControllerImageURL"]];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)uploadSuccess:(NSDictionary*)uploadInfo{
    
    _picPath = [uploadInfo objectForKey:@"tmpFilePath"];
    
    [_upv_label setText:_picPath];
    [_upv_img setImage:_currentImg];
    
    [self upvAnimation];
    
    [[VWProgressHUD shareInstance]dismiss];
    
}

- (IBAction)commitFeedback:(id)sender{
    [[VWProgressHUD shareInstance]showLoading];
    [_fbViewModel commitFeedback:_inputTextView.text picPath:_picPath];
}

- (void)feedBackSuccess:(NSDictionary *)udInfo{
     [[VWProgressHUD shareInstance]dismiss];
    [self justShowAlert:@"提交成功" message:@"感谢您的反馈，我们会尽快处理" handler:^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)feedbackFalid:(NSError *)error{
     [[VWProgressHUD shareInstance]dismiss];
}

- (void)firstResponder:(id)sender{
    [_inputTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_inputTextView.text.length > 0) {
        [self isAuthReadyToGo:YES];
    } else {
        [self isAuthReadyToGo:NO];
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    [textField setText:text];
//    
//    if (_inputTextView.text.length > 0) {
//        [self isAuthReadyToGo:YES];
//    } else {
//        [self isAuthReadyToGo:NO];
//    }
//    
//    return NO;
//}

- (void)upvAnimation{
    
    float alphaSet = 0;
    float aniDuration = 0.1;
    if (_uploadPicView.alpha == 1) {
        alphaSet = 0;
        aniDuration = 0.1;
        
    } else {
        alphaSet = 1;
        aniDuration = 0.8;
        self.uploadBtn.enabled = NO;
        self.uploadBtn.alpha = 0.5;
    }
    
    [UIView animateWithDuration:aniDuration
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.uploadPicView.alpha = alphaSet;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             if(self.uploadPicView.alpha == 0){
                                 self.currentImg = nil;
                                 self.picPath = @"";
                                 self.uploadBtn.enabled = YES;
                                 self.uploadBtn.alpha = 1;
                             }
                         }];
                     }];
}

- (void)isAuthReadyToGo:(BOOL)isGoodToGo{
    
    if (isGoodToGo) {
        
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"402DDB"];
        _commitBtn.alpha = 1.0;
        _commitBtn.layer.borderColor = [UIColor colorWithHexString:@"402DDB"].CGColor;
    } else {
        _commitBtn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;;
        _commitBtn.backgroundColor = [UIColor clearColor];
        _commitBtn.alpha = 0.6;
    }
    _commitBtn.enabled = isGoodToGo;
}

@end
