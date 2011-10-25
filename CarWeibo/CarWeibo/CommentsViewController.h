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

@interface CommentsViewController : UIViewController {
    Status*             status;
    WeiBo*                  weibo;
}
- (id)initWithMessage:(Status*)status;

@end
