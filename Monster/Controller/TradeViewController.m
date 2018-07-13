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
#import "TrandModel.h"

#define NOWBILL 1

@interface TradeViewController () <UITableViewDelegate,UITableViewDataSource,TradeViewModelDelegate>

@property(nonatomic,strong)TradeView *tradeView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)TradeViewModel *tradeViewModel;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
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
    
    [self registerCells];
}

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *backHomeBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissBackToHome:)];
    backHomeBtn.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setLeftBarButtonItem:backHomeBtn];
    
    [_tradeViewModel getData:@"10001"];
}

- (void)loadView{
    [super loadView];
    
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TradeView" owner:self options:nil];
    
    _tradeView = [nib objectAtIndex:0];
//    [_tradeView setFrame:CGRectMake(0, 0, kScreenWidth, 396)];
    [_tradeView setMode:self.isHigh];
    [_tradeView setContent:self.model];
    [self.view addSubview:_tradeView];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_tradeView setFrame:CGRectMake(0, 0, kScreenWidth, 396)];
}

- (void)getDataSucess{
    NSLog(@"Trade getDataSucess");
}

- (void)dismissBackToHome:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerCells{
    
    [_tableView registerNib:[UINib nibWithNibName:@"ExponentialCell" bundle:nil] forCellReuseIdentifier:exponentialCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"EntrustNowViewCell" bundle:nil] forCellReuseIdentifier:entrustNowViewCellIdentifier];
}

- (void)moreDetail:(id)sender{
    MarketViewController *mVC = [[MarketViewController alloc]initWithNibName:@"MarketViewController" bundle:nil];
//        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"testPic"] style:UIBarButtonItemStylePlain target:self action:@selector(popTheCv:)];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popTheCv:)];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void)popTheCv:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NOWBILL;
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
    if (NOWBILL < 2) {
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
            
            return enCell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        CGRect frame = CGRectMake(0, _tradeView.frame.size.height + 5, kScreenWidth, kScreenHeight);
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
