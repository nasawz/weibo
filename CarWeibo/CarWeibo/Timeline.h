//
//  Timeline.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@class TimelineCell;

@interface Timeline : NSObject
{
	NSMutableArray* statuses;
    TweetType       type;
    int             insertPosition;
    int             since_id;
    int             page;
}

- (id)init;

- (int)restore:(TweetType)type all:(BOOL)flag;

- (int)countStatuses;
- (void)appendStatus:(Status*)status;
- (void)insertStatus:(Status*)status atIndex:(int)index;

- (Status*)statusAtIndex:(int)i;
- (Status*)statusById:(sqlite_int64)id;
- (Status*)lastStatus;

- (void)removeStatus:(Status*)status;
- (void)removeStatusAtIndex:(int)index;
- (void)removeLastStatus;
- (void)removeAllStatuses;

- (int)indexOfObject:(Status*)status;

- (void)updateFavorite:(Status*)status;

- (void)sortByDate;

- (TimelineCell*)getTimelineCell:(UITableView*)tableView atIndex:(int)index;

@end
