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
#import "LoginViewController.h"

@implementation CommentsViewController
@synthesize info_delegate;

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
    
    if ([info_delegate respondsToSelector:@selector(CommentsBackToInfo:)]) {
        [info_delegate CommentsBackToInfo:[commentsTimelineViewController.timelineDataSource.comments count]];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
//    delegate.rootViewController.navigation.leftButton = nil;
//    
//    [delegate.rootViewController.navigation setStyle:NAV_DOWNARR];
//    [delegate.rootViewController showTabBar];
    
    delegate.rootViewController.navigation.rightButton = nil;
}

- (void)showLogin {
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    
    LoginViewController * loginView = [[LoginViewController alloc] init];
    [delegate.rootViewController presentModalViewController:loginView animated:YES];
    [loginView release];
}

- (void)openPostView:(id)sender {
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
    if (!weibo.isUserLoggedin) {
        [self showLogin];
    }else{
        PostViewController * postViewController = [[PostViewController alloc] initWithPostType:POST_TYPE_COMMENT];
        [postViewController setDelegate:self];
        [postViewController setStatus:status];
        [self presentModalViewController:postViewController animated:YES];
        [postViewController release];
    }
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
    
    
    UIButton* sendButton = [delegate.rootViewController.navigation buttonWith:[UIImage imageNamed:@"nav_btn.png"] highlight:nil leftCapWidth:6.0];
    [sendButton addTarget:self action:@selector(openPostView:) forControlEvents:UIControlEventTouchUpInside];
    [delegate.rootViewController.navigation setText:@"发表评论" onButton:sendButton];
    delegate.rootViewController.navigation.rightButton = sendButton;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    commentsTimelineViewController = [[CommentsTimelineController alloc] initWithMessage:status];
    [commentsTimelineViewController.view setFrame:CGRectMake(0, 6, 320, 460-6)];
    [self.view addSubview:commentsTimelineViewController.view];
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


#pragma mark - PostViewControllerDelegate
- (void)PostDidSucc:(PostViewController *)controller res:(id)result{
    [commentsTimelineViewController.timelineDataSource insertComment:result];
}

@end
