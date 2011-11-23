//
//  TrendTimelineDataSource.m
//  ROIFestival
//
//  Created by zhe wang on 11-11-1.
//  Copyright (c) 2011年 Jade Studio. All rights reserved.
//

#import "TrendTimelineDataSource.h"
#import "TrendTimelineDataSource.h"
#import "CarWeiboAppDelegate.h"
//#import "TweetViewController.h"
#import "TweetInfoViewController.h"
//#import "ProfileViewController.h"
#import "TrendTimelineController.h"

#import "TimelineCell.h"
#import "DBConnection.h"

#import "DebugUtils.h"
#import "JSON.h"
#import "WBUtil.h"

@interface NSObject (TimelineViewControllerDelegate)
- (void)timelineDidUpdate:(TrendTimelineDataSource*)sender count:(int)count insertAt:(int)position;
- (void)timelineDidFailToUpdate:(TrendTimelineDataSource*)sender position:(int)position;
@end

@implementation TrendTimelineDataSource
@synthesize keyWords;


- (id)initWithController:(TrendTimelineController*)aController tweetType:(TweetType)type {
    [super init];
    
    controller = aController;
    tweetType  = type;
    [loadCell setType:MSG_TYPE_LOAD_MORE_FRIENDS];
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
    
    [[GANTracker sharedTracker] trackEvent:@"TrendsView"
                                    action:@"selectRow"
                                     label:@"row"
                                     value:[indexPath row]
                                 withError:nil];
    
    Status* sts = [timeline statusAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];  
    
    if (sts) {
        // Display user view
        //
        TweetInfoViewController* tweetInfoView = [[[TweetInfoViewController alloc] initWithMessage:sts] autorelease];
        
        //        NSLog(@"%@",[controller parentViewController]);
        
        [controller.navController pushViewController:tweetInfoView animated:YES];
    }      
    else {
        // Restore tweets from DB
        //
        //        int count = [timeline restore:tweetType all:NO];
        int count = 0;
        
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
        [tableView endUpdates];
    }
    
}


- (void)getTimeline
{
    if (weibo)
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
    
    insertPosition = 0;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:keyWords forKey:@"trend_name"];
    [weibo getTrendsTimelineWithParams:param andDelegate:self];
//    [[CarWeiboAppDelegate getAppDelegate] loadingStart];
}

- (void)request:(WBRequest *)request didLoad:(id)result {
//    [[CarWeiboAppDelegate getAppDelegate] loadingStop];
    
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
    //    LOG(@"Received %d tweets on tab %d", [ary count], tweetType);  
    Status* lastStatus = [timeline lastStatus];
    if ([ary count]) {
        for (int i = [ary count] - 1; i >= 0; --i) {
            NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            Status* sts = [Status statusWithJsonDictionary:[ary objectAtIndex:i] type:tweetType];
            if (sts.createdAt < lastStatus.createdAt) {
                // Ignore stale message
                NSLog(@"Ignore stale message");
                continue;
            }
            [timeline insertStatus:sts atIndex:insertPosition];
            ++unread;
        }
    }
    
    if ([controller respondsToSelector:@selector(timelineDidUpdate:count:insertAt:)]) {
        [controller timelineDidUpdate:self count:unread insertAt:insertPosition];
	}   
    
    [self doneLoadingTableViewData];
}

- (void)insertTweet:(id)result {
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic = (NSDictionary*)result;
        Status* status = [Status statusWithJsonDictionary:dic type:tweetType];
        [status updateAttribute];
        [timeline insertStatus:status atIndex:insertPosition];
    }
    else {
        return;
    }  
    if ([controller respondsToSelector:@selector(timelineDidUpdate:count:insertAt:)]) {
        [controller timelineDidUpdate:self count:1 insertAt:insertPosition];
	}  
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
    //	[controller.refreshHeaderView wzRefreshScrollViewDataSourceDidFinishedLoading:controller.tableView];
	
}

//#pragma mark -
//#pragma mark UIScrollViewDelegate Methods
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
//	
//    //	[controller.refreshHeaderView wzRefreshScrollViewDidScroll:scrollView];
//    
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//	
//    //	[controller.refreshHeaderView  wzRefreshScrollViewDidEndDragging:scrollView];
//	
//}
//#pragma mark -
//#pragma mark WZRefreshTableHeaderDelegate Methods
//- (void)wzRefreshTableHeaderDidTriggerRefresh:(WZRefreshTableHeaderView*)view{
//	
//	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
//	
//}
//
//- (BOOL)wzRefreshTableHeaderDataSourceIsLoading:(WZRefreshTableHeaderView*)view{
//	
//	return _loading; // should return if data source model is reloading
//	
//}
//
//- (NSDate*)wzRefreshTableHeaderDataSourceLastUpdated:(WZRefreshTableHeaderView*)view{
//	
//	return [NSDate date]; // should return date data source was last changed
//	
//}
@end
