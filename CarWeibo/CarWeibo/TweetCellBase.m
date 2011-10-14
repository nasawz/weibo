//
//  TweetCellBase.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CarWeiboAppDelegate.h"
#import "TweetCellBase.h"
#import "ImageUtils.h"

@implementation TweetCellBase
@synthesize status;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  	[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    backgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    [self.contentView addSubview:backgroundView];
    
    retweetBackgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    [self.contentView addSubview:retweetBackgroundView];
    
    [backgroundView setImage:[[UIImage imageByFileName:@"bg_cell1" FileExtension:@"png"] stretchableImageWithLeftCapWidth:10 topCapHeight:20]];
    
    [retweetBackgroundView setImage:[[UIImage imageByFileName:@"timeline_rt_border" FileExtension:@"png"] stretchableImageWithLeftCapWidth:0 topCapHeight:14]];
    
    cellView = [[[TweetCellView alloc] initWithFrame:CGRectZero] autorelease];
    [self.contentView addSubview:cellView];
    
    faceBgView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    [self.contentView addSubview:faceBgView];
    [faceBgView setImage:[UIImage imageByFileName:@"bg_face1" FileExtension:@"png"]];
    
    imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton addTarget:self action:@selector(didTouchImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:imageButton];
    
    thumbleBgView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    [self.contentView addSubview:thumbleBgView];
    [thumbleBgView setImage:[UIImage imageByFileName:@"bg_thumbleImage" FileExtension:@"png"]];
    
    thumbleImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:thumbleImageView];
    

    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
	return self;  
}


- (void)dealloc
{
    [super dealloc];
}    

- (void)didTouchLinkButton:(id)sender
{
    CarWeiboAppDelegate *appDelegate = (CarWeiboAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate openLinksViewController:status.text];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.backgroundColor = self.contentView.backgroundColor;
    cellView.backgroundColor = self.contentView.backgroundColor;
}

@end
