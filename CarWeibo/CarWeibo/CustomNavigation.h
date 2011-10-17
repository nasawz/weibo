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
    UIImageView *   view_bg;
}

@property (nonatomic,assign)NAV_STYLE style;

- (id)initWithTitle:(NSString *)title AddStyle:(NAV_STYLE)style;

@end
