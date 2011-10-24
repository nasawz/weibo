//
//  TweetInfoViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-19.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "TweetInfoViewController.h"
#import "CarWeiboAppDelegate.h"
#import "ImageUtils.h"
#import "LoginViewController.h"
#import "CommentsViewController.h"

@implementation TweetInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    delegate.rootViewController.navigation.leftButton = nil;
    
    [delegate.rootViewController.navigation setStyle:NAV_DOWNARR];
    [delegate.rootViewController showTabBar];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 460)];
    TweetViewController * tweetView = [[TweetViewController alloc] initWithMessage:status];
    [tweetView.view setFrame:CGRectMake(0, 6, 320, 460-6 - 53)];
    [self.view addSubview:tweetView.view];
    
    toolBar = [[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"toolbar_bg_lt" FileExtension:@"png"]];
    [toolBar setFrame:CGRectMake(0, 460-61 - 44, 320, 61)];
    [toolBar setUserInteractionEnabled:YES];
    [self.view addSubview:toolBar];
    
    UIImage * bg_btn = [[UIImage imageByFileName:@"btn_bg_grey" FileExtension:@"png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    btnActionsheet = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnActionsheet setBackgroundImage:bg_btn forState:UIControlStateNormal];
    [btnActionsheet setImage:[UIImage imageByFileName:@"btn_icon_actionsheet_wt" FileExtension:@"png"] forState:UIControlStateNormal];
    [btnActionsheet setFrame:CGRectMake(14, 16, 140, 38)];
    [btnActionsheet setTitle:@"     0" forState:UIControlStateNormal];
    [btnActionsheet.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [btnActionsheet.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [toolBar addSubview:btnActionsheet];
    
    btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnComment setBackgroundImage:bg_btn forState:UIControlStateNormal];
    [btnComment setImage:[UIImage imageByFileName:@"btn_icon_comment_wt" FileExtension:@"png"] forState:UIControlStateNormal];
    [btnComment setFrame:CGRectMake(166, 16, 140, 38)];
    [btnComment setTitle:@"     6" forState:UIControlStateNormal];
    [btnComment.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [btnComment.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [btnComment addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:btnComment];    
}

- (void)showLogin {
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    
    LoginViewController * loginView = [[LoginViewController alloc] init];
    [delegate.rootViewController presentModalViewController:loginView animated:YES];
    [loginView release];
}

- (void)onComment:(id)sender {
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
    if (!weibo.isUserLoggedin) {
        [self showLogin];
    }else{
        CommentsViewController * commentView = [[CommentsViewController alloc] initWithMessage:status];
        [self.navigationController pushViewController:commentView animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    [delegate.rootViewController.navigation setStyle:NAV_NORMAL];
    [delegate.rootViewController hideTabBar];
    
    
    UIButton* backButton = [delegate.rootViewController.navigation backButtonWith:[UIImage imageNamed:@"nav_btn_back.png"] highlight:nil leftCapWidth:14.0];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    delegate.rootViewController.navigation.leftButton = backButton;
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
