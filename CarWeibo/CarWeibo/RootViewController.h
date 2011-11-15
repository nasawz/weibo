//
//  RootViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBo.h"
#import "CustomTabBar.h"
#import "CustomNavigation.h"

@interface RootViewController : UIViewController <WBSessionDelegate,WBRequestDelegate,CustomTabBarDelegate>{
    WeiBo*          weibo;
    CustomTabBar*   tabBar;
    CustomNavigation * navigation;
    
    UINavigationController * currNav;
}
@property (nonatomic, retain) CustomNavigation* navigation;
@property (nonatomic, retain) CustomTabBar* tabBar;

- (void)hideTabBar;
- (void)showTabBar;

- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex;

- (UINavigationController *)getCurrNav;

@end
