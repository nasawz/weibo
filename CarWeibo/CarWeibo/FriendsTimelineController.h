//
//  FriendsTimelineController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeUtils.h"
#import "FriendsTimelineDataSource.h"
#import "WZRefreshTableHeaderView.h"

@interface FriendsTimelineController : UITableViewController {
    Stopwatch*                  stopwatch;
    int                         tab;
    int                         unread;
    BOOL                        isLoaded;
    BOOL                        firstTimeToAppear;
    FriendsTimelineDataSource*  timelineDataSource;
    CGPoint                     contentOffset;
    WZRefreshTableHeaderView * refreshHeaderView;
}

@property (nonatomic, retain) WZRefreshTableHeaderView * refreshHeaderView;

- (void)loadTimeline;
- (void)restoreAndLoadTimeline:(BOOL)load;
- (void)postTweetDidSucceed:(Status*)status;

- (IBAction)reload:(id)sender;



@end
