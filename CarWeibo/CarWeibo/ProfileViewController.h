//
//  ProfileViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-28.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBo.h"

#import "User.h"

@interface ProfileViewController : UIViewController <WBRequestDelegate>{
    WeiBo * weibo;
    User * currUser;
    UIImageView * faceImageView;
    UILabel*        lab_name;
    UILabel*        lab_location;
    UILabel*        txt_description;
    
    UIButton* btnLogout;
    UIButton* btnViewStatus;
}

- (void)getCurrUser;

@end
