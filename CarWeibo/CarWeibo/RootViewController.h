//
//  RootViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBo.h"

@interface RootViewController : UIViewController <WBSessionDelegate,WBRequestDelegate>{
    WeiBo* weibo;
    UITabBar * tabBar;
}
@end
