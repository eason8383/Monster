//
//  TradeViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "TradeViewController.h"
#import "TradeView.h"
#import "ExponentialCell.h"
#import "EntrustNowViewCell.h"
#import "TradeViewModel.h"
#import "CoinPairModel.h"
#import "UserOrderModel.h"
#import "MyOrderViewController.h"
#import "ChoseCoinTableViewCell.h"
#import "AppDelegate.h"
//#import "JZNavigationExtension.h"

@interface TradeViewController () <UITableViewDelegate,UITableViewDataSource,TradeViewModelDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)TradeView *tradeView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableView *coinTableView;
@property(nonatomic,strong)TradeViewModel *tradeViewModel;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@property UITapGestureRecognizer *tapRecognizer;
//@property(nonatomic,strong)NSLayoutConstraint *hightConstraint;

@end

@implementation TradeViewController

static NSString *exponentialCellIdentifier = @"ExponenCell";
static NSString *entrustNowViewCellIdentifier = @"EntrustNowViewCell";
static NSString *choseCoinTableViewCell = @"ChoseCoinTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)initial{
    
    _tradeViewModel = [TradeViewModel sharedInstance];
    _tradeViewModel.delegate = self;
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(firstResponder:)];
    _tapRecognizer.numberOfTapsRequired = 1;
    
    if (_tradeView == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TradeView" owner:self options:nil];
        _tradeView = [nib objectAtIndex:0];
        
        //发送买卖请求
        [_tradeView.confirmBtn addTarget:self action:@selector(orderRequest:) forControlEvents:UIControlEventTouchUpInside];
        
        //coinTable 展开收起
        [_tradeView.titleDownBtn addTarget:self action:@selector(coinTableViewAnimation:) forControlEvents:UIControlEventTouchUpInside];
        //收下键盘
        [_tradeView addGestureRecognizer:_tapRecognizer];
    }

    [self registerCells];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UINavigationBar appearance].translucent = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _tradeViewModel.delegate = self;
    [_tradeViewModel getData:_model.coinPairId];
}

- (void)loadView{
    [super loadView];
    
    [UINavigationBar appearance].translucent = YES;
    [UINavigationBar appearance].barTintColor = [UIColor colorWithHexString:@"212025"];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIBarButtonItem *backHomeBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Quotation"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissBack:)];
    backHomeBtn.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setLeftBarButtonItem:backHomeBtn];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissBackToHome:)];
    backBtn.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItem:backBtn];
    
//    _tableView.tableHeaderView = _tableView;
//    [self.view addSubview:_tradeView];
    [self.view addSubview:self.tableView];
    UIWindow *window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.coinTableView];
    NSLog(@"11---------%f",self.tableView.contentOffset.y);
}

- (void)coinTableViewAnimation:(id)sender{
    [self.view endEditing:YES];
    
    
    [self adjustTable:NO];
    CGRect frame;
    float bottomFix = isiPhoneX?88:56;
    
    if (_coinTableView.height == 0) {
        frame = CGRectMake(0, bottomFix + 63, kScreenWidth, kScreenHeight - 50 + 5 - bottomFix);
    } else {
        frame = CGRectMake(0, bottomFix + 63, kScreenWidth, 0);
    }
    if (self.coinTableView.height == 0) {
        [self.tradeView titleDownBtnAnticlockwiseRotation];
    } else {
        [self.tradeView titleDownBtnclockwiseRotation];
    }
    
    [UIView animateWithDuration:0.6
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.coinTableView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         if (self.coinTableView.height == 0) {
                             [self adjustTable:YES];
                         } else {
                             
                         }
                        
                     }];
}

- (void)adjustTable:(BOOL)canUse{
    NSLog(@"Adjust");
    float iphoneFix = isiPhoneX?88:64;
    [self.tableView setContentOffset:CGPointMake(0, -iphoneFix) animated:YES];
    self.tableView.scrollEnabled = canUse;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndScrollingAnimation:%f frame:%f",scrollView.contentOffset.y,self.tableView.frame.origin.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll:%f",scrollView.contentOffset.y);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (isiPhoneX) {
        [_tradeView setFrame:CGRectMake(0, 102, kScreenWidth, 449)];
    } else {
        [_tradeView setFrame:CGRectMake(0, 60, kScreenWidth, 449)];
    }
    [_tradeView.hlView setFrame:_tradeView.highLowViewBack.bounds];
}

- (void)dismissBackToHome:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dismissBack:(id)sender{
   [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerCells{
    
    [_tableView registerNib:[UINib nibWithNibName:@"ExponentialCell" bundle:nil] forCellReuseIdentifier:exponentialCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"EntrustNowViewCell" bundle:nil] forCellReuseIdentifier:entrustNowViewCellIdentifier];
    [_coinTableView registerNib:[UINib nibWithNibName:@"ChoseCoinTableViewCell" bundle:nil] forCellReuseIdentifier:choseCoinTableViewCell];
}

- (void)firstResponder:(id)sender{
    [_tradeView.stepperPriceField resignFirstResponder];
    [_tradeView.stepperVolumField resignFirstResponder];
}

- (void)moreDetail:(id)sender{
    
    MyOrderViewController *moVc = [[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:moVc animated:YES];
}

- (void)getDataSucess{
    NSLog(@"Trade getDataSucess");
    [_tradeView setContent:self.model];
    [_tradeView setPriceCrew:[_tradeViewModel getBuyAry] saleAry:[_tradeViewModel getSaleAry]];
    [_tradeView setUerCoinQuantity:[_tradeViewModel getUserQuantityAry]];
    [_tableView reloadData];
    [[VWProgressHUD shareInstance]dismiss];
}

- (void)getUserOrderSucess{
    [[VWProgressHUD shareInstance]dismiss];
    
    [self.tableView reloadData];
    NSLog(@"getUserOrderSucess So reload");
}

- (void)orderCancelSucess:(NSDictionary*)res{
    [[VWProgressHUD shareInstance]dismiss];
    [_tradeViewModel performSelector:@selector(getData:) withObject:_model.coinPairId afterDelay:0.5];
}

- (void)orderRequest:(UIButton*)btn{
    
    if (_tradeView.stepperVolumField.text.length < 1 || _tradeView.stepperPriceField.text.length < 1) {
        [self justShowAlert:LocalizeString(@"IMCOMPLETE") message:LocalizeString(@"FILLTHEPRICEANDAMOUNT")];
    } else {
        [[VWProgressHUD shareInstance]showLoading];
        BOOL isBuy = _tradeView.isBuyMode?YES:NO; //isHighMode = YES 就是买入
//        float coinQuantity = [_tradeView.stepperVolumField.text floatValue];
//        float orderPrice = [_tradeView.stepperPriceField.text floatValue];
        
        [_tradeViewModel oderRequest:self.model coinQuantity:_tradeView.stepperVolumField.text orderPrice:_tradeView.stepperPriceField.text buyOrSale:isBuy];
    }
}

- (void)orderRequestSucess:(NSDictionary *)res{
    NSLog(@"orderRequestSucess:%@",res);
    [[VWProgressHUD shareInstance]dismiss];
    [self justShowAlert:LocalizeString(@"ORDERCOMPELTE") message:[NSString stringWithFormat:@"%@:%@",LocalizeString(@"ORDERNUMBER"),[res objectForKey:@"orderId"]]];
    
    [_tradeViewModel performSelector:@selector(getData:) withObject:_model.coinPairId afterDelay:0.5];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    NSLog(@"orderRequestFalid:%@",error.userInfo);
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

- (void)cancelOrder:(UIButton*)btn{
    NSMutableArray *actions = [NSMutableArray array];
    
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:LocalizeString(@"ALERT_CONFIRM") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[VWProgressHUD shareInstance]showLoading];
        NSArray *orderAry = [self.tradeViewModel getUserOrderAry];
        UserOrderModel *model = [orderAry objectAtIndex:btn.tag];
        [self.tradeViewModel cancelOder:model.orderId coinPair:self.model.coinPairId];
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:LocalizeString(@"ALERT_CANCEL") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       
    }];
    [actions addObject:okBtn];
    [actions addObject:cancelBtn];
    
    [self showAlert:@"" withMsg:LocalizeString(@"CONFIRMFORCANCEL") withActions:actions];
}

- (void)popTheCv:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return [_tradeViewModel numberOfRowsInSection] + 1;
    } else {
        NSArray *ary = [_tradeViewModel getCoinPairAry];
        return ary.count;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return 449;
    } else {
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
        if (height != nil) {
            return height.floatValue;
        } else {
            return 100;
        }
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        NSNumber *height = @(cell.frame.size.height);
        [self.heightAtIndexPath setObject:height forKey:indexPath];
    } else {
    
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        [_tradeView setMode:self.isHigh];
        [_tradeView setContent:self.model];
        return _tradeView;
    } else {
        UIView *viewe = [[UIView alloc]init];
        return viewe;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _tableView) {
        UIView *noBillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 89)];
        
        noBillView.backgroundColor = [UIColor colorWithHexString:@"212025"];
        if ([_tradeViewModel numberOfRowsInSection] < 1) {
            UILabel *noBillLabel = [[UILabel alloc]initWithFrame:noBillView.frame];
            [noBillLabel setText:LocalizeString(@"NOORDERFORNOW")];
            [noBillLabel setTextAlignment:NSTextAlignmentCenter];
            [noBillLabel setTextColor:[UIColor whiteColor]];
            [noBillView addSubview:noBillLabel];
        }
        return noBillView;
    } else {
        
        UIView *viewe = [[UIView alloc]init];
        return viewe;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        switch (indexPath.row) {
            case 0: {
                ExponentialCell *exCell = (ExponentialCell *)[tableView dequeueReusableCellWithIdentifier:exponentialCellIdentifier];
                [exCell.moreDetailBtn addTarget:self action:@selector(moreDetail:) forControlEvents:UIControlEventTouchUpInside];
                [exCell.contentView setBackgroundColor:[UIColor colorWithHexString:@"212025"]];
                [exCell setTitle:LocalizeString(@"ORDER_OPEN") subTitle:LocalizeString(@"ALL")];
                
                return exCell;
            }
                
            default:{
                EntrustNowViewCell *enCell = (EntrustNowViewCell *)[tableView dequeueReusableCellWithIdentifier:entrustNowViewCellIdentifier];
                enCell.cancelBtn.tag = indexPath.row - 1;
                [enCell.cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                NSArray *modelAry = [_tradeViewModel getUserOrderAry];
                enCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UserOrderModel *tModel = [modelAry objectAtIndex:indexPath.row - 1];
                [enCell setContent:tModel];
                return enCell;
            }
        }
    } else {
        NSArray *ary = [_tradeViewModel getCoinPairAry];
        ChoseCoinTableViewCell *ccCell = (ChoseCoinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:choseCoinTableViewCell];
        CoinPairModel *model = [ary objectAtIndex:indexPath.row];
        [ccCell setContent:model];
        return ccCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableView) {
        
    } else {
        NSArray *ary = [_tradeViewModel getCoinPairAry];
        CoinPairModel *model = [ary objectAtIndex:indexPath.row];
        self.model = model;
        [_tradeViewModel getData:self.model.coinPairId];
        [self coinTableViewAnimation:nil];
        [[VWProgressHUD shareInstance]showLoading];
    }
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
//        float bottomFix = isiPhoneX?88:44;
//        CGRect frame = CGRectMake(0, bottomFix + _tradeView.frame.size.height + 25, kScreenWidth, kScreenHeight - _tradeView.frame.size.height + 5 - bottomFix);
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UITableView *)coinTableView{
    if (_coinTableView == nil) {
        
        float bottomFix = isiPhoneX?88:44;
        CGRect frame = CGRectMake(0, bottomFix + 63, kScreenWidth, 0);
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
