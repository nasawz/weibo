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

@implementation TweetCellBase
@synthesize status;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  	[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    
    cellView = [[[TweetCellView alloc] initWithFrame:CGRectZero] autorelease];
    [self.contentView addSubview:cellView];
    
    imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton addTarget:self action:@selector(didTouchImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:imageButton];

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
