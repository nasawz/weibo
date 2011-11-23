//
//  CarWeiboAppDelegate.h
//  CarWeibo
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageStore.h"
#import "Status.h"
#import "RootViewController.h"

typedef enum {
    TAB_FRIENDS,
    TAB_REPLIES,
    TAB_MESSAGES,
    TAB_FAVORITES,
    TAB_SEARCH,
} TAB_ITEM;

@interface CarWeiboAppDelegate : NSObject <UIApplicationDelegate> {
    RootViewController * rootViewController;
    ImageStore*                     imageStore;
    
    NSString*                       screenName;
}

@property (nonatomic, retain) RootViewController*   rootViewController;
@property (nonatomic, retain) IBOutlet UIWindow *   window;
@property (nonatomic, retain) NSString*             screenName;
@property (nonatomic, readonly) ImageStore*         imageStore;

- (void)openLinksViewController:(NSString*)text;

- (void)alert:(NSString*)title message:(NSString*)detail;

+ (BOOL)isMyScreenName:(NSString*)screen_name;
+ (CarWeiboAppDelegate*)getAppDelegate;


+ (void)setTitle:(NSString *)title;

@end
