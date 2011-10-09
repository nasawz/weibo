//
//  CarWeiboAppDelegate.m
//  CarWeibo
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "CarWeiboAppDelegate.h"
#import "DBConnection.h"


@implementation CarWeiboAppDelegate
@synthesize rootViewController;
@synthesize window = _window;
@synthesize screenName;
@synthesize imageStore;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    BOOL forceCreate = [[NSUserDefaults standardUserDefaults] boolForKey:@"clearLocalCache"];
//    [DBConnection createEditableCopyOfDatabaseIfNeeded:forceCreate];
//    [DBConnection getSharedDatabase];
//    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"clearLocalCache"];
    
    // Override point for customization after application launch.
    rootViewController = [[RootViewController alloc] init];
    [self.window addSubview:rootViewController.view];
    [self.window makeKeyAndVisible];
    
    
//    imageStore = [[ImageStore alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

static UIAlertView *sAlert = nil;
- (void)alert:(NSString*)title message:(NSString*)message
{
    if (sAlert) return;
    
    sAlert = [[UIAlertView alloc] initWithTitle:title
                                        message:message
                                       delegate:self
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
    [sAlert show];
    [sAlert release];
}

+ (BOOL)isMyScreenName:(NSString*)screen_name
{
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    return ([delegate.screenName caseInsensitiveCompare:screen_name] == NSOrderedSame) ? true : false;
}

+(CarWeiboAppDelegate*)getAppDelegate
{
    return (CarWeiboAppDelegate*)[UIApplication sharedApplication].delegate;
}

@end
