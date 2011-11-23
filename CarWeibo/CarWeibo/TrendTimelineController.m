//
//  TrendTimelineController.m
//  ROIFestival
//
//  Created by zhe wang on 11-11-1.
//  Copyright (c) 2011年 Jade Studio. All rights reserved.
//

#import "TrendTimelineController.h"
#import "CarWeiboAppDelegate.h"
#import "ColorUtils.h"

@interface TrendTimelineController (Private)
- (void)scrollToFirstUnread;
@end

@implementation TrendTimelineController
@synthesize navController;
@synthesize timelineDataSource;
@synthesize keyWords;

- (id)initWithNavController:(UINavigationController *)controller {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        navController = controller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    NSLog(@"2 %@",keyWords);
    
    timelineDataSource = [[TrendTimelineDataSource alloc] initWithController:self tweetType:tab];
    [timelineDataSource setKeyWords:keyWords];
    self.tableView.dataSource = timelineDataSource;
    self.tableView.delegate   = timelineDataSource;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    if (!isLoaded) {
        
        
        [self loadTimeline];
        //        [self restoreAndLoadTimeline:YES];
    }
    
}


- (void) dealloc
{
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [self.tableView setContentOffset:contentOffset animated:false];
    [self.tableView reloadData];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    
    //    self.navigationController.navigationBar.tintColor = [UIColor navigationColorForTab:tab];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (firstTimeToAppear) {
        firstTimeToAppear = false;
        [self scrollToFirstUnread];
    }
	[super viewDidAppear:animated];
    if (stopwatch) {
        LAP(stopwatch, @"viewDidAppear");
        [stopwatch release];
        stopwatch = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    contentOffset = self.tableView.contentOffset;
}

- (void)viewDidDisappear:(BOOL)animated 
{
}

//
// Public methods
//
- (void)loadTimeline
{
    [timelineDataSource getTimeline];
    isLoaded = true;
}

- (void)restoreAndLoadTimeline:(BOOL)load
{
    firstTimeToAppear = true;
    stopwatch = [[Stopwatch alloc] init];
    tab       = 0;
    
    if (load) [self loadTimeline];
}

- (IBAction) reload:(id) sender
{
    //    self.navigationItem.leftBarButtonItem.enabled = false;
    [timelineDataSource getTimeline];
}

- (void)autoRefresh
{
    [self reload:nil];
}

- (void)postViewAnimationDidFinish
{
//    if (self.navigationController.topViewController != self) return;
//    
//    
//    if (tab == TAB_FRIENDS) {
//        //
//        // Do animation if the controller displays friends timeline or sent direct messages.
//        //
//        NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil];
//        [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableView endUpdates];
//    }
    
}

- (void)postTweetDidSucceed:(Status*)status
{
//    if (tab == TAB_FRIENDS) {
//        [timelineDataSource.timeline insertStatus:status atIndex:0];
//    }
}

//
// TwitterFonApPDelegate delegate
//
//- (void)didLeaveTab:(UINavigationController*)navigationController
//{
//    navigationController.tabBarItem.badgeValue = nil;
//    for (int i = 0; i < [timelineDataSource.timeline countStatuses]; ++i) {
//        Status* sts = [timelineDataSource.timeline statusAtIndex:i];
//        sts.unread = false;
//    }
//    unread = 0;
//}


- (void) removeStatus:(Status*)status
{
    [timelineDataSource.timeline removeStatus:status];
    [self.tableView reloadData];
}

- (void) updateFavorite:(Status*)status
{
    [timelineDataSource.timeline updateFavorite:status];
}

- (void)scrollToFirstUnread
{
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoScrollToFirstUnread"];
    if (flag == false) return;
    
    if (unread) {
        if (unread < [timelineDataSource.timeline countStatuses]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:unread inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionBottom animated:true];
        }
    }
}

//
// TimelineDelegate
//
- (void)timelineDidUpdate:(TrendTimelineDataSource*)sender count:(int)count insertAt:(int)position
{
    //    self.navigationItem.leftBarButtonItem.enabled = true;
    //    
    //    if (self.navigationController.tabBarController.selectedIndex == tab &&
    //        self.navigationController.topViewController == self) {
    
    [self.tableView beginUpdates];
    if (position) {
        NSMutableArray *deletion = [[[NSMutableArray alloc] init] autorelease];
        [deletion addObject:[NSIndexPath indexPathForRow:position inSection:0]];
        [self.tableView deleteRowsAtIndexPaths:deletion withRowAnimation:UITableViewRowAnimationBottom];
    }
    if (count != 0) {
        NSMutableArray *insertion = [[[NSMutableArray alloc] init] autorelease];
        
        int numInsert = count;
        // Avoid to create too many table cell.
        //            if (numInsert > 8) numInsert = 8;
        for (int i = 0; i < numInsert; ++i) {
            [insertion addObject:[NSIndexPath indexPathForRow:position + i inSection:0]];
        }        
        [self.tableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
    
    if (position == 0 && unread == 0) {
        [self performSelector:@selector(scrollToFirstUnread) withObject:nil afterDelay:0.4];
    }
    //    }
    if (count) {
        unread += count;
        //        [self navigationController].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unread];
    }
}

- (void)timelineDidFailToUpdate:(TrendTimelineDataSource*)sender position:(int)position
{
    //    self.navigationItem.leftBarButtonItem.enabled = true;
}

- (void)setKeyWords:(NSString *)aKeyWords {
    keyWords = [aKeyWords retain];
}
@end
