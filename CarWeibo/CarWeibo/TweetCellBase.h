//
//  TweetCellBase.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "TweetCellView.h"
#import "ProfileImageCell.h"

#define MESSAGE_REUSE_INDICATOR @"TweetCell"

@interface TweetCellBase : ProfileImageCell {
	Status*         status;
    TweetCellView*  cellView;
    UIButton*       imageButton;
}

@property (nonatomic, assign) Status*  status;

@end
