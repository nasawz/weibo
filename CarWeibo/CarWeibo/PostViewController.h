//
//  PostViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-25.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostView.h"
#import "Status.h"
#import "WeiBo.h"

typedef enum {
    POST_TYPE_COMMENT,
    POST_TYPE_RETWEET,
    POST_TYPE_POST,
} PostType;

@protocol PostViewControllerDelegate;
@interface PostViewController : UIViewController <WBRequestDelegate>{
    PostView*                  postView;
    PostType                   postType;
    Status*                    status;
    WeiBo*                     weibo;
    id                         delegate;
    NSString * keyWords;

}

- (id)initWithPostType:(PostType)type;

@property (nonatomic, retain) NSString * keyWords;
@property(nonatomic,assign) id <PostViewControllerDelegate> delegate;
@property (nonatomic, retain) Status* status;
@property (nonatomic, assign) PostType postType;


- (void)reSetNav;

@end

@protocol PostViewControllerDelegate
@optional
- (void)PostDidSucc:(PostViewController *)controller res:(id)result;
@end