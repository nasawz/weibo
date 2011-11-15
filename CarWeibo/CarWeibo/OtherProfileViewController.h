//
//  OtherProfileViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-11-15.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBo.h"

#import "User.h"

@interface OtherProfileViewController : UIViewController  <WBRequestDelegate>{
    WeiBo * weibo;
    User * currUser;
    UIImageView * faceImageView;
    UILabel*        lab_name;
    UILabel*        lab_location;
    UILabel*        txt_description;
    
    //    UIButton* btnLogout;
    UIButton* btnViewStatus;
}

@property (nonatomic, retain) User * currUser;

- (void)getUser;

- (void)buildUI;

@end
