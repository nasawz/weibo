//
//  SinaWeiBoSDKDemoViewController.m
//  SinaWeiBoSDKDemo
//
//  Created by Wu WenYong on 11-5-30.
//  Copyright 2011 Sina. All rights reserved.
//

#import "SinaWeiBoSDKDemoViewController.h"

#define SinaWeiBoSDKDemo_APPKey @"2888398119"
#define SinaWeiBoSDKDemo_APPSecret @"5e9982830d03d178b7e07a83e27430a0"

#if !defined(SinaWeiBoSDKDemo_APPKey)
#error "You must define SinaWeiBoSDKDemo_APPKey as your APP Key"
#endif

#if !defined(SinaWeiBoSDKDemo_APPSecret)
#error "You must define SinaWeiBoSDKDemo_APPSecret as your APP Secret"
#endif



@implementation SinaWeiBoSDKDemoViewController
@synthesize weibo;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(20, 50, 70, 50);
	[button setTitle:@"auth" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	
	buttonSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	buttonSend.frame = CGRectMake(100, 50, 70, 50);
	[buttonSend setTitle:@"send" forState:UIControlStateNormal];
	[buttonSend addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:buttonSend];
	
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(180, 50, 70, 50);
	[button setTitle:@"logout" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(logOutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	buttonLogout = button;
	
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(100, 200, 70, 50);
	[button setTitle:@"getFeed" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(getFeedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	buttonGetFeed = button;
	
	buttonLogout.hidden = TRUE;
	buttonSend.hidden = TRUE;
	buttonGetFeed.hidden = TRUE;
    
//    txt_account = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
//    [txt_account setBorderStyle:UITextBorderStyleRoundedRect];
//	txt_password = [[UITextField alloc] initWithFrame:CGRectMake(0, 24, 200, 22)];
//    [txt_password setBorderStyle:UITextBorderStyleRoundedRect];
//    
//    [self.view addSubview:txt_account];
//    [self.view addSubview:txt_password];
}


- (void)buttonPressed:(id)sender
{
	if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoSDKDemo_APPKey 
						   withAppSecret:SinaWeiBoSDKDemo_APPSecret];
	weibo.delegate = self;
    
//	[weibo startAuthorizeDefaultByAccount:@"nasawz" Password:@"wa3029q"];
    
    [weibo startAuthorizeByAccount:@"nasawz" Password:@"wa3029q"];
    
    
}
					
-(void)sendButtonPressed:(id)sender
{
 
	[weibo showSendViewWithWeiboText:@"test weibo text!" andImage:[UIImage imageNamed:@"btn.png"] andDelegate:self];
}

- (void)logOutButtonPressed:(id)sender
{
	[weibo LogOut];
}

- (void)getFeedButtonPressed:(id)sender
{
	[weibo requestWithMethodName:@"statuses/public_timeline.json" andParams:nil andHttpMethod:@"GET" andDelegate:self];
}

- (void)weiboDidLogin
{
	buttonLogout.hidden = FALSE;
	buttonSend.hidden = FALSE;
	buttonGetFeed.hidden = FALSE;
	
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户验证已成功！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)weiboDidDefaultLogin {
	buttonLogout.hidden = FALSE;
	buttonSend.hidden = FALSE;
	buttonGetFeed.hidden = FALSE;
	
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"默认用户验证已成功！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];    
}

- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError*)error
{
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"用户验证失败！"  
													   message:userCancelled?@"用户取消操作":[error description]  
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)weiboDidLogout
{
	buttonLogout.hidden = TRUE;
	buttonSend.hidden = TRUE;
	buttonGetFeed.hidden = TRUE;
	
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户已成功退出！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}



- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送失败：%@",[error description] ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)request:(WBRequest *)request didLoad:(id)result
{

		
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送成功！" ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	NSString *urlString = request.url;
	if ([urlString rangeOfString:@"statuses/public_timeline"].location !=  NSNotFound)
	{
		alert.message = @"获取成功";
		NSLog(@"%@",result);
	}
	[alert show];
	[alert release];
	[weibo dismissSendView];
}

#pragma mark WBSendView CALLBACK_API
- (void)sendViewWillAppear:(WBSendView*)sendView
{
	NSLog(@"sendview will appear.");
}

- (void)sendViewDidLoad:(WBSendView*)sendView
{
	NSLog(@"sendview did load.");
}

- (void)sendViewWillDisappear:(WBSendView*)sendView
{
	NSLog(@"sendview will disappear.");
}

- (void)sendViewDidDismiss:(WBSendView*)sendView
{
	NSLog(@"sendview did dismiss.");
}

@end
