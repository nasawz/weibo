//
//  UserTimelineController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-28.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeUtils.h"
#import "UserTimelineDataSource.h"
#import "WZRefreshTableHeaderView.h"
#import "User.h"

@interface UserTimelineController : UITableViewController {
    Stopwatch*                  stopwatch;
    int                         tab;
    int                         unread;
    BOOL                        isLoaded;
    BOOL                        firstTimeToAppear;
    UserTimelineDataSource*  timelineDataSource;
    CGPoint                     contentOffset;
    WZRefreshTableHeaderView * refreshHeaderView;
    UINavigationController * navController;
    User * user;
}

@property (nonatomic, retain) WZRefreshTableHeaderView * refreshHeaderView;
@property (nonatomic, retain) UINavigationController *      navController;

- (void)loadTimeline;
- (void)restoreAndLoadTimeline:(BOOL)load;
- (void)postTweetDidSucceed:(Status*)status;

- (IBAction)reload:(id)sender;

- (id)initWithNavController:(UINavigationController *)controller User:(User *)user;
@end
