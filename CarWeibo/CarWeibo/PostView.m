//
//  PostView.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-25.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "PostView.h"
#import "ImageUtils.h"

@implementation PostView
@synthesize inReplyToStatusId;
@synthesize recipient;
@synthesize isBoth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 160)];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView * barView = [[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"bg_commentBar" FileExtension:@"png"]];
        [barView setFrame:CGRectMake(0, 120, 320, 40)];
        [self addSubview:barView];
        
        
        recipient = [[UITextView alloc] initWithFrame:CGRectMake(0, 4, 320, 120 - 4)];
        [recipient setFont:[UIFont systemFontOfSize:18.0f]];
        [recipient setKeyboardType:UIKeyboardTypeDefault];
        [self addSubview:recipient];
        [recipient becomeFirstResponder];
        
        
        lab_Both = [[UILabel alloc] initWithFrame:CGRectMake(45, 126, 270, 24)];
        [lab_Both setTextColor:[UIColor whiteColor]];
        [lab_Both setBackgroundColor:[UIColor clearColor]];
        [lab_Both setFont:[UIFont systemFontOfSize:16.0f]];
        [self addSubview:lab_Both];
        
        btn_Both = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_Both setImage:[UIImage imageByFileName:@"btn_select_a" FileExtension:@"png"] forState:UIControlStateNormal];
        [btn_Both setImage:[UIImage imageByFileName:@"btn_select_b" FileExtension:@"png"] forState:UIControlStateSelected];
        [btn_Both setFrame:CGRectMake(0, 118, 40, 40)];
        [btn_Both addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_Both];
        
        isBoth = NO;
    }
    return self;
}


- (void)setBothText:(NSString *)str {
    [lab_Both setText:str];
}

- (void)onTap:(UIButton *)btn {
    [btn setSelected:!btn.selected];
    isBoth = btn.selected;
}
@end
