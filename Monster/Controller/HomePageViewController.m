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
#import "AboutusViewController.h"
#import "ReflectionViewController.h"
#import "HomeViewModel.h"
#import "CoinPairModel.h"
#import "WelcomeView.h"

#define BLACKBG @"212025"
#define PURPLEBG @"5E2DCD"

@interface HomePageViewController () <RNFrostedSidebarDelegate,HomeModelDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)MarketViewController *mVC;
@property(nonatomic,strong)UIView *alphaView; //侧滑菜单出现时的半透明遮罩
@property(nonatomic,strong)HomeViewModel *homeModel;
@property(nonatomic,strong)WelcomeView *welView;

@property(nonatomic,strong)NSTimer *updatTimer;

@property(nonatomic,assign)float originOffset;

@end

@implementation HomePageViewController

static NSString *headTableViewCellIdentifier = @"HeadViewCell";
static NSString *macdTableViewCellIdentifier = @"MACDViewCell";
static NSString *exponentialCellIdentifier = @"ExponenCell";
static NSString *coinTrendsCellIdentifier = @"CoinTreCell";

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_homeModel getHomeInfo:100];
    self.navigationController.navigationBar.hidden = YES;
    BOOL needReloadShow = [[NSUserDefaults standardUserDefaults]boolForKey:RELOAD_AFTERSETTING];
    if (needReloadShow) {
        [[VWProgressHUD shareInstance]showLoading];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:RELOAD_AFTERSETTING];
    }
    _updatTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                  repeats:YES block:^(NSTimer *timer) {
                                                      [self.homeModel getHomeInfo:1];
                                                  }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [_welView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _originOffset = self.tableView.contentOffset.y;

}

- (void)cancelWelView:(UIButton*)btn{
    [[NSUserDefaults standardUserDefaults]setObject:@"Showed" forKey:SHOWWELCOMEVIEW];
    
    [_welView removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_updatTimer invalidate];
    _updatTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initial];
    
    [[VWProgressHUD shareInstance]showLoading];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:BLACKBG]];
    
    //欢迎页面
    [self caseShowWelcomePage];
}

- (void)initial{
    
    _homeModel = [HomeViewModel sharedInstance];
    _homeModel.delegate = self;

    [self registerCells];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UISwipeGestureRecognizer *swipeLeftToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.view addGestureRecognizer:swipeLeftToRight];
    
}

- (void)caseShowWelcomePage{
    NSString *needShowWelcomeView = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWWELCOMEVIEW];
    
    if (![needShowWelcomeView isEqualToString:@"Showed"]) {
        [self showWelcomePage];
    }
}

- (void)showWelcomePage{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WelcomeView" owner:self options:nil];
    _welView = [nib objectAtIndex:0];
    [self.view addSubview:_welView];
}

- (void)handleSwipe:(id)sender {
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self callMenu:nil];
    }
}

- (void)registerCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadTableViewCell" bundle:nil] forCellReuseIdentifier:headTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MACDTableViewCell" bundle:nil] forCellReuseIdentifier:macdTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ExponentialCell" bundle:nil] forCellReuseIdentifier:exponentialCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CoinTrendsCell" bundle:nil] forCellReuseIdentifier:coinTrendsCellIdentifier];
}

#pragma mark - HomeModelDelegate

- (void)getDataSucess{
    [self.tableView reloadData];
    [[VWProgressHUD shareInstance]dismiss];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    
    NSDictionary *dic = error.userInfo;
    NSDictionary *respCode = [dic objectForKey:@"respCode"];
    if ([[respCode objectForKey:@"code"]isEqualToString:@"00207"] || [[respCode objectForKey:@"code"]isEqualToString:@"00999"]) {
        [self justShowAlert:LocalizeString(@"LOGIN_SESSION_FAILE") message:LocalizeString(@"LOGIN_AGAIN")];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
        [_updatTimer invalidate];
        _updatTimer = nil;
    }else{
        NSString *str = [dic objectForKey:@"respMessage"];
        NSArray *errorAry = [str componentsSeparatedByString:@","];
        if (str && str.length > 0) {
            [self justShowAlert:LocalizeString(@"ERROR") message:[errorAry objectAtIndex:0]];
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3 + _homeModel.numberOfRowsInSection;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0: {
            HeadTableViewCell *hdCell = (HeadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:headTableViewCellIdentifier];
            [hdCell.callMenuBtn addTarget:self action:@selector(callMenu:) forControlEvents:UIControlEventTouchUpInside];
            [hdCell.audioViewBtn addTarget:self action:@selector(pushSome:) forControlEvents:UIControlEventTouchUpInside];
            [hdCell.mobileNo_Label setText:[MRWebClient sharedInstance].userAccount.mobileNo];
//            [hdCell setFilpLabelInfos:@[@"全球创新企业天使凭证交易所"]];
            [hdCell.titleLabel setText:LocalizeString(@"HOMETITLE")];
            [hdCell setPoaMALabel:LocalizeString(@"PAOMAMSG")];
            return hdCell;
        }
        case 1: {
            MACDTableViewCell *mcdCell = (MACDTableViewCell *)[tableView dequeueReusableCellWithIdentifier:macdTableViewCellIdentifier];
            NSArray *ary = [_homeModel getHomeDataArray];
            if (ary.count > 0) {
                CoinPairModel *model = [ary objectAtIndex:indexPath.row - 1];
                NSArray *klineAry = [_homeModel getDrawKLineInfoArray:model.coinPairId];
                mcdCell.multiple = [_homeModel getMultipleWithCurrentCoinId:model.subCoinId];
                [mcdCell setContent:model dataArray:klineAry];
            }
            return mcdCell;
        }
        case 2: {
            ExponentialCell *expCell = (ExponentialCell *)[tableView dequeueReusableCellWithIdentifier:exponentialCellIdentifier];
            [expCell setTitle:LocalizeString(@"MONSTER") subTitle:LocalizeString(@"MOREDETAIl")];
            [expCell.moreDetailBtn addTarget:self action:@selector(moreDetail:) forControlEvents:UIControlEventTouchUpInside];
            return expCell;
        }
        
        default:{
            CoinTrendsCell *ctCell = (CoinTrendsCell *)[tableView dequeueReusableCellWithIdentifier:coinTrendsCellIdentifier];
            NSArray *ary = [_homeModel getHomeDataArray];
            CoinPairModel *model = [ary objectAtIndex:indexPath.row - 3];
            NSArray *klineAry = [_homeModel getDrawKLineInfoArray:model.coinPairId];
            [ctCell setContent:model dataArray:klineAry];
            return ctCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0 && indexPath.row != 2) {
        CoinDetailViewController *coVC = [[CoinDetailViewController alloc]initWithNibName:@"CoinDetailViewController" bundle:nil];
        
        NSArray *ary = [_homeModel getHomeDataArray];
        NSInteger index = (indexPath.row == 1)?indexPath.row - 1:indexPath.row - 3;
        CoinPairModel *model = [ary objectAtIndex:index];
        NSArray *klineAry = [_homeModel getDrawKLineInfoArray:model.coinPairId];
        coVC.model = model;
        coVC.klineDataAry = [[NSMutableArray alloc]initWithArray:klineAry];
        coVC.multiple = [_homeModel getMultipleWithCurrentCoinId:model.subCoinId];
        coVC.isMRType = [model.mainCoinId isEqualToString:@"MR"]?YES:NO;
        
        [self homeDefaultPushController:coVC withBackTitle:[NSString stringWithFormat:@"%@/%@",model.mainCoinId,model.subCoinId]];
    }
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    
    [sidebar dismissAnimated:YES completion:^(BOOL animation) {
        [self pushController:[NSNumber numberWithInteger:index]];
    }];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo{

    if (_alphaView == nil) {
        _alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_alphaView setBackgroundColor:[UIColor blackColor]];
        [_alphaView setAlpha:0.8];
        _alphaView.userInteractionEnabled = NO;
    }
    [self.parentViewController.view addSubview:_alphaView];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo{

    [_alphaView removeFromSuperview];
}

- (void)pushController:(NSNumber*)index{
    UIViewController *cV = [[UIViewController alloc]init];
    switch ([index integerValue]) {
        case 0: {
            MyAssetViewController *maVc = [[MyAssetViewController alloc]initWithNibName:@"MyAssetViewController" bundle:nil];
            cV = maVc;
            break;
        }
        case 1: {
            MyOrderViewController *moVc = [[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
            cV = moVc;
            break;
        }
        case 2: {
            IdentityViewController *idVc = [[IdentityViewController alloc]initWithNibName:@"IdentityViewController" bundle:nil];
            cV = idVc;
            
            break;
        }
        case 3: {
            SecurityViewController *siVc = [[SecurityViewController alloc]initWithNibName:@"SecurityViewController" bundle:nil];
            cV = siVc;
            break;
        }
        case 4: {
            [self showWelcomePage];
            return;
        }
        case 5: {
            AboutusViewController *abVc= [[AboutusViewController alloc]initWithNibName:@"AboutusViewController" bundle:nil];
            
            cV = abVc;
        }
            break;
        case 6: {
            ReflectionViewController *reVc = [[ReflectionViewController alloc]initWithNibName:@"ReflectionViewController" bundle:nil];
            cV = reVc;
        }
        case 7:{
            SetupViewController *siVc = [[SetupViewController alloc]initWithNibName:@"SetupViewController" bundle:nil];
            cV = siVc;
            break;
        }
            
        case 8:{
            //Logout
            [[NSNotificationCenter defaultCenter] postNotificationName:DOLOGOUT object:nil];
            return;
        }

        default:{
            break;
        }
    };
    [self homeDefaultPushController:cV withBackTitle:@""];

}

- (void)homeDefaultPushController:(UIViewController*)cV withBackTitle:(NSString*)title{
//    cV.jz_navigationBarHidden = NO;
//    [cV setJz_navigationBarTintColor:[UIColor blackColor]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:cV animated:YES];
}

- (void)callMenu:(id)sender{
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithSliderMenu];
    
    callout.delegate = self;
    //    callout.showFromRight = YES;
    [callout show];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > _originOffset) {
        [self.view setBackgroundColor:[UIColor colorWithHexString:BLACKBG]];
    } else {
        [self.view setBackgroundColor:[UIColor colorWithHexString:PURPLEBG]];
    }
}

- (void)pushSome:(id)sender{
    //点击喇吧后动作
}

- (void)moreDetail:(id)sender{

    _mVC = [[MarketViewController alloc]initWithNibName:@"MarketViewController" bundle:nil];
    [self homeDefaultPushController:_mVC withBackTitle:@""];
}

- (void)dismissBackToHome:(id)sender{
    [_mVC dismissViewControllerAnimated:YES completion:nil];
}

@end
