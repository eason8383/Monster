//
//  MyOrderViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MyOrderViewController.h"
#import "EntrustNowViewCell.h"
#import "OrderDetailViewController.h"
#import "OrderHistoryViewController.h"
#import "MyOrderViewModel.h"
#import "TradeViewModel.h"
#import "UserOrderModel.h"
//#import "JZNavigationExtension.h"

@interface MyOrderViewController ()<MyOrderViewModelDelegate,TradeViewModelDelegate>

@property(nonatomic,strong)MyOrderViewModel *myOrderViewModel;
@property(nonatomic,strong)TradeViewModel *tradeViewModel;

@end

@implementation MyOrderViewController

static NSString *entrustNowViewCellIdentifier = @"EntrustNowViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当前委托";
    
    [self initial];
    [[VWProgressHUD shareInstance]showLoading];
    [_myOrderViewModel getData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    UIBarButtonItem *timeFilterBtn = [[UIBarButtonItem alloc]initWithTitle:@"历史委托>" style:UIBarButtonItemStylePlain target:self action:@selector(showHistory:)];
    timeFilterBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setRightBarButtonItem:timeFilterBtn];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)showHistory:(id)sender{
    OrderHistoryViewController *hisVc = [[OrderHistoryViewController alloc]initWithNibName:@"OrderHistoryViewController" bundle:nil];
    [self homeDefaultPushController:hisVc];
}

- (void)homeDefaultPushController:(UIViewController*)cV{
//    cV.jz_navigationBarHidden = NO;
//    [cV setJz_navigationBarTintColor:[UIColor blackColor]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:cV animated:YES];
}

- (void)getDataSucess{
    [[VWProgressHUD shareInstance]dismiss];
    [self.tableView reloadData];
}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    [self dealWithErrorMsg:error];
}

- (void)orderCancelSucess:(NSDictionary*)res{
    [[VWProgressHUD shareInstance]showLoading];
    [_myOrderViewModel getData];
}

- (void)initial{
    
    _myOrderViewModel = [MyOrderViewModel sharedInstance];
    _myOrderViewModel.delegate = self;
    
    _tradeViewModel = [TradeViewModel sharedInstance];
    _tradeViewModel.delegate = self;
    
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    [self registerCells];
    
}

- (void)getUserOrderSucess{
    [[VWProgressHUD shareInstance]dismiss];
}

- (void)registerCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EntrustNowViewCell" bundle:nil] forCellReuseIdentifier:entrustNowViewCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"94 here :%ld",(long)[_myOrderViewModel numberOfRowsInSection]);
    return [_myOrderViewModel numberOfRowsInSection];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntrustNowViewCell *enCell = (EntrustNowViewCell *)[tableView dequeueReusableCellWithIdentifier:entrustNowViewCellIdentifier];
    NSArray *orderAry = [_myOrderViewModel getOrderAry];
    UserOrderModel *model = [orderAry objectAtIndex:indexPath.row];
    enCell.cancelBtn.tag = indexPath.row;
    [enCell.cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    [enCell setContent:model];
    return enCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDetailViewController *odVc = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
    NSArray *orderAry = [_myOrderViewModel getOrderAry];
    odVc.userOrderInfo = [orderAry objectAtIndex:indexPath.row];
    [self homeDefaultPushController:odVc];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *noBillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 89)];
    
    noBillView.backgroundColor = [UIColor colorWithHexString:@"212025"];
    if ([_myOrderViewModel numberOfRowsInSection] < 1) {
        UILabel *noBillLabel = [[UILabel alloc]initWithFrame:noBillView.frame];
        [noBillLabel setText:@"暂无委托单"];
        [noBillLabel setTextAlignment:NSTextAlignmentCenter];
        [noBillLabel setTextColor:[UIColor whiteColor]];
        [noBillView addSubview:noBillLabel];
        
    }
    return noBillView;
}

- (void)cancelOrder:(UIButton*)btn{
    NSMutableArray *actions = [NSMutableArray array];
    
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[VWProgressHUD shareInstance]showLoading];
        NSArray *orderAry = [self.myOrderViewModel getOrderAry];
        UserOrderModel *orderModel = [orderAry objectAtIndex:btn.tag];
        [self.tradeViewModel cancelOder:orderModel.orderId coinPair:orderModel.coinPairId];
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
    }];
    [actions addObject:okBtn];
    [actions addObject:cancelBtn];
    
    [self showAlert:@"" withMsg:@"你确定要撤销此笔订单吗?" withActions:actions];
}

@end
