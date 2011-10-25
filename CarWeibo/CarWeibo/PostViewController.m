//
//  PostViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-25.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "PostViewController.h"
#import "CarWeiboAppDelegate.h"
#import "WBUtil.h"

@implementation PostViewController
@synthesize status;
@synthesize postType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithPostType:(PostType)type {
    self = [super init];
    if (self) {
        
        postType = type;
        
        postView = [[PostView alloc] init];
        [postView setFrame:CGRectMake(0, 50, 320, 160)];
        [self.view addSubview:postView];
        
        CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
        
        UIButton* backButton = [delegate.rootViewController.navigation backButtonWith:[UIImage imageNamed:@"nav_btn_back.png"] highlight:nil leftCapWidth:14.0];
        [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [delegate.rootViewController.navigation setText:@"取消" onBackButton:backButton];
        delegate.rootViewController.navigation.leftButton = backButton;
        
        
        UIButton* sendButton = [delegate.rootViewController.navigation buttonWith:[UIImage imageNamed:@"nav_btn.png"] highlight:nil leftCapWidth:6.0];
        [sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
        [delegate.rootViewController.navigation setText:@" 发送 " onButton:sendButton];
        delegate.rootViewController.navigation.rightButton = sendButton;
    }
    return self;
}

- (void)setStatus:(Status *)aStatus {
    status = [aStatus retain];
    if (postType == POST_TYPE_COMMENT) {
        [postView setBothText:@"同时专发到我的微博"];
    }else{
        [postView setBothText:[NSString stringWithFormat:@"同时评论给%@",status.user.name]];
    }
}

- (void)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)send:(id)sender {
    if (postType == POST_TYPE_COMMENT) {
        if (weibo) return;
        weibo = [[WeiBo alloc] init];
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSString stringWithFormat:@"%lld",status.statusId] forKey:@"id"];
        if (postView.isBoth) {
            [param setObject:@"3" forKey:@"is_comment"];
            [param setObject:[postView.recipient.text URLEncodedString] forKey:@"status"];
            
            [weibo retweetStatusWithParams:param andDelegate:self];
        }else{
            [param setObject:[postView.recipient.text URLEncodedString] forKey:@"comment"];
            [weibo sendCommentsWithParams:param andDelegate:self];
        }
        
    }else{
        
        if (weibo) return;
        weibo = [[WeiBo alloc] init];
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[NSString stringWithFormat:@"%lld",status.statusId] forKey:@"id"];
        [param setObject:[postView.recipient.text URLEncodedString] forKey:@"status"];
        if (postView.isBoth) {
            [param setObject:@"3" forKey:@"is_comment"];
        }else{
            [param setObject:@"0" forKey:@"is_comment"];
        }
        
        [weibo retweetStatusWithParams:param andDelegate:self];
    }
}

- (void)request:(WBRequest *)request didLoad:(id)result {
    NSLog(@"=========succ");
    NSLog(@"%@",result);
    if (postType == POST_TYPE_COMMENT) {
        // TODO: 提示成功
        [self dismissModalViewControllerAnimated:YES];
    }else{
        // TODO: 提示成功
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
