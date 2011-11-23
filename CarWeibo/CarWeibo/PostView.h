//
//  PostView.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-25.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelViewController.h"
#import "Status.h"
#import "AtViewController.h"

@class PostViewController;
@interface PostView : UIView <UITextViewDelegate,PanelViewControllerDelegate,AtViewControllerDelegate>{
    UITextView*                recipient;
    sqlite_int64                inReplyToStatusId;
    UIButton*                   btn_Both;
    UILabel*                    lab_Both;
    BOOL                        isBoth;
    UIView*                     itemsContenter;
    UILabel*                    txtCount;
    int                         totalleft;
    UIImageView *               barView;
    PanelViewController *       panelviewcontroller;
    int                         keyboardType;
    UIButton*                   btn_anim;
    PostViewController*         controller;
    
    float fy;
    NSString * keyWords;

    
    BOOL isPostMode;
}

@property (nonatomic, retain) NSString * keyWords;
@property(nonatomic, retain) PostViewController*         controller;
@property(nonatomic, retain) UITextView* recipient;
@property(nonatomic, assign) sqlite_int64 inReplyToStatusId;
@property(nonatomic, assign) BOOL isBoth;

- (void)setBothText:(NSString *)str;
- (void)setText:(NSString *)text;
- (void)bulidUI;
- (void)SetPostMode:(BOOL)flag;

@end
