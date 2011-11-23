//
//  LoginViewController.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBo.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate,WBSessionDelegate>{
    WeiBo*          weibo;
    UIButton* btnLogin;
    UIButton* btnClose;
    UIImageView* iconView;
    UIImageView* bg_inputView;
    
    UITextField* txt_accound;
    UITextField* txt_password;
    
    UIView* contentView;
}

- (void)doLogin:(UIButton *)sender;

@end
