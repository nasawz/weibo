//
//  TrendsViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-11-16.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendTimelineController.h"
#import "WeiBo.h"
#import "PostViewController.h"

@interface TrendsViewController : UIViewController <PostViewControllerDelegate>{
    TrendTimelineController * trendTimelineController;
    NSString * keyWords;
    WeiBo*                  weibo;
}

@property (nonatomic, retain) NSString * keyWords;

@end
