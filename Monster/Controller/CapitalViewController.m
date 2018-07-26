//
//  CapitalViewController.m
//  Monster
//
//  Created by eason's macbook on 2018/7/6.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import "CapitalViewController.h"
#import "CapitalDetailsViewCell.h"
#import "MyAssetViewModel.h"


@interface CapitalViewController () <MyAssetViewModelDelegate>
@property(nonatomic,strong)MyAssetViewModel *myAssetViewModel;

@end

@implementation CapitalViewController
static NSString *capitalDetailsCellIdentifier = @"capitalDetailsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金纪录";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self initial];
}

- (void)initial{
    _myAssetViewModel = [MyAssetViewModel sharedInstance];
    _myAssetViewModel.delegate = self;
    [_myAssetViewModel getUserCoinInOutInfo];
    [self registerCells];
}

- (void)loadView{
    [super loadView];
    
}

- (void)getUserCoinInOutInfoSucess{
    [self.tableView reloadData];
}

- (void)getDataFalid:(NSError *)error{
    [self dealWithErrorMsg:error];
}

- (void)registerCells{
    [self.tableView registerNib:[UINib nibWithNibName:@"CapitalDetailsViewCell" bundle:nil] forCellReuseIdentifier:capitalDetailsCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_myAssetViewModel numberOfRowinSectionForCapital];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CapitalDetailsViewCell *cdCell = (CapitalDetailsViewCell *)[tableView dequeueReusableCellWithIdentifier:capitalDetailsCellIdentifier];
    NSArray *hisAry = [_myAssetViewModel getUserCoinInOutHistory];
    UserOrderModel *order = [hisAry objectAtIndex:indexPath.row];
    [cdCell setContent:order];
    return cdCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *noBillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 89)];

    noBillView.backgroundColor = [UIColor colorWithHexString:@"212025"];
    if ([_myAssetViewModel numberOfRowinSectionForCapital] < 1) {
        UILabel *noBillLabel = [[UILabel alloc]initWithFrame:noBillView.frame];
        [noBillLabel setText:@"暂无纪录"];
        [noBillLabel setTextAlignment:NSTextAlignmentCenter];
        [noBillLabel setTextColor:[UIColor whiteColor]];
        [noBillView addSubview:noBillLabel];
        
    }
    return noBillView;
}
@end
