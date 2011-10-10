//
//  TweetCellView.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface TweetCellView : UIView {
    Status*    status;
}

@property(nonatomic, retain) Status* status;

@end
