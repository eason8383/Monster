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
#import "MarketViewController.h"
#import "TradeViewModel.h"
#import "CoinPairModel.h"
#import "UserOrderModel.h"

#define NOWBILL 1

@interface TradeViewController () <UITableViewDelegate,UITableViewDataSource,TradeViewModelDelegate>

@property(nonatomic,strong)TradeView *tradeView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)TradeViewModel *tradeViewModel;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@property UITapGestureRecognizer *tapRecognizer;

@end

@implementation TradeViewController

static NSString *exponentialCellIdentifier = @"ExponenCell";
static NSString *entrustNowViewCellIdentifier = @"EntrustNowViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)initial{
    
    _tradeViewModel = [TradeViewModel sharedInstance];
    _tradeViewModel.delegate = self;
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(firstResponder:)];
    _tapRecognizer.numberOfTapsRequired = 1;
    [_tradeView addGestureRecognizer:_tapRecognizer];
    
    [self registerCells];
}

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *backHomeBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissBackToHome:)];
    backHomeBtn.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setLeftBarButtonItem:backHomeBtn];
    
    [_tradeViewModel getData:_model.coinPairId];
}

- (void)loadView{
    [super loadView];
    
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TradeView" owner:self options:nil];
    
    _tradeView = [nib objectAtIndex:0];
    [_tradeView setMode:self.isHigh];
    [_tradeView setContent:self.model];
    [_tradeView.comfirmBtn addTarget:self action:@selector(orderRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tradeView];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_tradeView setFrame:CGRectMake(0, 0, kScreenWidth, 396)];
}

- (void)dismissBackToHome:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerCells{
    
    [_tableView registerNib:[UINib nibWithNibName:@"ExponentialCell" bundle:nil] forCellReuseIdentifier:exponentialCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"EntrustNowViewCell" bundle:nil] forCellReuseIdentifier:entrustNowViewCellIdentifier];
}

- (void)firstResponder:(id)sender{
    [_tradeView.stepperPriceField resignFirstResponder];
    [_tradeView.stepperVolumField resignFirstResponder];
}

- (void)moreDetail:(id)sender{
    MarketViewController *mVC = [[MarketViewController alloc]initWithNibName:@"MarketViewController" bundle:nil];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popTheCv:)];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void)getDataSucess{
    NSLog(@"Trade getDataSucess");
    [_tradeView setPriceCrew:[_tradeViewModel getBuyAry] saleAry:[_tradeViewModel getSaleAry]];
    [_tradeView setUerCoinQuantity:[_tradeViewModel getUserQuantityAry]];
}

- (void)getUserOrderSucess{
    [self.tableView reloadData];
}

- (void)orderRequest:(UIButton*)btn{
    
    if (_tradeView.stepperVolumField.text.length < 1 || _tradeView.stepperPriceField.text.length < 1) {
        [self justShowAlert:@"信息不完整" message:@"请将价格以及数量填写完成"];
    } else {
        [[VWProgressHUD shareInstance]showLoading];
        BOOL isBuy = _tradeView.isHighMode?YES:NO; //isHighMode = YES 就是买入
        float coinQuantity = [_tradeView.stepperVolumField.text floatValue];
        float orderPrice = [_tradeView.stepperPriceField.text floatValue];
        
        [_tradeViewModel oderRequest:self.model coinQuantity:coinQuantity orderPrice:orderPrice buyOrSale:isBuy];
    }
}

- (void)orderRequestSucess:(NSDictionary *)res{
    NSLog(@"orderRequestSucess:%@",res);
    [[VWProgressHUD shareInstance]dismiss];
    [self justShowAlert:@"委托成功" message:[NSString stringWithFormat:@"订单号:%@",[res objectForKey:@"orderId"]]];
    
    [_tradeViewModel getUserOrder:self.model.coinPairId];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    NSLog(@"orderRequestFalid:%@",error.userInfo);
    NSDictionary *dic = error.userInfo;
    NSDictionary *respCode = [dic objectForKey:@"respCode"];
    if ([[respCode objectForKey:@"code"]isEqualToString:@"00207"]) {
        [self justShowAlert:@"登陆会话无效" message:@"请重新登录"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    } else {
        [self justShowAlert:@"错误信息" message:[dic objectForKey:@"respMessage"]];
    }
}

- (void)cancelOrder:(id)sender{
    
}

- (void)popTheCv:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tradeViewModel numberOfRowsInSection] + 1;
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

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *noBillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 89)];
    
    noBillView.backgroundColor = [UIColor colorWithHexString:@"212025"];
    if ([_tradeViewModel numberOfRowsInSection] < 1) {
        UILabel *noBillLabel = [[UILabel alloc]initWithFrame:noBillView.frame];
        [noBillLabel setText:@"暂无委托单"];
        [noBillLabel setTextAlignment:NSTextAlignmentCenter];
        [noBillLabel setTextColor:[UIColor whiteColor]];
        [noBillView addSubview:noBillLabel];
    }
    return noBillView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0: {
            ExponentialCell *exCell = (ExponentialCell *)[tableView dequeueReusableCellWithIdentifier:exponentialCellIdentifier];
            [exCell.moreDetailBtn addTarget:self action:@selector(moreDetail:) forControlEvents:UIControlEventTouchUpInside];
            [exCell.contentView setBackgroundColor:[UIColor colorWithHexString:@"212025"]];
            [exCell setTitle:@"当前委托" subTitle:@"全部"];
            
            return exCell;
        }
        
        default:{
            EntrustNowViewCell *enCell = (EntrustNowViewCell *)[tableView dequeueReusableCellWithIdentifier:entrustNowViewCellIdentifier];
            enCell.subCoinId = self.model.subCoinId;
            [enCell.cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            NSArray *modelAry = [_tradeViewModel getUserOrderAry];
            UserOrderModel *tModel = [modelAry objectAtIndex:indexPath.row - 1];
            [enCell setContent:tModel];
            return enCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        float bottomFix = isiPhoneX?88:44;
        CGRect frame = CGRectMake(0, _tradeView.frame.size.height + 5, kScreenWidth, kScreenHeight - _tradeView.frame.size.height + 5 - bottomFix);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
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
