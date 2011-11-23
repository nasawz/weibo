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

#define MAX_BACK_BUTTON_WIDTH 160.0

@implementation CustomNavigation
@synthesize leftButton,rightButton;
@synthesize style;
@synthesize title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle AddStyle:(NAV_STYLE)aStyle {
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
        
        title = [aTitle retain];
        
        lab_title = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 50)];
        lab_title.textColor = [UIColor darkTextColor];
        [lab_title setTextAlignment:UITextAlignmentCenter];
        [lab_title setBackgroundColor:[UIColor clearColor]];
        [lab_title setFont:[UIFont systemFontOfSize:24.0f]];
        lab_title.shadowOffset = CGSizeMake(0,1);
        lab_title.shadowColor = [UIColor whiteColor];
        lab_title.text = title;
        [self addSubview:lab_title];
    }
    return self;    
}

- (void)setTitle:(NSString *)aTitle {
    title = [aTitle retain];
    lab_title.text = title;
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

-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth
{
    // store the cap width for use later when we set the text
    backButtonCapWidth = capWidth;
    
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    // Just like the standard back button, use the title of the previous item as the default back text
    [self setText:@"返回" onBackButton:button];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
    
    // Add an action for going back
    //    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(UIButton*) buttonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth {
    // store the cap width for use later when we set the text
    buttonCapWidth = capWidth;
    
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:buttonCapWidth topCapHeight:0.0];
    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:buttonCapWidth topCapHeight:0.0];
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 3.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    // Just like the standard back button, use the title of the previous item as the default back text
    [self setText:@"完成" onBackButton:button];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
    
    // Add an action for going back
    //    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;    
}

// Set the text on the custom back button
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton
{
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:backButton.titleLabel.font];
    // Change the button's frame. The width is either the width of the new text or the max width
    backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, (textSize.width + (backButtonCapWidth * 1.5)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (backButtonCapWidth * 1.5)), backButton.frame.size.height);
    
    // Set the text on the button
    [backButton setTitle:text forState:UIControlStateNormal];
}

-(void) setText:(NSString*)text onButton:(UIButton*)button {
    // Measure the width of the text
    CGSize textSize = [text sizeWithFont:button.titleLabel.font];
    // Change the button's frame. The width is either the width of the new text or the max width
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, (textSize.width + (buttonCapWidth * 1.5)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (buttonCapWidth * 1.5)), button.frame.size.height);
    
    // Set the text on the button
    [button setTitle:text forState:UIControlStateNormal];    
}

- (void)setLeftButton:(UIButton *)aLeftButton {
    if (aLeftButton) {
        CGFloat alpha = 0.0f;
        if (leftButton) {
            alpha = 1.0f;
            [leftButton removeFromSuperview];
        }
        leftButton = [aLeftButton retain];
        leftButton.frame = CGRectOffset(leftButton.frame, 10, 10);
        leftButton.alpha = alpha;
        [self addSubview:leftButton];
        [UIView beginAnimations:@"setLeftButton" context:nil];
        [UIView setAnimationDuration:0.2f];
        leftButton.alpha = 1.0f;
        [UIView commitAnimations];
    }else{
        if (leftButton) {
//            [leftButton removeFromSuperview];
            
            [UIView beginAnimations:@"setLeftButton" context:nil];
            [UIView setAnimationDuration:0.2f];
            leftButton.alpha = 0.0f;
            [UIView commitAnimations];
        }
    }
}

- (void)setRightButton:(UIButton *)aRightButton {
    if (aRightButton) {
        CGFloat alpha = 0.0f;
        if (rightButton) {
            alpha = 1.0f;
            [rightButton removeFromSuperview];
        }
        rightButton = [aRightButton retain];
        rightButton.frame = CGRectOffset(rightButton.frame, 320 - rightButton.frame.size.width - 10, 10);
        rightButton.alpha = alpha;
        [self addSubview:rightButton];
        [UIView beginAnimations:@"setRightButton" context:nil];
        [UIView setAnimationDuration:0.2f];
        rightButton.alpha = 1.0f;        
        [UIView commitAnimations];
    }else{
        if (rightButton) {
//            [rightButton removeFromSuperview];
            
            [UIView beginAnimations:@"setRightButton" context:nil];
            [UIView setAnimationDuration:0.2f];
            rightButton.alpha = 0.0f;        
            [UIView commitAnimations];
        }
    }
}

@end
