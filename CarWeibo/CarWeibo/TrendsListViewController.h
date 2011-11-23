//
//  TrendsListViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-11-16.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEVTClient.h"
#import "TrendsViewController.h"

@interface TrendsListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IEVTClient*         client;
    NSMutableArray*     trendslist;
    UITableView*        _tableView;
}

- (void)loadTrends;

- (void)initializeTrends:(NSArray *)dic;

- (void)initTableData:(NSArray *)list;


@end
