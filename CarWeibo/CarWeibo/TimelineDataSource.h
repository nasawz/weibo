//
//  TimelineDataSource.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timeline.h"
#import "WeiBo.h"
#import "LoadCell.h"

@interface TimelineDataSource : NSObject {
	Timeline*               timeline;
    WeiBo*                  weibo;
    LoadCell*               loadCell;
    CGPoint                 contentOffset;
}

@property(nonatomic, readonly) Timeline* timeline;
@property(nonatomic, assign) CGPoint contentOffset;

- (id)init;
- (void)cancel;
- (void)removeAllStatuses;

@end
