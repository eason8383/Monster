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
#import "SGLoadMoreView.h"
//#import "JZNavigationExtension.h"

#define BLACKBG @"1E1D21"

@interface MyOrderViewController ()<MyOrderViewModelDelegate,TradeViewModelDelegate>

@property(nonatomic,strong)MyOrderViewModel *myOrderViewModel;
@property(nonatomic,strong)TradeViewModel *tradeViewModel;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,strong)SGLoadMoreView *loadMoreView;
@property (strong,nonatomic)NSMutableArray *orderAry;

@end

@implementation MyOrderViewController

static NSString *entrustNowViewCellIdentifier = @"EntrustNowViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizeString(@"ORDER_OPEN");
    
    [self initial];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *timeFilterBtn = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%@>",LocalizeString(@"ORDER_HISTORY")] style:UIBarButtonItemStylePlain target:self action:@selector(showHistory:)];
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
    NSArray *ary = [_myOrderViewModel getOrderAry];
    if (ary.count > 0 ) {
        if (_currentPage == 1 && ary.count < 10) { //因為是refresh
            [_orderAry removeAllObjects];
            _loadMoreView.titleLabel.hidden = YES;
            
        } else {
            _loadMoreView.titleLabel.hidden = NO;
            [_orderAry removeAllObjects];
            [_loadMoreView restartLoadData];
        }
        [self.orderAry addObjectsFromArray:ary];
        [_loadMoreView stopAnimation];
        
    } else {
        [_loadMoreView noMoreData];
    }
    
    [self.tableView.refreshControl endRefreshing];
    [self.tableView reloadData];
    //    [_orderAry addObject:[_myOrderViewModel getOrderAry]];
    [[VWProgressHUD shareInstance]dismiss];

}

- (void)getDataFalid:(NSError *)error{
    [[VWProgressHUD shareInstance]dismiss];
    [self dealWithErrorMsg:error];
}

- (void)orderCancelSucess:(NSDictionary*)res{
    [[VWProgressHUD shareInstance]dismiss];
    
    if (self.orderAry.count == 1) {
        [self.orderAry removeAllObjects];
    }
    
    [self performSelector:@selector(reloadMyOrder) withObject:nil afterDelay:0.5];
}

- (void)reloadMyOrder{
    _currentPage = 1;
    [_myOrderViewModel getData:_currentPage];
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
    
    //refresh 下拉更新View
    UIRefreshControl *control = [[UIRefreshControl alloc]init];
    
    [control addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = control;
    
    //上推更新View
    _loadMoreView = [[SGLoadMoreView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.tableView.tableFooterView = self.loadMoreView;
    [self registerCells];
    
    [[VWProgressHUD shareInstance]showLoading];
    [self reloadMyOrder];
    
}

- (void)refresh:(id)sender{
    
    _currentPage = 1;
    [self.orderAry removeAllObjects];
    [_myOrderViewModel getData:_currentPage];
}

- (void)loadMore{
    //add load more
    
    _currentPage += 1;
    [_myOrderViewModel getData:_currentPage];
}

- (void)registerCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EntrustNowViewCell" bundle:nil] forCellReuseIdentifier:entrustNowViewCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"94 here :%ld",(long)[_myOrderViewModel numberOfRowsInSection]);
//    return [_myOrderViewModel numberOfRowsInSection];
//    NSArray *ary = [_myOrderViewModel getOrderAry];
    return self.orderAry.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntrustNowViewCell *enCell = (EntrustNowViewCell *)[tableView dequeueReusableCellWithIdentifier:entrustNowViewCellIdentifier];

    UserOrderModel *model = [self.orderAry objectAtIndex:indexPath.row];
    enCell.cancelBtn.tag = indexPath.row;
    [enCell.cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    [enCell setContent:model];
    return enCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDetailViewController *odVc = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];

    odVc.userOrderInfo = [self.orderAry objectAtIndex:indexPath.row];
    [self homeDefaultPushController:odVc];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *noBillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 89)];
    
    noBillView.backgroundColor = [UIColor colorWithHexString:BLACKBG];
//    noBillView.backgroundColor = [UIColor blackColor];
    if (self.orderAry.count < 1) {
        UILabel *noBillLabel = [[UILabel alloc]initWithFrame:noBillView.frame];
        [noBillLabel setText:LocalizeString(@"NOORDERFORNOW")];
        [noBillLabel setTextAlignment:NSTextAlignmentCenter];
        [noBillLabel setTextColor:[UIColor whiteColor]];
        [noBillView addSubview:noBillLabel];
        _loadMoreView.hidden = YES;
    } else {
        _loadMoreView.hidden = NO;
    }
    return noBillView;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    /*self.refreshControl.isRefreshing == NO加这个条件是为了防止下面的情况发生：
     每次进入UITableView，表格都会沉降一段距离，这个时候就会导致currentOffsetY + scrollView.frame.size.height   > scrollView.contentSize.height 被触发，从而触发loadMore方法，而不会触发refresh方法。
     */
    NSLog(@"currentOffsetY:%f ,_tableView.contentSize.height:%f ",currentOffsetY,self.tableView.contentSize.height);
    if ( currentOffsetY + self.tableView.frame.size.height  > self.tableView.contentSize.height - 50 &&  self.tableView.refreshControl.isRefreshing == NO  && self.loadMoreView.isAnimating == NO && self.loadMoreView.tipsLabel.isHidden && self.orderAry.count > 0) {
        [self.loadMoreView startAnimation];//开始旋转菊花
        [self loadMore];
    }
    NSLog(@"%@ ---%f----%f",NSStringFromCGRect(scrollView.frame),currentOffsetY,scrollView.contentSize.height);
}

- (void)cancelOrder:(UIButton*)btn{
    NSMutableArray *actions = [NSMutableArray array];
//    "ALERT_CONFIRM" = "OK";
//    "ALERT_SUBMIT" = "Confirm";
//    "ALERT_CANCEL" = "Cancel";
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:LocalizeString(@"ALERT_CONFIRM") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[VWProgressHUD shareInstance]showLoading];

        UserOrderModel *orderModel = [self.orderAry objectAtIndex:btn.tag];
        [self.tradeViewModel cancelOder:orderModel.orderId coinPair:orderModel.coinPairId];
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:LocalizeString(@"ALERT_CANCEL") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
    }];
    [actions addObject:okBtn];
    [actions addObject:cancelBtn];
    
    [self showAlert:@"" withMsg:LocalizeString(@"CONFIRMFORCANCEL") withActions:actions];
}

- (NSMutableArray*)orderAry{
    if (_orderAry == nil) {
        _orderAry = [NSMutableArray array];
    }
    return _orderAry;
}

@end
