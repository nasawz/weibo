//
//  FriendsTimelineDataSource.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBConnect.h"
#import "TimelineDataSource.h"
#import "WZRefreshTableHeaderView.h"

@class FriendsTimelineController;

@interface FriendsTimelineDataSource : TimelineDataSource <UITableViewDataSource, UITableViewDelegate,WBRequestDelegate,WZRefreshTableHeaderDelegate> {
    FriendsTimelineController*  controller;
    TweetType               tweetType;
    int                     insertPosition;
    BOOL                    isRestored;
    BOOL _loading;
}
 
- (id)initWithController:(FriendsTimelineController*)controller tweetType:(TweetType)type;
- (void)getTimeline;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
