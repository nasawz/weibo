//
//  FriendsViewController.m
//  ROIFestival
//
//  Created by zhe wang on 11-11-5.
//  Copyright (c) 2011年 Jade Studio. All rights reserved.
//

#import "FriendsViewController.h"
#import "AtViewController.h"

@implementation FriendsViewController
@synthesize controller;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        friends = [[NSMutableArray alloc] init];
        
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self getFriends];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
- (void)getFriends {
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"200" forKey:@"count"];
    [param setObject:weibo.userID forKey:@"user_id"];
    [weibo getFriendsWithParams:param andDelegate:self];
}

- (void)friendDidUpdateCount:(int)count insertAt:(int)position
{
    [self.tableView beginUpdates];
    if (count != 0) {
        NSMutableArray *insertion = [[[NSMutableArray alloc] init] autorelease];
        
        int numInsert = count;
        // Avoid to create too many table cell.
        //            if (numInsert > 8) numInsert = 8;
        for (int i = 0; i < numInsert; ++i) {
            [insertion addObject:[NSIndexPath indexPathForRow:position + i inSection:0]];
        }        
        [self.tableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
}
- (void)request:(WBRequest *)request didLoad:(id)result {
    weibo = nil;
    NSArray *ary = nil;
    if ([result isKindOfClass:[NSArray class]]) {
        ary = (NSArray*)result;
    }
    else {
        return;
    }    
    if ([ary count]) {
        for (int i = [ary count] - 1; i >= 0; --i) {
            NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            User * friend = [[User alloc] initWithJsonDictionary:dic];
            [friends addObject:friend];
        }
    }
    [self friendDidUpdateCount:[ary count] insertAt:0];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"@%@",((User *)[friends objectAtIndex:[indexPath row]]).name];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([controller respondsToSelector:@selector(selectFriend:)]) {
        NSString* friendName = [NSString stringWithFormat:@"@%@",((User *)[friends objectAtIndex:[indexPath row]]).name];
        [controller selectFriend:friendName];
    }
}

@end
