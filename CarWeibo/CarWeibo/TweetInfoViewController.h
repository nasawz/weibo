//
//  TweetInfoViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-19.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBConnect.h"
#import "TweetViewController.h"
#import "Status.h"


@interface TweetInfoViewController : UIViewController {
    Status*             status;
    UIImageView*        toolBar;
    UIButton*           btnActionsheet;
    UIButton*           btnComment;
    WeiBo*                  weibo;
}
- (id)initWithMessage:(Status*)status;
@end
