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

@interface MyAssetViewController () <MyAssetViewModelDelegate>

@property(nonatomic,strong)MyAssetViewModel *myAssetViewModel;
@property(nonatomic,strong)NSDictionary *assetInfo;

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
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self registerCells];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"212025"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)registerCells{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyAssetTableViewCell" bundle:nil] forCellReuseIdentifier:myassetCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CoinCanUseViewCell" bundle:nil] forCellReuseIdentifier:coinCanUseCellIdentifier];

}

- (void)getDataSucess:(NSDictionary*)info{
    _assetInfo = info;
    [self.tableView reloadData];
}

- (void)getDataFalid:(NSError *)error{
    [self dealWithErrorMsg:error];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_myAssetViewModel numberOfRowinSection] + 1;
}

#pragma mark - UITableViewDelegate


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
            
            [ccCell setContentWithAry:[ary objectAtIndex:indexPath.row - 1]];
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
            wdVc.assetInfo = _assetInfo;
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

@end
