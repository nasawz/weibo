//
//  CommentsTimelineController.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-20.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "CommentsTimelineController.h"


@implementation CommentsTimelineController

- (void)initCommon {
    
}

- (void)setStatus:(Status*)value
{
    status = [value copy];
}

- (id)initWithMessage:(Status*)sts {
    self = [super initWithStyle:UITableViewStylePlain];
    [self initCommon];
    [self setStatus:sts];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    timelineDataSource = [[CommentsTimelineDataSource alloc] initWithController:self];
    self.tableView.dataSource = timelineDataSource;
    self.tableView.delegate   = timelineDataSource;
    
    if (!isLoaded) {
        [self loadTimeline];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

- (void)loadTimeline {
    [timelineDataSource getTimelineWithStatus:status];
    isLoaded = true;
}


//
// TimelineDelegate
//
- (void)timelineDidUpdate:(CommentsTimelineDataSource*)sender count:(int)count insertAt:(int)position
{
    //    self.navigationItem.leftBarButtonItem.enabled = true;
    //    
    //    if (self.navigationController.tabBarController.selectedIndex == tab &&
    //        self.navigationController.topViewController == self) {
    NSLog(@"timelineDidUpdate");
    [self.tableView beginUpdates];
    if (count != 0) {
        NSMutableArray *insertion = [[[NSMutableArray alloc] init] autorelease];
        
        int numInsert = count;
        // Avoid to create too many table cell.
        //            if (numInsert > 8) numInsert = 8;
        for (int i = 0; i < numInsert; ++i) {
            [insertion addObject:[NSIndexPath indexPathForRow:position + i inSection:0]];
        }        
        [self.tableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
//    
//    if (position == 0 && unread == 0) {
//        [self performSelector:@selector(scrollToFirstUnread) withObject:nil afterDelay:0.4];
//    }
//    //    }
//    if (count) {
//        unread += count;
//        //        [self navigationController].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unread];
//    }
}
@end
