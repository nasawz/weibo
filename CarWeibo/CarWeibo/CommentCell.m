//
//  CommentCell.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-24.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "CommentCell.h"
#import "ImageUtils.h"

@implementation CommentCell
@synthesize comment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [self.contentView addSubview:backgroundView];
        [backgroundView setImage:[[UIImage imageByFileName:@"bg_cell1" FileExtension:@"png"] stretchableImageWithLeftCapWidth:10 topCapHeight:20]];
        
        lab_name = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 210, 18)];
        [lab_name setFont:[UIFont systemFontOfSize:13.0f]];
        [lab_name setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:lab_name];
        
        lab_timestamp = [[UILabel alloc] initWithFrame:CGRectMake(235, 6, 78, 12)];
        [lab_timestamp setBackgroundColor:[UIColor clearColor]];
        [lab_timestamp setTextColor:[UIColor grayColor]];
        [lab_timestamp setTextAlignment:UITextAlignmentRight];
        [lab_timestamp setFont:[UIFont systemFontOfSize:12.0f]];
        [self.contentView addSubview:lab_timestamp];
        
        lab_text = [[UILabel alloc] initWithFrame:CGRectZero];
        [lab_text setFont:[UIFont systemFontOfSize:13.0f]];
        [lab_text setBackgroundColor:[UIColor clearColor]];
        [lab_text setLineBreakMode:UILineBreakModeWordWrap];
        [lab_text setNumberOfLines:0];
        [self.contentView addSubview:lab_text];
    }
    return self;
}

- (void)update {
    [lab_name setText:comment.user.name];
    [lab_timestamp setText:comment.timestamp];
    
    [lab_text setFrame:comment.textBounds];
    [lab_text setText:comment.text];
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)layoutSubviews
{
	[super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
