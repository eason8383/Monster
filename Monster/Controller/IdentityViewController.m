//
//  IdentityViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "IdentityViewController.h"
#import "UpLoadImagView.h"

@interface IdentityViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UpLoadImagView *aView;
@property(nonatomic,strong)UpLoadImagView *bView;
@property(nonatomic,strong)UpLoadImagView *cView;


@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份验证";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)loadView{
    [super loadView];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
    _aView = [nib objectAtIndex:0];
    [_aView setIdentityType:UpLoadID_Front];
    [_aView.uploadBtn addTarget:self action:@selector(startUploadImage:) forControlEvents:UIControlEventTouchUpInside];
    _aView.uploadBtn.tag = 1;
    
    NSArray *nib2 = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
    _bView = [nib2 objectAtIndex:0];
    [_bView setIdentityType:UpLoadID_Back];
    [_bView.uploadBtn addTarget:self action:@selector(startUploadImage:) forControlEvents:UIControlEventTouchUpInside];
    _bView.uploadBtn.tag = 2;
    
    NSArray *nib3 = [[NSBundle mainBundle] loadNibNamed:@"UpLoadImagView" owner:self options:nil];
    _cView = [nib3 objectAtIndex:0];
    [_cView setIdentityType:UpLoadID_Hold];
    [_cView.uploadBtn addTarget:self action:@selector(startUploadImage:) forControlEvents:UIControlEventTouchUpInside];
    _cView.uploadBtn.tag = 3;
    
    [self.view addSubview:self.scrollView];
    
    [_scrollView addSubview:_aView];
    [_scrollView addSubview:_bView];
    [_scrollView addSubview:_cView];
}

- (void)startUploadImage:(UIButton*)upBtn{
    NSLog(@"%ld",(long)upBtn.tag);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    float yPos = 28; //起始位置
    [_aView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
    yPos += _aView.frame.size.height + 11;
    [_bView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
    yPos += _bView.frame.size.height + 11;
    [_cView setFrame:CGRectMake(0, yPos, kScreenWidth, 182)];
    yPos += _aView.frame.size.height + 33;
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(24,yPos,kScreenWidth - 45, 34)];
    [confirmBtn setTintColor:[UIColor whiteColor]];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 4;
    confirmBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.alpha = 0.6;
    yPos += 81;
    
    [_scrollView addSubview:confirmBtn];
    
    [_scrollView setContentSize:CGSizeMake(kScreenWidth, yPos)];
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
