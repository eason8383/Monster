//
//  MyAssetViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/5.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "MyAssetViewController.h"
#import "MyAssetTableViewCell.h"
#import "CoinCanUseViewCell.h"
#import "ChargeViewController.h"
#import "WithdrawViewController.h"
#import "CapitalViewController.h"
#import "MyAssetViewModel.h"
#import "UserCoinQuantity.h"

@interface MyAssetViewController () <UITableViewDelegate,UITableViewDataSource,MyAssetViewModelDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MyAssetViewModel *myAssetViewModel;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典
@end

@implementation MyAssetViewController

static NSString *myassetCellIdentifier = @"myassetViewCell";
static NSString *coinCanUseCellIdentifier = @"coinCanUseViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资产";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self initial];
}

- (void)initial{
    _myAssetViewModel = [MyAssetViewModel sharedInstance];
    _myAssetViewModel.delegate = self;
    [_myAssetViewModel getData];
    
    [self registerCells];
}

- (void)loadView{
    [super loadView];
    
    [self.view addSubview:self.tableView];
}

- (void)registerCells{
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyAssetTableViewCell" bundle:nil] forCellReuseIdentifier:myassetCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"CoinCanUseViewCell" bundle:nil] forCellReuseIdentifier:coinCanUseCellIdentifier];
    
}

- (void)getDataSucess{
    [_tableView reloadData];
}

- (void)getDataFalid:(NSError *)error{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_myAssetViewModel numberOfRowinSection] + 1;
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
            MyAssetTableViewCell *maCell = (MyAssetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myassetCellIdentifier];
            [maCell setBtnTarget:self select:@selector(callVcCaseByBtnTag:)];
            NSDictionary *myAssetDic = [[NSUserDefaults standardUserDefaults]objectForKey:MYETH];
            [maCell setContent:myAssetDic];
            
            return maCell;
            
        }
            
        default:{
            CoinCanUseViewCell *ccCell = (CoinCanUseViewCell *)[tableView dequeueReusableCellWithIdentifier:coinCanUseCellIdentifier];
            NSArray *ary = [_myAssetViewModel getUserCoinQuantity];
            UserCoinQuantity *model = [ary objectAtIndex:indexPath.row - 1];
            [ccCell setContent:model];
            return ccCell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)callVcCaseByBtnTag:(UIButton*)btn{
    UIViewController *cV = [[UIViewController alloc]init];
    switch (btn.tag) {
        case 1:{
            ChargeViewController *cVc = [[ChargeViewController alloc]initWithNibName:@"ChargeViewController" bundle:nil];
            cV = cVc;
            
        }
            break;
        case 2:{
            
            WithdrawViewController *wdVc = [[WithdrawViewController alloc]initWithNibName:@"WithdrawViewController" bundle:nil];
            cV = wdVc;
        }
            break;
        case 3:{
            CapitalViewController *cdVc = [[CapitalViewController alloc]initWithNibName:@"CapitalViewController" bundle:nil];
            cV = cdVc;
        }
            break;
        default:
            break;
    }
    
//    cV.jz_navigationBarHidden = NO;
//    [cV setJz_navigationBarTintColor:[UIColor blackColor]];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backBtn];
    [self.navigationController pushViewController:cV animated:YES];
    
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
