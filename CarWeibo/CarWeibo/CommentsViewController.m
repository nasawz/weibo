//
//  CommentsViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-20.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "CommentsViewController.h"
#import "CarWeiboAppDelegate.h"
#import "CommentsTimelineController.h"

@implementation CommentsViewController

- (void)setStatus:(Status*)value
{
    status = [value copy];
}

- (id)initWithMessage:(Status*)sts {
    self = [super init];
    [self setStatus:sts];
    
    return self;
}



- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
//    delegate.rootViewController.navigation.leftButton = nil;
//    
//    [delegate.rootViewController.navigation setStyle:NAV_DOWNARR];
//    [delegate.rootViewController showTabBar];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    //    [delegate.rootViewController.navigation setStyle:NAV_NORMAL];
    //    [delegate.rootViewController hideTabBar];
    
    
    UIButton* backButton = [delegate.rootViewController.navigation backButtonWith:[UIImage imageNamed:@"nav_btn_back.png"] highlight:nil leftCapWidth:14.0];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    delegate.rootViewController.navigation.leftButton = backButton;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CommentsTimelineController * commentView = [[CommentsTimelineController alloc] initWithMessage:status];
    [commentView.view setFrame:CGRectMake(0, 6, 320, 460-6)];
    [self.view addSubview:commentView.view];
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
