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
    BOOL forceCreate = [[NSUserDefaults standardUserDefaults] boolForKey:@"clearLocalCache"];
    [DBConnection createEditableCopyOfDatabaseIfNeeded:forceCreate];
    [DBConnection getSharedDatabase];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"clearLocalCache"];
    
    // Override point for customization after application launch.
    rootViewController = [[RootViewController alloc] init];
    [self.window addSubview:rootViewController.view];
    [self.window makeKeyAndVisible];
    
    
    imageStore = [[ImageStore alloc] init];
    
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

//
// Handling links
//
//static NSString *urlRegexp  = @"(((http(s?))\\:\\/\\/)([-0-9a-zA-Z]+\\.)+[a-zA-Z]{2,6}(\\:[0-9]+)?(\\/[-0-9a-zA-Z_#!:.?+=&%@~*\\';,/$]*)?)";
//static NSString *endRegexp  = @"[.,;:]$";
//static NSString *nameRegexp = @"(@[0-9a-zA-Z_]+)";
//static NSString *hashRegexp = @"(#[-a-zA-Z0-9_.+:=]+)";

- (void)openLinksViewController:(NSString*)text
{
//    UINavigationController* nav = (UINavigationController*)[tabBarController.viewControllers objectAtIndex:selectedTab];
//    
//    BOOL hasHash = false;
//    
//    NSMutableArray *links = [NSMutableArray array];
//    
//    NSMutableArray *array = [NSMutableArray array];
//    NSString *tmp = text;
//    
//    // Find URLs
//    while ([tmp matches:urlRegexp withSubstring:array]) {
//        NSString *url = [array objectAtIndex:0];
//        [array removeAllObjects];
//        if ([url matches:endRegexp withSubstring:array]) {
//            url = [url substringToIndex:[url length] - 1];
//        }
//        [links addObject:url];
//        NSRange r = [tmp rangeOfString:url];
//        tmp = [tmp substringFromIndex:r.location + r.length];
//        [array removeAllObjects];
//    }
//    
//    // Find screen names
//    tmp = text;
//    while ([tmp matches:nameRegexp withSubstring:array]) {
//        NSString *username = [array objectAtIndex:0];
//        [links addObject:username];
//        NSRange r = [tmp rangeOfString:username];
//        tmp = [tmp substringFromIndex:r.location + r.length];
//        [array removeAllObjects];
//    }
//    
//    // Find hashtags
//    tmp = text;
//    while ([tmp matches:hashRegexp withSubstring:array]) {
//        NSString *hash = [array objectAtIndex:0];
//        [links addObject:hash];
//        NSRange r = [tmp rangeOfString:hash];
//        tmp = [tmp substringFromIndex:r.location + r.length];
//        [array removeAllObjects];
//        hasHash = true;
//    }
//    
//    if ([links count] == 1) {
//        NSString* url = [links objectAtIndex:0];
//        NSRange r = [url rangeOfString:@"http://"];
//        if (r.location != NSNotFound) {
//            [self openWebView:url on:nav];
//        }
//        else {
//            if (hasHash) {
//                [self search:[links objectAtIndex:0]];
//            }
//            else {
//                UserTimelineController *userTimeline = [[[UserTimelineController alloc] init] autorelease];
//                NSString *aScreenName = [links objectAtIndex:0];
//                [userTimeline loadUserTimeline:[aScreenName substringFromIndex:1]];
//                [nav pushViewController:userTimeline animated:true];
//            }
//        }
//    }
//    else {
//        nav.navigationBar.tintColor = nil;
//        
//        LinkViewController* linkView = [[[LinkViewController alloc] init] autorelease];
//        linkView.links   = links;
//        [nav pushViewController:linkView animated:true];
//    }
}

@end
