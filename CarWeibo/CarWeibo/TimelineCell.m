//
//  TimelineCell.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CarWeiboAppDelegate.h"
#import "TimelineCell.h"
#import "ColorUtils.h"
#import "ImageStoreWaiter.h"
#import "OtherProfileViewController.h"
@implementation TimelineCell

- (void)dealloc
{
    [super dealloc];
}    

- (void)updateImage:(UIImage*)image
{
    [imageButton setImage:image forState:UIControlStateNormal];
    [imageButton setNeedsDisplay];
}

- (void)didTouchImageButton:(id)sender
{
    CarWeiboAppDelegate *appDelegate = (CarWeiboAppDelegate*)[UIApplication sharedApplication].delegate;
    
    OtherProfileViewController * profileVC = [[OtherProfileViewController alloc] init];
    [profileVC setCurrUser:cellView.status.user];
    
    [[appDelegate.rootViewController getCurrNav] pushViewController:profileVC animated:YES];
//    
//    PostViewController* postView = appDelegate.postView;
//    [postView inReplyTo:status];
}

- (void)update
{
    cellView.status = status;
    [imageButton setImage:[self getProfileImage:status.user.profileImageUrl isLarge:false]
                 forState:UIControlStateNormal];
    if (![status.thumbnailPic isEqualToString:@""]) {
        ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
        
        UIImage *image = [store getThumbnailImage:status.thumbnailPic delegate:[[[ImageStoreWaiter alloc] initWith:thumbleImageView] autorelease]];
        [thumbleImageView setImage:image];
    }
    if (status.retweetedStatus) {
        if (![status.retweetedStatus.thumbnailPic isEqualToString:@""]) {
            ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
            
            UIImage *image = [store getThumbnailImage:status.retweetedStatus.thumbnailPic delegate:[[[ImageStoreWaiter alloc] initWith:thumbleImageView] autorelease]];
            [thumbleImageView setImage:image];
        }
    }
    
    self.contentView.backgroundColor = (status.unread) ? [UIColor cellColorForTab:status.type] : [UIColor whiteColor];
    
    if (status.hasReply) {
        if (status.type == TWEET_TYPE_FRIENDS || status.type == TWEET_TYPE_SEARCH_RESULT) {
            self.contentView.backgroundColor = [UIColor cellColorForTab:TAB_REPLIES];
        }
    }
    
    self.accessoryType = status.accessoryType;
    cellView.frame = CGRectMake(LEFT, 0, CELL_WIDTH, status.cellHeight - 1);
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    //    self.backgroundColor = self.contentView.backgroundColor;
    //    cellView.backgroundColor = self.contentView.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    cellView.backgroundColor = [UIColor clearColor];
    
    imageButton.frame = CGRectMake(IMAGE_PADDING, IMAGE_PADDING, IMAGE_WIDTH, 50);
    faceBgView.frame = CGRectMake(IMAGE_PADDING, IMAGE_PADDING , 50, 53);
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (![status.thumbnailPic isEqualToString:@""]) {
        thumbleImageView.frame = CGRectMake(100, status.cellHeight - 68, 50, 50);
        thumbleBgView.frame = CGRectMake(100 - 5, status.cellHeight - 68 - 5, 60, 62);
    }else{
        if (status.retweetedStatus && ![status.retweetedStatus.thumbnailPic isEqualToString:@""]) {
            
            thumbleImageView.frame = CGRectMake(100, status.cellHeight - 68 - 10, 50, 50);
            thumbleBgView.frame = CGRectMake(100 - 5, status.cellHeight - 68 - 5 - 10, 60, 62);
        }else{
            thumbleImageView.frame = CGRectZero;
            thumbleBgView.frame = CGRectZero;
        }
    }
    
    if (status.retweetedStatus) {
        CGFloat height = status.retweetedStatus.retweetedTextBounds.size.height;
        if (![status.retweetedStatus.thumbnailPic isEqualToString:@""]) {
            height += 70;
        }
        height += 18;
        retweetBackgroundView.frame = CGRectMake(320-270, status.textBounds.origin.y+status.textBounds.size.height + 5, 260, height);
    }else{
        retweetBackgroundView.frame = CGRectZero;
    }
        
    
}

@end
