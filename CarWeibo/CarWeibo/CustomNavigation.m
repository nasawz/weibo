//
//  CustomNavigation.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "CustomNavigation.h"
#import "ImageUtils.h"

@implementation CustomNavigation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 61)];
    if (self) {
        UIImage *       img_bg = [UIImage imageByFileName:@"bg_Navigation_a" FileExtension:@"png"];
        UIImageView *   view_bg = [[UIImageView alloc] initWithImage:img_bg];
        [self addSubview:view_bg];
        [img_bg release];
        [view_bg release];
    }
    return self;    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
