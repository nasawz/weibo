//
//  HomeViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityQuickViewModule.h"
#import "FriendsTimelineController.h"

@interface HomeViewController : UIViewController {
    ActivityQuickViewModule * activityQuickViewModule;
    UIView * tableHeaderView;
    FriendsTimelineController * friendsTimelineController;
}

@end
