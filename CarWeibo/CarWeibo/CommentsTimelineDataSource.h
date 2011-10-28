//
//  CommentsTimelineDataSource.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-20.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBConnect.h"
#import "TimelineDataSource.h"
#import "Status.h"

@class CommentsTimelineController;

@interface CommentsTimelineDataSource : TimelineDataSource <UITableViewDataSource,UITableViewDelegate,WBRequestDelegate> {
    CommentsTimelineController*         controller;
    int                     insertPosition;
    BOOL                    isRestored;
    BOOL _loading;
	NSMutableArray* comments;
    UITableViewCell*            endCell;

}

@property (nonatomic, retain)NSMutableArray* comments;

- (id)initWithController:(CommentsTimelineController*)controller;

- (void)getTimelineWithStatus:(Status*)status ;

- (void)insertComment:(id)result;

@end
