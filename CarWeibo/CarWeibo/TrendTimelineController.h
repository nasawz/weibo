//
//  TrendTimelineController.h
//  ROIFestival
//
//  Created by zhe wang on 11-11-1.
//  Copyright (c) 2011年 Jade Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeUtils.h"
#import "TrendTimelineDataSource.h"

@interface TrendTimelineController : UITableViewController {
    Stopwatch*                  stopwatch;
    int                         tab;
    int                         unread;
    BOOL                        isLoaded;
    BOOL                        firstTimeToAppear;
    TrendTimelineDataSource*  timelineDataSource;
    CGPoint                     contentOffset;
//    WZRefreshTableHeaderView * refreshHeaderView;
    UINavigationController * navController;
    NSString * keyWords;
}

@property (nonatomic, retain) NSString * keyWords;
//@property (nonatomic, retain) WZRefreshTableHeaderView * refreshHeaderView;
@property (nonatomic, retain) UINavigationController *      navController;
@property (nonatomic, retain) TrendTimelineDataSource *      timelineDataSource;

- (void)loadTimeline;
- (void)restoreAndLoadTimeline:(BOOL)load;
- (void)postTweetDidSucceed:(Status*)status;

- (IBAction)reload:(id)sender;

- (id)initWithNavController:(UINavigationController *)controller;

@end
