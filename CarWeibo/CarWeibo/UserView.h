//
//  UserView.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-17.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "ProfileImageView.h"

@interface UserView : ProfileImageView {
    User*               user;
    UIImage*            profileImage;
    CGImageRef          background;
    float               height;
    UIImageView *       faceBgView;
    UIImageView *       faceImageView;
    UILabel*            lab_username;
}
@property(nonatomic, assign) User*      user;
@property(nonatomic, assign) float      height;

-(void)setUser:(User*)user;

@end
