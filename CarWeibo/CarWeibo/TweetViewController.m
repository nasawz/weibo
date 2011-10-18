//
//  TweetViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-17.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "TweetViewController.h"
#import "CarWeiboAppDelegate.h"
#import "ImageUtils.h"

#define NUM_SECTIONS 2
enum {
    SECTION_MESSAGE,
    SECTION_REPLAYS,
};
enum {
    ROW_MESSAGE,
    ROW_IN_REPLY_TO,
};

@implementation TweetViewController

- (void)initCommon {
    userView   = [[UserView alloc] initWithFrame:CGRectMake(0, 0, 320, 77)];
    tweetCell  = [[UserTimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
    
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    
    UIButton* backButton = [delegate.rootViewController.navigation backButtonWith:[UIImage imageNamed:@"nav_btn_back.png"] highlight:nil leftCapWidth:14.0];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    delegate.rootViewController.navigation.leftButton = backButton;
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    delegate.rootViewController.navigation.leftButton = nil;
}

- (void)setStatus:(Status*)value
{
    status = [value copy];
    status.cellType = TWEET_CELL_TYPE_DETAIL;
    [status  updateAttribute];
    if (status.retweetedStatus) {
        status.retweetedStatus.cellType = TWEET_CELL_TYPE_DETAIL;
        [status.retweetedStatus updateAttribute];
    }
    
//    actionCell.status = status;
    [userView setUser:status.user];
//    self.title = status.user.screenName;
//    
//    if ([TwitterFonAppDelegate isMyScreenName:status.user.screenName]) {
//        isOwnTweet = true;
//        sections = sOwnSection;
//    }
//    else {
//        sections = sUserSection;
//    }
    
}

- (id)initWithMessage:(Status*)sts {
    self = [super initWithStyle:UITableViewStylePlain];
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 460)];
    [self initCommon];
    [self setStatus:sts];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [userView release];
    [status  release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 460)];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageByFileName:@"bg_papertexture" FileExtension:@"png"]]];
    [self.view setBackgroundColor:[UIColor clearColor]];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    [delegate.rootViewController.navigation setStyle:NAV_NORMAL];
    [delegate.rootViewController hideTabBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    CarWeiboAppDelegate *delegate = [CarWeiboAppDelegate getAppDelegate];
    [delegate.rootViewController.navigation setStyle:NAV_DOWNARR];
    [delegate.rootViewController showTabBar];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if (status) {
        return NUM_SECTIONS;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (status) {
        int s = section;
        switch (s) {
            case SECTION_MESSAGE:
                return 1;
                break;
            case SECTION_REPLAYS:
                return 0;
                break;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_MESSAGE && indexPath.row == ROW_MESSAGE) {
        return status.cellHeight;
    }
    else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    int section = indexPath.section;
    
    NSLog(@"section = %d",section);
    
    if (indexPath.section == SECTION_MESSAGE && indexPath.row == ROW_MESSAGE) {
        tweetCell.status = status;
        [tweetCell update];
        tweetCell.contentView.backgroundColor = [UIColor clearColor];
        return tweetCell;
    }

    
    
//    if (section == SECTION_ACTIONS) {
//        return actionCell;
//    }
//    else if (section == SECTION_DELETE) {
//        [deleteCell setTitle:@"Delete this tweet"];
//        return deleteCell;
//    }
//    
//    static NSString *CellIdentifier = @"UserViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    if (section == SECTION_MESSAGE) {
//        cell.font = [UIFont boldSystemFontOfSize:15];
//        cell.textColor = [UIColor cellLabelColor];
//        cell.textAlignment = UITextAlignmentCenter;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        if ([status hasConversation]) {
//            cell.text = @"Show conversation";
//        }
//        else if (status.inReplyToStatusId) {
//            Status *inReplyToStatus = [Status statusWithId:status.inReplyToStatusId];
//            if (inReplyToStatus) {
//                cell.text = [NSString stringWithFormat:@"In-reply-to: %@: %@", status.inReplyToScreenName, inReplyToStatus.text];
//            }
//            else {
//                cell.text = [NSString stringWithFormat:@"In-reply-to: %@", status.inReplyToScreenName];
//            }
//        }
//    }
//    else if (section == SECTION_MORE_ACTIONS) {
//        cell.textAlignment = UITextAlignmentCenter;
//        cell.textColor = [UIColor cellLabelColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.text = (isOwnTweet) ? sYourDetailText[indexPath.row] : sUserDetailText[indexPath.row];
//    }
//    return cell;
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"12345"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_MESSAGE) {
        return userView;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_MESSAGE) {
        return userView.height;
    }
    else {
        return 0;
    }
}


@end
