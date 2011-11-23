//
//  FriendsViewController.h
//  ROIFestival
//
//  Created by zhe wang on 11-11-5.
//  Copyright (c) 2011年 Jade Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBConnect.h"
#import "User.h"
@class AtViewController;
@interface FriendsViewController : UITableViewController <WBRequestDelegate>{
    WeiBo*          weibo;
    NSMutableArray* friends;
    AtViewController*      controller;
}

@property (nonatomic, retain) AtViewController*      controller;
- (void)getFriends;
@end
