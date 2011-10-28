//
//  HomeViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
//    
//    activityQuickViewModule = [[ActivityQuickViewModule alloc] init];
//    [activityQuickViewModule.view setFrame:CGRectOffset(activityQuickViewModule.view.frame, 0, 0)];
//    [tableHeaderView addSubview:activityQuickViewModule.view];
//    
//    UILabel * lab_news = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, 100, 16)];
//    [lab_news setText:@"最近更新"];
//    [lab_news setBackgroundColor:[UIColor clearColor]];
//    [lab_news setTextColor:[UIColor whiteColor]];
//    [lab_news setShadowColor:[UIColor blackColor]];
//    [lab_news setShadowOffset:CGSizeMake(0, -1)];
//    [tableHeaderView addSubview:lab_news];
    
    friendsTimelineController = [[FriendsTimelineController alloc] initWithNavController:[self navigationController]];
    [friendsTimelineController.tableView setFrame:CGRectMake(0, 6, 320, 460-6)];
//    [friendsTimelineController.tableView setTableHeaderView:tableHeaderView];
    [friendsTimelineController.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:friendsTimelineController.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 460 - 44)];
}

- (void)dealloc {
//    [tableHeaderView release];
    [activityQuickViewModule release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
