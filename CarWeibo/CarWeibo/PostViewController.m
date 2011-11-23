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
@synthesize delegate;
@synthesize keyWords;

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
        [postView setController:self];
        [postView setFrame:CGRectMake(0, 50, 320, 430)];
        [self.view addSubview:postView];
        
        
        [self reSetNav];
    }
    return self;
}

- (void)setStatus:(Status *)aStatus {
    if (aStatus) {
        [postView SetPostMode:NO];
    }else{
        [postView SetPostMode:YES];
    }
    
    [postView bulidUI];
    
    if (aStatus) {
        status = [aStatus retain];
        if (postType == POST_TYPE_COMMENT) {
            [postView setBothText:@"同时转发到我的微博"];
            
            
            [[GANTracker sharedTracker] trackPageview:@"/comment"
                                            withError:nil];
            
        }else if (postType == POST_TYPE_RETWEET){
            [postView setBothText:[NSString stringWithFormat:@"同时评论给%@",status.user.name]];
            [postView setText:[NSString stringWithFormat:@"//%@",status.text]];
            
            
            [[GANTracker sharedTracker] trackPageview:@"/tweet_info/retweet"
                                            withError:nil];
        }else if (postType == POST_TYPE_POST){
            
        }
    }else{
        [postView setText:[NSString stringWithFormat:@"#%@#",keyWords]];
        
        
        [[GANTracker sharedTracker] trackPageview:@"/post"
                                        withError:nil];
    }
}

- (void)cancel:(id)sender {
    
    
    [[GANTracker sharedTracker] trackEvent:@"PostView"
                                    action:@"touchDown"
                                     label:@"cancel"
                                     value:-1
                                 withError:nil];
    
    [self dismissModalViewControllerAnimated:YES];
}
- (void)send:(id)sender {
    
    [[GANTracker sharedTracker] trackEvent:@"PostView"
                                    action:@"touchDown"
                                     label:@"send"
                                     value:-1
                                 withError:nil];
    if (weibo)
    {
        [weibo release];
        weibo = nil;
    }
    weibo = [[WeiBo alloc] init];
    
    if (postType == POST_TYPE_COMMENT) {
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
        
    }else if(postType == POST_TYPE_RETWEET){
        
        if (weibo)
        {
            [weibo release];
            weibo = nil;
        }
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
    }else if(postType == POST_TYPE_POST){
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [weibo postWeiboRequestWithText:postView.recipient.text params:param andImage:nil andDelegate:self];
    }
}

- (void)request:(WBRequest *)request didLoad:(id)result {
    NSLog(@"=========succ");
    NSLog(@"%@",result);
    if (postType == POST_TYPE_COMMENT) {
//        [[ROIFestivalAppDelegate getAppDelegate] alert:@"发布评论成功！"];
    }else if (postType == POST_TYPE_RETWEET) {
//        [[ROIFestivalAppDelegate getAppDelegate] alert:@"专发微博成功！"];     
    }
    if ([delegate respondsToSelector:@selector(PostDidSucc:res:)]) {
        [delegate PostDidSucc:self res:result];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)reSetNav {
    
    
    CarWeiboAppDelegate *app_delegate = [CarWeiboAppDelegate getAppDelegate];
    
    UIButton* backButton = [app_delegate.rootViewController.navigation backButtonWith:[UIImage imageNamed:@"nav_btn_back.png"] highlight:nil leftCapWidth:14.0];
    [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [app_delegate.rootViewController.navigation setText:@"取消" onBackButton:backButton];
    app_delegate.rootViewController.navigation.leftButton = backButton;
    
    
    UIButton* sendButton = [app_delegate.rootViewController.navigation buttonWith:[UIImage imageNamed:@"nav_btn.png"] highlight:nil leftCapWidth:6.0];
    [sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [app_delegate.rootViewController.navigation setText:@" 发送 " onButton:sendButton];
    app_delegate.rootViewController.navigation.rightButton = sendButton;
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (postType == POST_TYPE_COMMENT) {
        [CarWeiboAppDelegate setTitle:@"评论"];
    }else if(postType == POST_TYPE_RETWEET){
        [CarWeiboAppDelegate setTitle:@"转发"];
    }else if(postType == POST_TYPE_POST){
        [CarWeiboAppDelegate setTitle:@"发布微博"];
    }
    
    
    CarWeiboAppDelegate *app_delegate = [CarWeiboAppDelegate getAppDelegate];
    [app_delegate.rootViewController hideTabBar];
    
    
    
    [[GANTracker sharedTracker] trackPageview:@"/postView"
                                    withError:nil];
}


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

- (void)setKeyWords:(NSString *)aKeyWords {
    keyWords = [aKeyWords retain];
    [postView setKeyWords:keyWords];
}


@end
