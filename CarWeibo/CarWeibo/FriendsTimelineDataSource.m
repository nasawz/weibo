//
//  FriendsTimelineDataSource.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FriendsTimelineDataSource.h"
#import "CarWeiboAppDelegate.h"
//#import "TweetViewController.h"
#import "TweetInfoViewController.h"
//#import "ProfileViewController.h"
#import "FriendsTimelineController.h"

#import "TimelineCell.h"
#import "DBConnection.h"

#import "DebugUtils.h"
#import "JSON.h"

@interface NSObject (TimelineViewControllerDelegate)
- (void)timelineDidUpdate:(FriendsTimelineDataSource*)sender count:(int)count insertAt:(int)position;
- (void)timelineDidFailToUpdate:(FriendsTimelineDataSource*)sender position:(int)position;
@end

@implementation FriendsTimelineDataSource

- (id)initWithController:(FriendsTimelineController*)aController tweetType:(TweetType)type {
    [super init];
    
    controller = aController;
    tweetType  = type;
    [loadCell setType:MSG_TYPE_LOAD_MORE_FRIENDS];
    isRestored = ([timeline restore:tweetType all:NO] < 20) ? YES : NO;
    return self; 
}


- (void)dealloc {
	[super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [timeline countStatuses];
    count = (isRestored) ? count : count + 1;
    return count;
}

//
// UITableViewDelegate
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h;
    Status* sts = [timeline statusAtIndex:indexPath.row];
    if (sts) {
        if (sts.cellHeight < 73) {
            h = 73;
        }else{
            h = sts.cellHeight;
        }
    }else{
        h = 78;
    }
    return h;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineCell* cell = [timeline getTimelineCell:tableView atIndex:indexPath.row];
    if (cell) {
        return cell;
    }
    else {
        return loadCell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Status* sts = [timeline statusAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];  
    
    if (sts) {
        // Display user view
        //
        TweetInfoViewController* tweetInfoView = [[[TweetInfoViewController alloc] initWithMessage:sts] autorelease];
        
//        NSLog(@"%@",[controller parentViewController]);
        
        [controller.navController pushViewController:tweetInfoView animated:TRUE];
    }      
    else {
        // Restore tweets from DB
        //
        int count = [timeline restore:tweetType all:NO];
        
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        [tableView beginUpdates];
        // Avoid to create too many table cell.
        if (count > 0) {
            //            if (count > 2) count = 2;
            for (int i = 0; i < count; ++i) {
                [newPath addObject:[NSIndexPath indexPathForRow:i + indexPath.row inSection:0]];
            }        
            [tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        }
        else {
            [newPath addObject:indexPath];
            isRestored = YES;
            [tableView deleteRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationLeft];
        }
        [tableView endUpdates];
    }
     
}


- (void)getTimeline
{
    if (weibo) return;
	weibo = [[WeiBo alloc] init];
    
    insertPosition = 0;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    int since_id = 0;
    for (int i = 0; i < [timeline countStatuses]; ++i) {
        Status* sts = [timeline statusAtIndex:i];
        
//        NSLog(@"===>sts.user.screenName = %@",sts.user.screenName);
        
        if ([CarWeiboAppDelegate isMyScreenName:sts.user.screenName] == false) {
            since_id = sts.statusId;
            break;
        }
    }
    
    if (since_id) {
        [param setObject:[NSString stringWithFormat:@"%d", since_id] forKey:@"since_id"];
        [param setObject:@"200" forKey:@"count"];
    }
    //    [param setObject:@"1" forKey:@"count"];
    [weibo getDefaultFriendsTimelineWithParams:param andDelegate:self];
}

- (void)request:(WBRequest *)request didLoad:(id)result {
//    NSString *urlString = request.url;
//    NSLog(@"%@",urlString);
//	if ([urlString rangeOfString:@"statuses/public_timeline"].location !=  NSNotFound)
//	{
//		NSLog(@"%@",result);
//	}
    
    weibo = nil;
    [loadCell.spinner stopAnimating];
    
    NSArray *ary = nil;
    if ([result isKindOfClass:[NSArray class]]) {
        ary = (NSArray*)result;
    }
    else {
        return;
    }    
    int unread = 0;
    LOG(@"Received %d tweets on tab %d", [ary count], tweetType);  
    Status* lastStatus = [timeline lastStatus];
    if ([ary count]) {
        [DBConnection beginTransaction];
        // Add messages to the timeline
        for (int i = [ary count] - 1; i >= 0; --i) {
            NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            sqlite_int64 statusId = [[[ary objectAtIndex:i] objectForKey:@"id"] longLongValue];
            if (![Status isExists:statusId type:tweetType]) {
                Status* sts = [Status statusWithJsonDictionary:[ary objectAtIndex:i] type:tweetType];
                if (sts.createdAt < lastStatus.createdAt) {
                    // Ignore stale message
                    continue;
                }
                [sts insertDB];
                sts.unread = true;
                [timeline insertStatus:sts atIndex:insertPosition];
                ++unread;
            }
        }
        [DBConnection commitTransaction];
    }
    
    if ([controller respondsToSelector:@selector(timelineDidUpdate:count:insertAt:)]) {
        [controller timelineDidUpdate:self count:unread insertAt:insertPosition];
	}   
    
    [self doneLoadingTableViewData];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_loading = YES;
	[self getTimeline];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_loading = NO;
	[controller.refreshHeaderView wzRefreshScrollViewDataSourceDidFinishedLoading:controller.tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[controller.refreshHeaderView wzRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[controller.refreshHeaderView  wzRefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark -
#pragma mark WZRefreshTableHeaderDelegate Methods
- (void)wzRefreshTableHeaderDidTriggerRefresh:(WZRefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)wzRefreshTableHeaderDataSourceIsLoading:(WZRefreshTableHeaderView*)view{
	
	return _loading; // should return if data source model is reloading
	
}

- (NSDate*)wzRefreshTableHeaderDataSourceLastUpdated:(WZRefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
@end
