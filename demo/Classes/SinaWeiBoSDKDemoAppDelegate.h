//
//  SinaWeiBoSDKDemoAppDelegate.h
//  SinaWeiBoSDKDemo
//
//  Created by Wu WenYong on 11-5-30.
//  Copyright 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SinaWeiBoSDKDemoViewController;

@interface SinaWeiBoSDKDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SinaWeiBoSDKDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SinaWeiBoSDKDemoViewController *viewController;

@end

