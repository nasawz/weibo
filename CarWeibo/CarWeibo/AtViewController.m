//
//  AtViewController.m
//  ROIFestival
//
//  Created by zhe wang on 11-11-5.
//  Copyright (c) 2011年 Jade Studio. All rights reserved.
//

#import "AtViewController.h"
#import "CarWeiboAppDelegate.h"

@implementation AtViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        NSString * path_bg = [[NSBundle mainBundle] pathForResource:@"bg_v3" ofType:@"png"];
//        UIImage * img_bg = [[UIImage alloc] initWithContentsOfFile:path_bg];
//        [self.view setBackgroundColor:[UIColor colorWithPatternImage:img_bg]];
//        [img_bg release];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        friendsViewController = [[FriendsViewController alloc] init];
        [friendsViewController.view setFrame:CGRectMake(0, 50, 320, 460 - 50)];
        [friendsViewController setController:self];
        [self.view addSubview:friendsViewController.view];
        
        
        CarWeiboAppDelegate *app_delegate = [CarWeiboAppDelegate getAppDelegate];
        
        UIButton* backButton = [app_delegate.rootViewController.navigation backButtonWith:[UIImage imageNamed:@"nav_btn_back.png"] highlight:nil leftCapWidth:14.0];
        [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [app_delegate.rootViewController.navigation setText:@"取消" onBackButton:backButton];
        app_delegate.rootViewController.navigation.leftButton = backButton;
        
        
        //    UIButton* sendButton = [app_delegate.rootViewController.navigation buttonWith:[UIImage imageNamed:@"nav_btn.png"] highlight:nil leftCapWidth:6.0];
        //    [sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
        //    [app_delegate.rootViewController.navigation setText:@" 发送 " onButton:sendButton];
        app_delegate.rootViewController.navigation.rightButton = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)cancel:(id)sender {
    if ([delegate respondsToSelector:@selector(didSelectFriend:) ]) {
        [delegate didSelectFriend:@""];
    }
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CarWeiboAppDelegate setTitle:@"我的好友"];
    
    
    [[GANTracker sharedTracker] trackPageview:@"/friends"
                                    withError:nil];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)selectFriend:(NSString*)name{
    if ([delegate respondsToSelector:@selector(didSelectFriend:) ]) {
        [delegate didSelectFriend:name];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
@end
