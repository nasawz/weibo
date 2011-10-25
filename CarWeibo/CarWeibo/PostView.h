//
//  PostView.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-25.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface PostView : UIView {
    UITextView*                recipient;
    sqlite_int64                inReplyToStatusId;
    UIButton*                   btn_Both;
    UILabel*                    lab_Both;
    BOOL                        isBoth;
}
@property(nonatomic, retain) UITextView* recipient;
@property(nonatomic, assign) sqlite_int64 inReplyToStatusId;
@property(nonatomic, assign) BOOL isBoth;

- (void)setBothText:(NSString *)str;

@end
