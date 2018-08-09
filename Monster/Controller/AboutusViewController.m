//
//  AboutusViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/10.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "AboutusViewController.h"

@interface AboutusViewController () <UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@property(nonatomic,assign)float height;

@end

@implementation AboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"5543CC"]];
}

- (void)loadView{
    [super loadView];
    [self.view addSubview:self.scrollView];
    
    _height = -12;
    UIImageView *img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img1"]];
    img1.tag = 1;
    [self setupImgs:img1];
    UIImageView *img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img2"]];
    [self setupImgs:img2];
    UIImageView *img3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img3"]];
    [self setupImgs:img3];
    UIImageView *img4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img4"]];
    [self setupImgs:img4];
    UIImageView *img5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img5"]];
    [self setupImgs:img5];
    UIImageView *img6 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img6"]];
    [self setupImgs:img6];
    [_scrollView setContentSize:CGSizeMake(kScreenWidth, _height)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"212025"]];

}

- (void)setupImgs:(UIImageView*)img{
//    if (img.tag == 1) {
//        img.contentMode = UIViewContentModeScaleAspectFit;
//    } else {
//        img.contentMode = UIViewContentModeScaleAspectFill;
//    }
    img.contentMode = UIViewContentModeScaleAspectFit;
    
    [img setFrame:CGRectMake(0, _height, kScreenWidth, img.height)];
//    img set13918371413
    [_scrollView addSubview:img];
    _height += img.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        
        //_tableView.contentInset = UIEdgeInsetsMake(isiPhoneX?-44:-20, 0, 0, 0);
        
        [_scrollView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight)];
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        UIView *purpleView = [[UIView alloc]initWithFrame:CGRectMake(0, -100, kScreenWidth, 400)];
        [purpleView setBackgroundColor:[UIColor colorWithHexString:@"5543CC"]];
        [_scrollView addSubview:purpleView];
    }
    return _scrollView;
}

@end
