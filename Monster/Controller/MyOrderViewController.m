//
//  MyOrderViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MyOrderViewController.h"
#import "EntrustNowViewCell.h"
#import "OrderHistoryViewController.h"

#define NOWCell 2

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典

@end

@implementation MyOrderViewController

static NSString *entrustNowViewCellIdentifier = @"EntrustNowViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当前委托";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self registerCells];
}

- (void)viewWillAppear:(BOOL)animated{
//    UIBarButtonItem *timeFilterBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"watch"] style:UIBarButtonItemStylePlain target:self action:@selector(showFilter:)];
    UIBarButtonItem *timeFilterBtn = [[UIBarButtonItem alloc]initWithTitle:@"历史委托>" style:UIBarButtonItemStylePlain target:self action:@selector(showHistory:)];
    timeFilterBtn.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItem:timeFilterBtn];
}

- (void)showHistory:(id)sender{
    OrderHistoryViewController *hisVc = [[OrderHistoryViewController alloc]initWithNibName:@"OrderHistoryViewController" bundle:nil];
    [self homeDefaultPushController:hisVc];
}

- (void)homeDefaultPushController:(UIViewController*)cV{
    cV.jz_navigationBarHidden = NO;
    [cV setJz_navigationBarTintColor:[UIColor blackColor]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:cV animated:YES];
}

- (void)loadView{
    [super loadView];
    
    [self.view addSubview:self.tableView];
}

- (void)registerCells{
    
    [_tableView registerNib:[UINib nibWithNibName:@"EntrustNowViewCell" bundle:nil] forCellReuseIdentifier:entrustNowViewCellIdentifier];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NOWCell;
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
    EntrustNowViewCell *enCell = (EntrustNowViewCell *)[tableView dequeueReusableCellWithIdentifier:entrustNowViewCellIdentifier];
    
    return enCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *noBillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 89)];
    
    noBillView.backgroundColor = [UIColor colorWithHexString:@"212025"];
    if (NOWCell < 1) {
        UILabel *noBillLabel = [[UILabel alloc]initWithFrame:noBillView.frame];
        [noBillLabel setText:@"暂无委托单"];
        [noBillLabel setTextAlignment:NSTextAlignmentCenter];
        [noBillLabel setTextColor:[UIColor whiteColor]];
        [noBillView addSubview:noBillLabel];
        
    }
    return noBillView;
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
