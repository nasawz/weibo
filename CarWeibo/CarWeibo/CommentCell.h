//
//  CommentCell.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-24.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell {
    Comment * comment;
    UILabel*    lab_name;
    UILabel*    lab_timestamp;
    UILabel*    lab_text;
    UIImageView *   backgroundView;
}

@property (nonatomic, assign) Comment*  comment;
- (void)update;
@end
