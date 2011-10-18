//
//  UserTimelineCell.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-18.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "UserTimelineCell.h"
#import "ImageUtils.h"
#import "ImageStoreWaiter.h"
#import "CarWeiboAppDelegate.h"

@implementation UserTimelineCell

- (void)dealloc
{
    [super dealloc];
}    

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  	[super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    
//    
//    backgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
//    [self.contentView addSubview:backgroundView];
//    
//    retweetBackgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
//    [self.contentView addSubview:retweetBackgroundView];
//    
//    [backgroundView setImage:[[UIImage imageByFileName:@"bg_cell1" FileExtension:@"png"] stretchableImageWithLeftCapWidth:10 topCapHeight:20]];
//    
//    [retweetBackgroundView setImage:[[UIImage imageByFileName:@"timeline_rt_border" FileExtension:@"png"] stretchableImageWithLeftCapWidth:0 topCapHeight:14]];
//    
//    cellView = [[[TweetCellView alloc] initWithFrame:CGRectZero] autorelease];
//    [self.contentView addSubview:cellView];
//    
//    faceBgView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
//    [self.contentView addSubview:faceBgView];
//    [faceBgView setImage:[UIImage imageByFileName:@"bg_face1" FileExtension:@"png"]];
//    
//    imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [imageButton addTarget:self action:@selector(didTouchImageButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:imageButton];
//    
//    thumbleBgView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
//    [self.contentView addSubview:thumbleBgView];
    [thumbleBgView setImage:[UIImage imageByFileName:@"bg_bmiddleImage" FileExtension:@"png"]];    
    thumbleImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:thumbleImageView];
//    
//    
//    self.selectionStyle = UITableViewCellSelectionStyleBlue;
//    
//	return self;  
    [backgroundView setImage:[UIImage imageByFileName:@"bg_papertexture" FileExtension:@"png"]];
    
    
    return self;
}

- (void)update
{   
    cellView.status = status;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.accessoryType = status.accessoryType;
    
    self.selectionStyle = (status.cellType == TWEET_CELL_TYPE_DETAIL) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
    
    //    self.contentView.backgroundColor = [UIColor whiteColor];
    cellView.frame = CGRectMake(USER_CELL_LEFT, 0, USER_CELL_WIDTH, status.cellHeight - 1);
    
    
    if (![status.bmiddlePic isEqualToString:@""]) {
        NSLog(@"status.bmiddlePic = %@",status.bmiddlePic);
        ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
        
        UIImage *image = [store getThumbnailImage:status.bmiddlePic delegate:[[[ImageStoreWaiter alloc] initWith:thumbleImageView] autorelease]];
        [thumbleImageView setImage:image];
    }
    if (status.retweetedStatus) {
        if (![status.retweetedStatus.bmiddlePic isEqualToString:@""]) {
            ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
            
            UIImage *image = [store getThumbnailImage:status.retweetedStatus.bmiddlePic delegate:[[[ImageStoreWaiter alloc] initWith:thumbleImageView] autorelease]];
            [thumbleImageView setImage:image];
        }
    }    
    
    
//    if (status.favorited) {
//        [imageButton setImage:[UserTimelineCell favoritedImage] forState:UIControlStateNormal];
//    }
//    else {
//        [imageButton setImage:[UserTimelineCell favoriteImage] forState:UIControlStateNormal];
//    }
//    
//    if (inEditing) {
//        cellView.frame = CGRectOffset(cellView.frame, -32, 0);
//        imageButton.hidden = true;
//    }
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    //    self.backgroundColor = self.contentView.backgroundColor;
    //    cellView.backgroundColor = self.contentView.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    cellView.backgroundColor = [UIColor clearColor];
    
//    imageButton.frame = CGRectMake(IMAGE_PADDING, IMAGE_PADDING, IMAGE_WIDTH, 50);
//    faceBgView.frame = CGRectMake(IMAGE_PADDING, IMAGE_PADDING , 50, 53);
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (![status.thumbnailPic isEqualToString:@""]) {
        thumbleImageView.frame = CGRectMake(24, status.cellHeight - 285, 245, 246);
        thumbleBgView.frame = CGRectMake(24, status.cellHeight - 285, 245, 253);
    }else{
        if (status.retweetedStatus && ![status.retweetedStatus.thumbnailPic isEqualToString:@""]) {
            
            thumbleImageView.frame = CGRectMake(24, status.cellHeight - 285, 245, 246);
            thumbleBgView.frame = CGRectMake(24, status.cellHeight - 285, 245, 253);
        }else{
            thumbleImageView.frame = CGRectZero;
            thumbleBgView.frame = CGRectZero;
        }
    }
    
    if (status.retweetedStatus) {
        CGFloat height = status.retweetedStatus.retweetedTextBounds.size.height;
        if (![status.retweetedStatus.thumbnailPic isEqualToString:@""]) {
            height += 260;
        }
        height += 22;
        retweetBackgroundView.frame = CGRectMake(-5, status.textBounds.origin.y+status.textBounds.size.height + 5, 300, height);
    }else{
        retweetBackgroundView.frame = CGRectZero;
    }
    
    
}
@end
