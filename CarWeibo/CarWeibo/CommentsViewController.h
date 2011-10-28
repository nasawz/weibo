//
//  CommentsViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-20.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "WeiBo.h"
#import "PostViewController.h"
#import "CommentsTimelineController.h"

@protocol CommentsViewControllerDelegate;
@interface CommentsViewController : UIViewController <PostViewControllerDelegate>{
    Status*             status;
    WeiBo*                  weibo;
    CommentsTimelineController * commentsTimelineViewController;
    id                  info_delegate;
}

@property (nonatomic, retain) id<CommentsViewControllerDelegate> info_delegate;

- (id)initWithMessage:(Status*)status;

@end

@protocol CommentsViewControllerDelegate
@optional
- (void)CommentsBackToInfo:(int)commentsCount;
@end