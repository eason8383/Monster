//
//  OrderHistoryViewController.m
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/7.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "CapitalDetailsViewCell.h"
#import "OrderDetailViewController.h"
#import "MyOrderViewModel.h"
#import "SGLoadMoreView.h"

@interface OrderHistoryViewController () <UITableViewDelegate,UITableViewDataSource,MyOrderViewModelDelegate>
@property(nonatomic,strong)MyOrderViewModel *myOrderViewModel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@property(nonatomic,assign)int currentPage;
@property (strong,nonatomic)SGLoadMoreView *loadMoreView;
@property (strong,nonatomic)NSMutableArray *orderHistoryAry;
@end

@implementation OrderHistoryViewController

static NSString *capitalViewCellIdentifier = @"capitalDeViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史委托";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self initial];
}

- (void)initial{
    _myOrderViewModel = [MyOrderViewModel sharedInstance];
    _myOrderViewModel.delegate = self;
    
    //refresh 下拉更新View
    UIRefreshControl *control = [[UIRefreshControl alloc]init];
    
    [control addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    _tableView.refreshControl = control;
    
    //上推更新View
    _loadMoreView = [[SGLoadMoreView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    _tableView.tableFooterView = self.loadMoreView;
    [self registerCells];
    
    _currentPage = 1;
    [_myOrderViewModel getOrderHistory:_currentPage];
}

- (void)getDataSucess{
    NSArray *ary = [_myOrderViewModel getOrderHistoryAry];
    if (ary.count > 0) {
        if (_currentPage == 1) { //因為是refresh
            
            [self.orderHistoryAry removeAllObjects];
            [_loadMoreView restartLoadData];
        }
        [_orderHistoryAry addObjectsFromArray:[_myOrderViewModel getOrderHistoryAry]];
        [_loadMoreView stopAnimation];
        [_tableView reloadData];
    } else {
        [_loadMoreView noMoreData];
    }
    [_tableView.refreshControl endRefreshing];
}

- (void)loadView{
    [super loadView];
    [self.view addSubview:self.tableView];
    
}

- (void)refresh:(id)sender{
    NSLog(@"reload oh");
//    if ([self.internetReachability currentReachabilityStatus] != NotReachable) {
        _currentPage = 1;
        [_myOrderViewModel getOrderHistory:_currentPage];
//    } else {
//
//        [_tableView.refreshControl endRefreshing];
//    }
}

- (void)registerCells{
    
    [_tableView registerNib:[UINib nibWithNibName:@"CapitalDetailsViewCell" bundle:nil] forCellReuseIdentifier:capitalViewCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderHistoryAry.count;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if (height != nil) {
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
    
    CapitalDetailsViewCell *cdCell = (CapitalDetailsViewCell *)[tableView dequeueReusableCellWithIdentifier:capitalViewCellIdentifier];
    UserOrderModel *userOrderInfo = [self.orderHistoryAry objectAtIndex:indexPath.row];
    [cdCell setContent:userOrderInfo];
    return cdCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDetailViewController *odVc = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
    UserOrderModel *model = [_orderHistoryAry objectAtIndex:indexPath.row];
    odVc.userOrderInfo = model;
    [self homeDefaultPushController:odVc];
}

- (void)homeDefaultPushController:(UIViewController*)cV{
    cV.jz_navigationBarHidden = NO;
    [cV setJz_navigationBarTintColor:[UIColor blackColor]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:cV animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    /*self.refreshControl.isRefreshing == NO加这个条件是为了防止下面的情况发生：
     每次进入UITableView，表格都会沉降一段距离，这个时候就会导致currentOffsetY + scrollView.frame.size.height   > scrollView.contentSize.height 被触发，从而触发loadMore方法，而不会触发refresh方法。
     */
    NSLog(@"currentOffsetY:%f ,_tableView.contentSize.height:%f ",currentOffsetY,_tableView.contentSize.height);
    if ( currentOffsetY + _tableView.frame.size.height  > _tableView.contentSize.height - 50 &&  _tableView.refreshControl.isRefreshing == NO  && self.loadMoreView.isAnimating == NO && self.loadMoreView.tipsLabel.isHidden && _orderHistoryAry.count > 0) {
        [self.loadMoreView startAnimation];//开始旋转菊花
        [self loadMore];
    }
    NSLog(@"%@ ---%f----%f",NSStringFromCGRect(scrollView.frame),currentOffsetY,scrollView.contentSize.height);
}

- (void)loadMore{
    //add load more
    
    _currentPage += 1;
    [_myOrderViewModel getOrderHistory:_currentPage];

}

- (UITableView *)tableView{
    if (_tableView == nil) {
        float bottonFix = isiPhoneX?88:64;
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-bottonFix);
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

- (NSMutableArray*)orderHistoryAry{
    if (_orderHistoryAry == nil) {
        _orderHistoryAry = [NSMutableArray array];
    }
    return _orderHistoryAry;
}

@end
