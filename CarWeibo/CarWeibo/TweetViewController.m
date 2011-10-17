//
//  TweetViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-17.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "TweetViewController.h"
#import "CarWeiboAppDelegate.h"

@implementation TweetViewController

- (void)initCommon {
    userView   = [[UserView alloc] initWithFrame:CGRectMake(0, 0, 320, 77)];
}

- (void)setStatus:(Status*)value
{
    status = [value copy];
//    status.cellType = TWEET_CELL_TYPE_DETAIL;
    [status  updateAttribute];
    
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
    self = [super initWithStyle:UITableViewStyleGrouped];
    [self initCommon];
    [self setWantsFullScreenLayout:YES];
    [self setStatus:sts];
    [self.view setBackgroundColor:[UIColor clearColor]];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, 460)];
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
//    if (status) {
//        return NUM_SECTIONS;
//    }
//    else {
//        return 1;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
//    if (status) {
//        int s = sections[section];
//        switch (s) {
//            case SECTION_MESSAGE:
//                if (status.inReplyToStatusId) {
//                    return 2;
//                }
//                else {
//                    return ([status hasConversation]) ? 2 : 1;
//                }
//                break;
//            case SECTION_ACTIONS:
//                return 1;
//            case SECTION_MORE_ACTIONS:
//                return 2;
//            case SECTION_DELETE:
//                return 1;
//        }
//    }
//    return 0;
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == SECTION_MESSAGE && indexPath.row == ROW_MESSAGE) {
//        return status.cellHeight;
//    }
//    else {
//        return 44;
//    }
    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
//    if (indexPath.section == SECTION_MESSAGE && indexPath.row == ROW_MESSAGE) {
//        tweetCell.status = status;
//        [tweetCell update];
//        tweetCell.contentView.backgroundColor = [UIColor clearColor];
//        return tweetCell;
//    }
//    
//    int section = sections[indexPath.section];
//    
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
//    if (section == SECTION_MESSAGE) {
//        return userView;
//    }
//    else {
//        return nil;
//    }
    return userView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == SECTION_MESSAGE) {
//        return userView.height;
//    }
//    else {
//        return 0;
//    }
    return 77;
}


@end
