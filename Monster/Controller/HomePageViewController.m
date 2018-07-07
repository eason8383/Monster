//
//  HomePageViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/3.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "HomePageViewController.h"
#import "HeadTableViewCell.h"
#import "MACDTableViewCell.h"
#import "ExponentialCell.h"
#import "CoinTrendsCell.h"
#import "CoinDetailViewController.h"
#import "MarketViewController.h"
#import "MyAssetViewController.h"
#import "MyOrderViewController.h"
#import "IdentityViewController.h"
#import "SecurityViewController.h"
#import "SetupViewController.h"

@interface HomePageViewController () <UITableViewDelegate,UITableViewDataSource,RNFrostedSidebarDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@property(nonatomic,strong)MarketViewController *mVC;
@property(nonatomic,strong)UIView *alphaView;

@end

@implementation HomePageViewController

static NSString *headTableViewCellIdentifier = @"HeadViewCell";
static NSString *macdTableViewCellIdentifier = @"MACDViewCell";
static NSString *exponentialCellIdentifier = @"ExponenCell";
static NSString *coinTrendsCellIdentifier = @"CoinTreCell";

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    NSLog(@"Previous visible view controller is %@", self.navigationController.jz_previousVisibleViewController);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.jz_operation == UINavigationControllerOperationPop) {
        NSLog(@"Controller will be poped.");
    } else if (self.navigationController.jz_operation == UINavigationControllerOperationPush) {
        NSLog(@"Controller will push to another.");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jz_navigationBarHidden = YES;
    
    self.jz_navigationInteractivePopGestureEnabled = true;
    
    
    [self initial];
}

- (void)initial{
    
    [self registerCells];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


- (void)registerCells{
    
    [_tableView registerNib:[UINib nibWithNibName:@"HeadTableViewCell" bundle:nil] forCellReuseIdentifier:headTableViewCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"MACDTableViewCell" bundle:nil] forCellReuseIdentifier:macdTableViewCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"ExponentialCell" bundle:nil] forCellReuseIdentifier:exponentialCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"CoinTrendsCell" bundle:nil] forCellReuseIdentifier:coinTrendsCellIdentifier];
}

- (void)loadView{
    [super loadView];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if (height) {
        return height.floatValue;
    } else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0: {
            HeadTableViewCell *hdCell = (HeadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:headTableViewCellIdentifier];
                [hdCell.callMenuBtn addTarget:self action:@selector(callMenu:) forControlEvents:UIControlEventTouchUpInside];
                [hdCell.audioViewBtn addTarget:self action:@selector(pushSome:) forControlEvents:UIControlEventTouchUpInside];
            [hdCell.mobileNo_Label setText:[MRWebClient sharedInstance].userAccount.mobileNo];
            
            return hdCell;
        }
        case 1: {
            MACDTableViewCell *mcdCell = (MACDTableViewCell *)[tableView dequeueReusableCellWithIdentifier:macdTableViewCellIdentifier];
            
            [mcdCell setContent:@""];
            return mcdCell;
        }
        case 2: {
            ExponentialCell *expCell = (ExponentialCell *)[tableView dequeueReusableCellWithIdentifier:exponentialCellIdentifier];
            
            [expCell.moreDetailBtn addTarget:self action:@selector(moreDetail:) forControlEvents:UIControlEventTouchUpInside];
            
            return expCell;
        }
        
        default:{
            CoinTrendsCell *ctCell = (CoinTrendsCell *)[tableView dequeueReusableCellWithIdentifier:coinTrendsCellIdentifier];
            
            [ctCell setContent:@""];
            return ctCell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0 && indexPath.row != 2) {
        CoinDetailViewController *coVC = [[CoinDetailViewController alloc]initWithNibName:@"CoinDetailViewController" bundle:nil];
        coVC.jz_navigationBarHidden = NO;
        coVC.jz_navigationBarBackgroundHidden = true;
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"ETH/MR" style:UIBarButtonItemStylePlain target:nil action:nil];
        backBtn.tintColor = [UIColor whiteColor];
        [self.navigationItem setBackBarButtonItem:backBtn];
        [self.navigationController pushViewController:coVC animated:YES];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 45;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return (section == 0)?274:45;
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainPageHeadView" owner:self options:nil];
//        MainPageHeadView *hdView = [nib objectAtIndex:0];
//        [hdView.callMenuBtn addTarget:self action:@selector(callMenu:) forControlEvents:UIControlEventTouchUpInside];
//        [hdView.audioViewBtn addTarget:self action:@selector(pushSome:) forControlEvents:UIControlEventTouchUpInside];
//        return hdView;
//    } else {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExponentialView" owner:self options:nil];
//        ExponentialView *exView = [nib objectAtIndex:0];
//        [exView.moreDetailBtn addTarget:self action:@selector(moreDetail:) forControlEvents:UIControlEventTouchUpInside];
//        return exView;
//    }
//}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    [sidebar dismissAnimated:YES completion:^(BOOL animation) {
        [self pushController:[NSNumber numberWithInteger:index]];
    }];
}


- (void)sidebar:(RNFrostedSidebar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo{
    NSLog(@"willShowOnScreenAnimated");
    if (_alphaView == nil) {
        _alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_alphaView setBackgroundColor:[UIColor blackColor]];
        [_alphaView setAlpha:0.8];
        _alphaView.userInteractionEnabled = NO;
    }
    [self.parentViewController.view addSubview:_alphaView];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo{
    NSLog(@"willDismissFromScreenAnimated");
    [_alphaView removeFromSuperview];

}

- (void)pushController:(NSNumber*)index{
    UIViewController *cV = [[UIViewController alloc]init];
    switch ([index integerValue]) {
        case 0: {
            MyAssetViewController *maCV = [[MyAssetViewController alloc]initWithNibName:@"MyAssetViewController" bundle:nil];
            cV = maCV;
            break;
        }
        case 1: {
            MyOrderViewController *moCV = [[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
            cV = moCV;
            break;
        }
        case 2: {
            IdentityViewController *idCV = [[IdentityViewController alloc]initWithNibName:@"IdentityViewController" bundle:nil];
            cV = idCV;
            break;
        }
        case 3: {
            SecurityViewController *siCV = [[SecurityViewController alloc]initWithNibName:@"SecurityViewController" bundle:nil];
            cV = siCV;
            break;
        }
        case 5: {
            SetupViewController *siCV = [[SetupViewController alloc]initWithNibName:@"SetupViewController" bundle:nil];
            cV = siCV;
            break;
        }
        case 6: {
            //Logout
            return;
        }

        default:{
            break;
        }

    };
    [self homeDefaultPushController:cV];

}

- (void)homeDefaultPushController:(UIViewController*)cV{
    cV.jz_navigationBarHidden = NO;
    [cV setJz_navigationBarTintColor:[UIColor blackColor]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:cV animated:YES];
}


- (void)callMenu:(id)sender{
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithSliderMenu];
    
    callout.delegate = self;
    //    callout.showFromRight = YES;
    [callout show];
}

- (void)pushSome:(id)sender{
    
}

- (void)moreDetail:(id)sender{
//    if (_mVC == nil) {
    _mVC = [[MarketViewController alloc]initWithNibName:@"MarketViewController" bundle:nil];
//    }
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_mVC];
//    UIBarButtonItem *backHomeBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Fill_Copy"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissBackToHome:)];
//    backHomeBtn.tintColor = [UIColor whiteColor];
//    [_mVC.navigationItem setLeftBarButtonItem:backHomeBtn];
//    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:_mVC animated:YES];
    
    [self homeDefaultPushController:_mVC];
}

- (void)dismissBackToHome:(id)sender{
    [_mVC dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
//        _tableView.contentInset = UIEdgeInsetsMake(isiPhoneX?-44:-20, 0, 0, 0);
//        _tableView.backgroundColor = [UIColor colorWithHexString:@"5E2DCD"];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
