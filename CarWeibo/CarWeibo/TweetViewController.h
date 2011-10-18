//
//  TweetViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-17.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "UserView.h"
#import "UserTimelineCell.h"

@interface TweetViewController : UITableViewController {
    UserView*           userView;
    Status*             status;
    UserTimelineCell*       tweetCell;;
}

- (id)initWithMessage:(Status*)status;

@end
