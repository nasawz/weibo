//
//  CustomNavigation.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "CustomNavigation.h"
#import "ImageUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomNavigation
@synthesize style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title AddStyle:(NAV_STYLE)aStyle {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 61)];
    if (self) {
        UIImage * img_bg;
        style = aStyle;
        if (aStyle == NAV_DOWNARR) {
            img_bg = [UIImage imageByFileName:@"bg_Navigation_a" FileExtension:@"png"];
        }else{
            img_bg = [UIImage imageByFileName:@"bg_Navigation_b" FileExtension:@"png"];
        }
        view_bg = [[UIImageView alloc] initWithImage:img_bg];
        [self addSubview:view_bg];
        [img_bg release];
    }
    return self;    
}

- (void)setStyle:(NAV_STYLE)aStyle {

    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionFade;
    UIImage * img_bg;
    if (aStyle == NAV_DOWNARR) {
        img_bg = [UIImage imageByFileName:@"bg_Navigation_a" FileExtension:@"png"];    
    }else{
        img_bg = [UIImage imageByFileName:@"bg_Navigation_b" FileExtension:@"png"];
    }
    [view_bg setImage:img_bg];
    [[self layer] addAnimation:animation forKey:@"animation"];
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
