//
//  CustomNavigation.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NAV_DOWNARR,
    NAV_NORMAL,
} NAV_STYLE;

@interface CustomNavigation : UIView {
    NAV_STYLE style;
    CGFloat backButtonCapWidth;
    CGFloat buttonCapWidth;
    UIImageView *   view_bg;
    
    UIButton *      leftButton;
    UIButton *      rightButton;
    
}

@property (nonatomic,assign)NAV_STYLE style;
@property (nonatomic,retain)UIButton *      leftButton;
@property (nonatomic,retain)UIButton *      rightButton;


- (id)initWithTitle:(NSString *)title AddStyle:(NAV_STYLE)style;


-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;
-(UIButton*) buttonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton;
-(void) setText:(NSString*)text onButton:(UIButton*)button;

@end
