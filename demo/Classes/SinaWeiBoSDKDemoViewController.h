//
//  SinaWeiBoSDKDemoViewController.h
//  SinaWeiBoSDKDemo
//
//  Created by Wu WenYong on 11-5-30.
//  Copyright 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBConnect.h"

@interface SinaWeiBoSDKDemoViewController : UIViewController
                                           <WBSessionDelegate,WBSendViewDelegate,WBRequestDelegate>{
	WeiBo* weibo;
	
	UIButton* buttonSend;
	UIButton* buttonLogout;
	UIButton* buttonGetFeed;
   
                                               UITextField * txt_account;
                                               UITextField * txt_password;
                                               
                                               
}

@property (nonatomic,assign,readonly) WeiBo* weibo;

@end

