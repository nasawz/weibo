//
//  AtViewController.h
//  ROIFestival
//
//  Created by zhe wang on 11-11-5.
//  Copyright (c) 2011年 Jade Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsViewController.h"

@protocol AtViewControllerDelegate;
@interface AtViewController : UIViewController {
    id        delegate;
    FriendsViewController*              friendsViewController;
}
@property (nonatomic, retain) id<AtViewControllerDelegate>          delegate;
- (void)selectFriend:(NSString*)name;
@end

@protocol AtViewControllerDelegate
@optional
- (void)didSelectFriend:(NSString *)name;
@end
