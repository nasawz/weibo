//
//  TrendsListViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-11-16.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "TrendsListViewController.h"
#import "CarWeiboAppDelegate.h"


@implementation TrendsListViewController

- (id)init {
    self = [super init];
    if (self) {
        trendslist = [[NSMutableArray alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 6, 320, 460 - 6) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        //        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        
    }
    return self;
}
- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTrends];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CarWeiboAppDelegate setTitle:@"热门话题"];
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    delegate.rootViewController.navigation.rightButton = nil;
    
    
    [[GANTracker sharedTracker] trackPageview:@"/trends"
                                    withError:nil];
}

/***********************************************************************************************************
 * MARK: 获取话题
 ***********************************************************************************************************
 输入参数: 
            
 ***********************************************************************************************************/
- (void)loadTrends {
    NSArray * trendsArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"trends"];
    if (trendsArr != nil) {
        [self initTableData:trendsArr];
        
    }
    
    client = [[IEVTClient alloc] initWithTarget:self action:@selector(trendsDidLoad:obj:)];
    [client getHottrends]; 
}
/***********************************************************************************************************
 * MARK: 实力话题数据
 ***********************************************************************************************************
 输入参数: 
        
 ***********************************************************************************************************/
- (void)trendsDidLoad:(IEVTClient*)c obj:(id)obj {
    client = nil;
    if ([obj isKindOfClass:[NSArray class]]) {
        //        NSLog(@"%@",obj);
        NSArray * arr = (NSArray*)obj;
        NSArray * trendsArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"trends"];
        if (trendsArr != nil) {
            
            if (![arr isEqualToArray:trendsArr]) {
                [self initializeTrends:arr];
                
                [self initTableData:arr];
            }
            
        }else{
            [self initializeTrends:arr];
            
            [self initTableData:arr];
        }
        
    }
}
/***********************************************************************************************************
 * MARK: 缓存话题
 ***********************************************************************************************************
 输入参数: 
        
 ***********************************************************************************************************/
- (void)initializeTrends:(NSArray *)arr {
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"trends"];
}
/***********************************************************************************************************
 * MARK:  填充TableView数据
 ***********************************************************************************************************
 输入参数: 
        
 ***********************************************************************************************************/
- (void)initTableData:(NSArray *)list {
    if ([list count] > 0) {
        
        [trendslist removeAllObjects];
        for (NSDictionary * nd in list) {
            [trendslist addObject:nd];
        }
        [_tableView reloadData];
    }
}
#pragma mark - 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [[GANTracker sharedTracker] trackEvent:@"TrendsListView"
                                    action:@"selectRow"
                                     label:@"row"
                                     value:[indexPath row]
                                 withError:nil];
    
    NSDictionary * dic = [[trendslist objectAtIndex:[indexPath row]] objectForKey:@"fields"];
    
    TrendsViewController * trendsViewController = [[TrendsViewController alloc] init];
    [trendsViewController setKeyWords:[dic objectForKey:@"key"]];
    //    NSLog(@"%@",[dic objectForKey:@"key"]);
    [self.navigationController pushViewController:trendsViewController animated:YES];
    //    [trendsViewController release];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [trendslist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary * dic = [[trendslist objectAtIndex:[indexPath row]] objectForKey:@"fields"];
    cell.textLabel.text = [dic objectForKey:@"title"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

@end
