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
#import "PostViewController.h"
#import "CommentsViewController.h"


@interface TweetInfoViewController : UIViewController <WBRequestDelegate,PostViewControllerDelegate,CommentsViewControllerDelegate>{
    Status*             status;
    UIImageView*        toolBar;
    UIButton*           btnActionsheet;
    UIButton*           btnComment;
    WeiBo*                  weibo;
    int                 comments;
    int                 rt;
}
- (id)initWithMessage:(Status*)status;
@end
