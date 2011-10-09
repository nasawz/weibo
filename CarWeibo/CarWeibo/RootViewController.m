//
//  RootViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "RootViewController.h"
#import "ImageUtils.h"

#define SinaWeiBoSDKDemo_APPKey @"2888398119"
#define SinaWeiBoSDKDemo_APPSecret @"5e9982830d03d178b7e07a83e27430a0"

#if !defined(SinaWeiBoSDKDemo_APPKey)
#error "You must define SinaWeiBoSDKDemo_APPKey as your APP Key"
#endif

#if !defined(SinaWeiBoSDKDemo_APPSecret)
#error "You must define SinaWeiBoSDKDemo_APPSecret as your APP Secret"
#endif

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    if( weibo )
//	{
//		[weibo release];
//		weibo = nil;
//	}
//	weibo = [[WeiBo alloc]initWithAppKey:SinaWeiBoSDKDemo_APPKey 
//						   withAppSecret:SinaWeiBoSDKDemo_APPSecret];
//	weibo.delegate = self;
//    
    
    UIImage * img_bg = [UIImage imageByFileName:@"bg_leathertexture" FileExtension:@"png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img_bg]];
    [img_bg release];
    
    UIImage * img = [UIImage imageByFileName:@"temp1" FileExtension:@"png"];
    UIImageView * imgV = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgV];
    [img release];
    
    
    tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
    [self.view addSubview:tabBar];
    
    //home（首页）
    //topic（车博话题）
    //profile（个人档案）
    //topic（预约试驾、专题活动）
    //    [weibo LogOutAll];
    //    [weibo startAuthorizeDefaultByAccount:@"nasawz" Password:@"wa3029q"];
    //    [weibo startAuthorizeByAccount:@"nasawz" Password:@"wa3029q"];
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

#pragma mark - WBSessionDelegate
- (void)weiboDidLogin
{
	
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户验证已成功！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)weiboDidDefaultLogin {
	
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
	
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户已成功退出！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@end
