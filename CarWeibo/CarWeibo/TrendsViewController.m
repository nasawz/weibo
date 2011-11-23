//
//  TrendsViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-11-16.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "TrendsViewController.h"
#import "CarWeiboAppDelegate.h"
#import "LoginViewController.h"

@implementation TrendsViewController
@synthesize keyWords;

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
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    [delegate.rootViewController.navigation setStyle:NAV_NORMAL];
    [delegate.rootViewController showTabBar];
    
    
    UIButton* backButton = [delegate.rootViewController.navigation backButtonWith:[UIImage imageNamed:@"nav_btn_back.png"] highlight:nil leftCapWidth:14.0];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    delegate.rootViewController.navigation.leftButton = backButton;
    
    
    UIButton* sendButton = [delegate.rootViewController.navigation buttonWith:[UIImage imageNamed:@"nav_btn.png"] highlight:nil leftCapWidth:6.0];
    [sendButton addTarget:self action:@selector(joinTrend) forControlEvents:UIControlEventTouchUpInside];
    [delegate.rootViewController.navigation setText:@"参与话题" onButton:sendButton];
    delegate.rootViewController.navigation.rightButton = sendButton;
    
    
    
    
    [CarWeiboAppDelegate setTitle:[NSString stringWithFormat:@"#%@#",keyWords]];
}

- (void)showLogin {
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    
    LoginViewController * loginView = [[LoginViewController alloc] init];
    [delegate.rootViewController presentModalViewController:loginView animated:YES];
    [loginView release];
}

- (void)joinTrend {
    
    
    [[GANTracker sharedTracker] trackEvent:@"TrendsView"
                                    action:@"touchDown"
                                     label:@"join"
                                     value:-1
                                 withError:nil];
    
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
    if (!weibo.isUserLoggedin) {
        [self showLogin];
    }else{
        PostViewController * postViewController = [[PostViewController alloc] initWithPostType:POST_TYPE_POST];
        [postViewController setDelegate:self];
        [postViewController setKeyWords:keyWords];
        [postViewController setStatus:nil];
        [self presentModalViewController:postViewController animated:YES];
        [postViewController release];
    } 
}

#pragma mark - PostViewControllerDelegate
- (void)PostDidSucc:(PostViewController *)controller res:(id)result{
    [trendTimelineController.timelineDataSource insertTweet:result];
}


#pragma mark -
- (void)back:(id)sender {
    
    [[GANTracker sharedTracker] trackEvent:@"TrendsView"
                                    action:@"touchDown"
                                     label:@"back"
                                     value:-1
                                 withError:nil];
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    delegate.rootViewController.navigation.leftButton = nil;
    
    [delegate.rootViewController.navigation setStyle:NAV_NORMAL];
    //    [delegate.rootViewController showTabBar];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //    NSLog(@"1 %@",keyWords);
    
    trendTimelineController = [[TrendTimelineController alloc] initWithNavController:self.navigationController];
    [trendTimelineController setKeyWords:keyWords];

    [trendTimelineController.view setFrame:CGRectMake(0, 6, 320, 460 - 6)];    
    [self.view addSubview:trendTimelineController.view];
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

- (void)setKeyWords:(NSString *)aKeyWords {
    keyWords = [aKeyWords retain];
}

@end
