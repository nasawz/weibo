//
//  CommentsTimelineController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-20.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "CommentsTimelineDataSource.h"

@interface CommentsTimelineController : UITableViewController {
    Status*             status;
    CommentsTimelineDataSource*     timelineDataSource;
    
    BOOL                        isLoaded;
    BOOL                        firstTimeToAppear;
}

@property (nonatomic, retain) CommentsTimelineDataSource* timelineDataSource;

- (id)initWithMessage:(Status*)status;

- (void)loadTimeline;

@end

