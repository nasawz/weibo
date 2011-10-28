//
//  ProfileStatusViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-28.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTimelineController.h"
#import "User.h"

@interface ProfileStatusViewController : UIViewController {
    User * user;
    UserTimelineController * userTimelineController;
}

@property (nonatomic, retain) User * user;

@end
