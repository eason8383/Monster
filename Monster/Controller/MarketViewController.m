//
//  MarketViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/4.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MarketViewController.h"
#import "ExponentialView.h"
#import "MarketTableViewCell.h"
#import "ExponentialView.h"
#import "HomeViewModel.h"
#import "CoinPairModel.h"

@interface MarketViewController () <UITableViewDelegate,UITableViewDataSource,HomeModelDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@property(nonatomic,strong)HomeViewModel *homeModel;
@property(nonatomic,strong)NSTimer *updatTimer;

@end

@implementation MarketViewController

static NSString *marketTableViewCellIdentifier = @"MarketViewCell";

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"行情";
    
    [self initial];
}

- (void)initial{
    _homeModel = [HomeViewModel sharedInstance];
    _homeModel.delegate = self;
    [self registerCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_homeModel getData:100];
    _updatTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                  repeats:YES block:^(NSTimer *timer){
                                                      [self.homeModel getData:1];
                                                  }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UINavigationBar appearance].translucent = YES;
    [_updatTimer invalidate];
    _updatTimer = nil;
}

- (void)loadView{
    [super loadView];
    [self.view addSubview:self.tableView];
    
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barTintColor = [UIColor colorWithHexString:@"1E1D21"];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
//    UIBarButtonItem *backHomeBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Fill_Copy"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissBackToHome:)];
//    backHomeBtn.tintColor = [UIColor whiteColor];
//    
//    [self.navigationItem setLeftBarButtonItem:backHomeBtn];
}

- (void)getDataSucess{
    [_tableView reloadData];
}

- (void)dismissBackToHome:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerCells{
    
    [_tableView registerNib:[UINib nibWithNibName:@"MarketTableViewCell" bundle:nil] forCellReuseIdentifier:marketTableViewCellIdentifier];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _homeModel.numberOfRowsInSection;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if (height) {
        return height.floatValue;
    } else {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MarketTableViewCell *mkCell = (MarketTableViewCell *)[tableView dequeueReusableCellWithIdentifier:marketTableViewCellIdentifier];
    NSArray *ary = [_homeModel getHomeDataArray];
    CoinPairModel *model = [ary objectAtIndex:indexPath.row];
    mkCell.multiple = [_homeModel getMultipleWithCurrentCoinId:model.subCoinId];
    [mkCell setContent:model];
    return mkCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExponentialView" owner:self options:nil];
    ExponentialView *view = [nib objectAtIndex:0];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
        //        _tableView.contentInset = UIEdgeInsetsMake(isiPhoneX?-44:-20, 0, 0, 0);
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
