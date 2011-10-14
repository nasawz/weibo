//
//  TimelineDataSource.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TimelineDataSource.h"
#import "CarWeiboAppDelegate.h"

@implementation TimelineDataSource

@synthesize timeline;
@synthesize contentOffset;

- (id)init
{
    [super init];
    loadCell = [[LoadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadCell"];
    timeline   = [[Timeline alloc] init];
    return self;
}

- (void)dealloc {
    [weibo cancel];
    [weibo release];
    [loadCell release];
    [timeline release];
	[super dealloc];
}

- (void)cancel
{
    if (weibo) {
        [weibo cancel];
        weibo = nil;
    }
}

- (void)removeAllStatuses
{
    [timeline removeAllStatuses];
}

@end

