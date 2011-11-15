//
//  RootViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "RootViewController.h"
#import "ImageUtils.h"
#import "WBUtil.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"

//#define SinaWeiBo_APPKey @"2888398119"
//#define SinaWeiBo_APPSecret @"5e9982830d03d178b7e07a83e27430a0"
//
//
#define CarweiboAccount @"carweibo@sina.cn"
#define CarweiboPassword @"fractalist1688"
//
//#if !defined(SinaWeiBo_APPKey)
//#error "You must define SinaWeiBoSDKDemo_APPKey as your APP Key"
//#endif
//
//#if !defined(SinaWeiBo_APPSecret)
//#error "You must define SinaWeiBoSDKDemo_APPSecret as your APP Secret"
//#endif

#define SELECTED_VIEW_CONTROLLER_TAG 98456345
static NSArray* tabBarItems = nil;

@implementation RootViewController
@synthesize tabBar;
@synthesize navigation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UINavigationController * home_nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
        UINavigationController * profile_nav = [[UINavigationController alloc] initWithRootViewController:[[ProfileViewController alloc] init]];
        
        tabBarItems = [[NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"icon_home.png", @"image", home_nav, @"viewController", nil],
//                        [NSDictionary dictionaryWithObjectsAndKeys:@"icon_topic.png", @"image", home_nav, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"icon_profile.png", @"image", profile_nav, @"viewController", nil],
//                        [NSDictionary dictionaryWithObjectsAndKeys:@"icon_activity.png", @"image", activity_nav, @"viewController", nil],
                        nil] retain];
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
    
    UIImage * img_bg = [UIImage imageByFileName:@"bg_leathertexture" FileExtension:@"png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img_bg]];
    [img_bg release];
    
//    UIImage * img = [UIImage imageByFileName:@"temp1" FileExtension:@"png"];
//    UIImageView * imgV = [[UIImageView alloc] initWithImage:img];
//    [self.view addSubview:imgV];
//    [img release];
    
    
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
    
    // Create a custom tab bar passing in the number of items, the size of each item and setting ourself as the delegate
    self.tabBar = [[[CustomTabBar alloc] initWithItemCount:tabBarItems.count itemSize:CGSizeMake(self.view.frame.size.width/tabBarItems.count, tabBarGradient.size.height*2) tag:0 delegate:self] autorelease];
    
    // Place the tab bar at the bottom of our view
    tabBar.frame = CGRectMake(0,416,320, 44);
    [self.view addSubview:tabBar];
    
    // Select the first tab
    [tabBar selectItemAtIndex:0];
    [self touchDownAtItemAtIndex:0];
    

    
    //home（首页）
    //topic（车博话题）
    //profile（个人档案）
    //activity（预约试驾、专题活动）
    
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
	weibo.delegate = self;
//    [weibo LogOutAll];
    [weibo startAuthorizeDefaultByAccount:CarweiboAccount Password:CarweiboPassword];
    //    [weibo startAuthorizeByAccount:@"nasawz" Password:@"wa3029q"];
    
    
    navigation = [[CustomNavigation alloc] initWithTitle:@"车博通" AddStyle:NAV_NORMAL];
    [self.view addSubview:navigation];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
//	[params setObject:[@"改车" URLEncodedString] forKey:@"q"];
    
//    [weibo requestWithMethodName:@"search/statuses.json" andParams:nil andHttpMethod:@"POST" andDelegate:self accessToken:weibo.defaultAccessToken accessSecret:weibo.defaultAccessTokenSecret];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    [navigation release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark CustomTabBarDelegate

- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    // Get the right data
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [UIImage imageNamed:[data objectForKey:@"image"]];
}

- (UIImage*) backgroundImage
{
    // The tab bar's width is the same as our width
    CGFloat width = self.view.frame.size.width;
    // Get the image that will form the top of the background
    UIImage* topImage = [UIImage imageNamed:@"TabBarGradient.png"];
    
    // Create a new image context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2), NO, 0.0);
    
    // Create a stretchable image for the top of the background and draw it
    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    // Draw a solid black color for the bottom of the background
    [[UIColor blackColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// This is the blue background shown for selected tab bar items
- (UIImage*) selectedItemBackgroundImage
{
    return [UIImage imageNamed:@"TabBarItemSelectedBackground.png"];
}

// This is the glow image shown at the bottom of a tab bar to indicate there are new items
- (UIImage*) glowImage
{
    UIImage* tabBarGlow = [UIImage imageNamed:@"TabBarGlow.png"];
    
    // Create a new image using the TabBarGlow image but offset 4 pixels down
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0), NO, 0.0);
    
    // Draw the image
    [tabBarGlow drawAtPoint:CGPointZero];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// This is the embossed-like image shown around a selected tab bar item
- (UIImage*) selectedItemImage
{
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
    CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width/tabBarItems.count, tabBarGradient.size.height*2);
    UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
    
    // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
    [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0] drawInRect:CGRectMake(0, 4.0, tabBarItemSize.width, tabBarItemSize.height-4.0)];  
    
    // Generate a new image
    UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return selectedItemImage;
}

- (UIImage*) tabBarArrowImage
{
    return [UIImage imageNamed:@"TabBarNipple.png"];
}

- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    // Remove the current view controller's view
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    // Get the right view controller
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    UIViewController* viewController = [data objectForKey:@"viewController"];
    
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
    
    // Set the view controller's frame to account for the tab bar
    viewController.view.frame = CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height-(tabBarGradient.size.height*2));
    
    // Se the tag so we can find it later
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    
    // Add the new view controller's view
    [self.view insertSubview:viewController.view belowSubview:tabBar];
    
    currNav = (UINavigationController *)viewController;
    
//    if (itemIndex == 0) {
//        [(HomeViewController*)[(UINavigationController *)viewController topViewController] restoreAndLoadTimeline:YES];
//    }
    
    // In 1 second glow the selected tab
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addGlowTimerFireMethod:) userInfo:[NSNumber numberWithInteger:itemIndex] repeats:NO];
    
}

- (UINavigationController *)getCurrNav {
    return currNav;
}

- (void)addGlowTimerFireMethod:(NSTimer*)theTimer
{
    // Remove the glow from all tab bar items
    for (NSUInteger i = 0 ; i < tabBarItems.count ; i++)
    {
        [tabBar removeGlowAtIndex:i];
    }
    
    // Then add it to this tab bar item
    [tabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
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
	NSLog(@"===>%@",[NSString stringWithFormat:@"默认用户[%@]验证已成功！",CarweiboAccount]);
//	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
//													   message:[NSString stringWithFormat:@"默认用户[%@]验证已成功！",CarweiboAccount] 
//													  delegate:nil 
//											 cancelButtonTitle:@"确定" 
//											 otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];    
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

- (void)hideTabBar {
    [UIView beginAnimations:@"hideTabbar" context:nil];
    [UIView setAnimationDuration:0.3f];
    tabBar.frame = CGRectMake(0,470,320, 44);
    [UIView commitAnimations];
}

- (void)showTabBar {
    [UIView beginAnimations:@"hideTabbar" context:nil];
    [UIView setAnimationDuration:0.3f];
    tabBar.frame = CGRectMake(0,416,320, 44);
    [UIView commitAnimations];
}


- (void)request:(WBRequest *)request didLoad:(id)result {
    NSLog(@"%@",result);
}
- (void)request:(WBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

@end
