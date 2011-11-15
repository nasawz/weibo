//
//  OtherProfileViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-11-15.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "CarWeiboAppDelegate.h"
#import "LoginViewController.h"
#import "ImageUtils.h"
#import "ImageStoreWaiter.h"
#import "ProfileStatusViewController.h"

@implementation OtherProfileViewController
@synthesize currUser;

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
#pragma mark - 


- (void)goStatus {
    
    ProfileStatusViewController* statusViewController = [[[ProfileStatusViewController alloc] init] autorelease];
    [statusViewController setUser:currUser];
    
    //        NSLog(@"%@",[controller parentViewController]);
    
    [self.navigationController pushViewController:statusViewController animated:TRUE];
}
#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)buildUI {
    
    faceImageView = [[UIImageView alloc] init];
    [faceImageView setFrame:CGRectMake(14, 92-50, 90, 90)];
    [self.view addSubview:faceImageView];
    
    UIImageView * mask_face = [[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"mask_face" FileExtension:@"png"]];
    [mask_face setFrame:CGRectMake(4, 62 - 50, 111, 138)];
    [self.view addSubview:mask_face];
    
    lab_name = [[UILabel alloc] initWithFrame:CGRectMake(126, 100- 50, 180, 20)];
    [lab_name setTextColor:[UIColor whiteColor]];
    [lab_name setBackgroundColor:[UIColor clearColor]];
    lab_location = [[UILabel alloc] initWithFrame:CGRectMake(126, 125- 50, 180, 20)];
    [lab_location setTextColor:[UIColor whiteColor]];
    [lab_location setBackgroundColor:[UIColor clearColor]];    
    txt_description = [[UILabel alloc] initWithFrame:CGRectMake(126, 150- 50, 180, 44)];
    [txt_description setNumberOfLines:0];
    [txt_description setLineBreakMode:UILineBreakModeWordWrap];
    [txt_description setTextColor:[UIColor darkGrayColor]];
    [txt_description setFont:[UIFont systemFontOfSize:14.0f]];
    [txt_description setBackgroundColor:[UIColor clearColor]];  
    
    [self.view addSubview:lab_name];
    [self.view addSubview:lab_location];
    [self.view addSubview:txt_description];  
    
    //    btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLogout setBackgroundImage:[[UIImage imageByFileName:@"btn_bg_blue" FileExtension:@"png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal];
    //    [btnLogout setFrame:CGRectMake(7, 211 - 50, 307, 38)];
    //    [btnLogout.titleLabel setShadowColor:[UIColor blackColor]];
    //    [btnLogout.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    //    [btnLogout setTitle:@"退出登陆" forState:UIControlStateNormal];
    //    [btnLogout addTarget:self action:@selector(doLogout) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:btnLogout];
    
    btnViewStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnViewStatus setBackgroundImage:[UIImage imageByFileName:@"btn_ViewStatus" FileExtension:@"png"] forState:UIControlStateNormal];
    [btnViewStatus setFrame:CGRectMake(0, 268 - 50, 320, 53)];
    [btnViewStatus addTarget:self action:@selector(goStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnViewStatus];
    
    UIImageView * endView = [[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"bg_cellEnd1" FileExtension:@"png"]];
    [endView setFrame:CGRectMake(0, 318 - 50, 320, 60)];
    [self.view addSubview:endView];
}

- (void)dataBinding {
    
    ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
    
    NSString * url = [currUser.profileImageUrl stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"];
    
    UIImage *image = [store getThumbnailImage:url delegate:[[[ImageStoreWaiter alloc] initWith:faceImageView] autorelease]];
    [faceImageView setImage:image];
    
    [lab_name setText:currUser.name];
    [lab_location setText:currUser.location];
    [txt_description setText:currUser.description];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildUI];
    [self dataBinding];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    [delegate.rootViewController.navigation setStyle:NAV_NORMAL];
    //    [delegate.rootViewController hideTabBar];
    
    
    UIButton* backButton = [delegate.rootViewController.navigation backButtonWith:[UIImage imageNamed:@"nav_btn_back.png"] highlight:nil leftCapWidth:14.0];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    delegate.rootViewController.navigation.leftButton = backButton;
    
    delegate.rootViewController.navigation.rightButton = nil;
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

#pragma mark - 

- (void)back:(id)sender {
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    delegate.rootViewController.navigation.leftButton = nil;
    
    [delegate.rootViewController.navigation setStyle:NAV_NORMAL];
    //    [delegate.rootViewController showTabBar];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)getCurrUser {
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:weibo.userID forKey:@"id"];
    NSLog(@"%@",param);
    [weibo getUserWithParams:param andDelegate:self];
}

- (void)request:(WBRequest *)request didLoad:(id)result {
    weibo = nil;
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic = (NSDictionary*)result;
        //        NSLog(@"%@",dic);
        currUser = [User userWithJsonDictionary:dic];
        
        NSLog(@"user = %u",currUser.userId);
        NSLog(@"profileImageUrl = %@",currUser.profileImageUrl);
        
        
        [self dataBinding];
    }
    else {
        return;
    }  
}

@end
