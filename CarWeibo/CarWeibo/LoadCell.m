//
//  LoadCell.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "LoadCell.h"
#import "ColorUtils.h"
#import "ImageUtils.h"

static NSString *sLabels[] = {
    @"点击加载更多微博",
    @"Load more tweets...",
    @"Load all stored tweets...",
    @"Load this user's timeline...",
    @"Loading...",
    @"Send request...",
    @"Follow request has been sent.",
};

@implementation LoadCell

@synthesize spinner;
@synthesize type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UIImageView * bgView = [[[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"bg_cellEnd" FileExtension:@"png"]] autorelease];
    [self.contentView addSubview:bgView];
    
    // name label
    label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 1;
    label.textAlignment = UITextAlignmentCenter;    
    label.frame = CGRectMake(0, 0, 320, 47);
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [self.contentView addSubview:label];
    
    spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [self.contentView addSubview:spinner];
    
	return self;    
}

- (void)setType:(loadCellType)aType
{
    type = aType;
    label.text = sLabels[type];
    [spinner stopAnimating];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = [label textRectForBounds:CGRectMake(0, 10, 320, 30) limitedToNumberOfLines:1];
    spinner.frame = CGRectMake(bounds.origin.x + bounds.size.width + 4, (self.frame.size.height / 2) - 8, 16, 16);
    label.frame = CGRectMake(0, 10, 320, 30);
}

- (void)dealloc {
	[super dealloc];
}



@end
