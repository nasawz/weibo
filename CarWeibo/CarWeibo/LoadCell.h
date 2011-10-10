//
//  LoadCell.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef enum {
    MSG_TYPE_LOAD_MORE_FRIENDS,
    MSG_TYPE_LOAD_FROM_WEB,
    MSG_TYPE_LOAD_FROM_DB,
    MSG_TYPE_LOAD_USER_TIMELINE,
    MSG_TYPE_LOADING,
    MSG_TYPE_REQUEST_FOLLOW,
    MSG_TYPE_REQUEST_FOLLOW_SENT,
} loadCellType;

@interface LoadCell : UITableViewCell {
    UILabel*                    label;
    UIActivityIndicatorView*    spinner;
    loadCellType                type;
}

@property(nonatomic, readonly) UIActivityIndicatorView* spinner;
@property(nonatomic, assign) loadCellType type;

- (void)setType:(loadCellType)type;

@end
