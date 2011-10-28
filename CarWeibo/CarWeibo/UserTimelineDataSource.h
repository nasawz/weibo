//
//  UserTimelineDataSource.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-28.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBConnect.h"
#import "TimelineDataSource.h"
#import "WZRefreshTableHeaderView.h"
#import "User.h"

@class UserTimelineController;

@interface UserTimelineDataSource : TimelineDataSource <UITableViewDataSource, UITableViewDelegate,WBRequestDelegate,WZRefreshTableHeaderDelegate> {
    UserTimelineController*  controller;
    TweetType               tweetType;
    int                     insertPosition;
    BOOL                    isRestored;
    BOOL _loading;
    User *  user;
}

- (id)initWithController:(UserTimelineController*)controller tweetType:(TweetType)type User:(User *)user;
- (void)getTimeline;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
