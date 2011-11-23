//
//  TrendTimelineDataSource.h
//  ROIFestival
//
//  Created by zhe wang on 11-11-1.
//  Copyright (c) 2011年 Jade Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBConnect.h"
#import "TimelineDataSource.h"

@class TrendTimelineController;

@interface TrendTimelineDataSource : TimelineDataSource <UITableViewDataSource, UITableViewDelegate,WBRequestDelegate> {
    TrendTimelineController*  controller;
    TweetType               tweetType;
    int                     insertPosition;
    BOOL _loading;
    NSString * keyWords;
}

@property (nonatomic, retain) NSString * keyWords;


- (id)initWithController:(TrendTimelineController*)controller tweetType:(TweetType)type;
- (void)getTimeline;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)insertTweet:(id)result;

@end