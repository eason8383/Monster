//
//  MRBaseTableViewController.h
//  Monster
//
//  Created by CHEN HAO LI on 2018/7/18.
//  Copyright © 2018年 Tigerrose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRBaseTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度所用字典

- (void)dealWithErrorMsg:(NSError*)error;

@end
