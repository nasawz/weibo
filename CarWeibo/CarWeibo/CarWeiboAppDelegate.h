//
//  CarWeiboAppDelegate.h
//  CarWeibo
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageStore.h"
#import "Status.h"
#import "RootViewController.h"

@interface CarWeiboAppDelegate : NSObject <UIApplicationDelegate> {
    RootViewController * rootViewController;
    ImageStore*                     imageStore;
    
    NSString*                       screenName;
}

@property (nonatomic, retain) RootViewController*   rootViewController;
@property (nonatomic, retain) IBOutlet UIWindow *   window;
@property (nonatomic, retain) NSString*             screenName;
@property (nonatomic, readonly) ImageStore*         imageStore;

- (void)alert:(NSString*)title message:(NSString*)detail;

+ (BOOL)isMyScreenName:(NSString*)screen_name;
+ (CarWeiboAppDelegate*)getAppDelegate;

@end
