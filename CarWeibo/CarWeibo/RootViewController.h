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

@interface RootViewController : UIViewController <WBSessionDelegate,WBRequestDelegate,CustomTabBarDelegate>{
    WeiBo*          weibo;
    CustomTabBar*   tabBar;
}

@property (nonatomic, retain) CustomTabBar* tabBar;

@end
