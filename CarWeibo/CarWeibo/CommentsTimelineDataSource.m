//
//  CommentsTimelineDataSource.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-20.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "CommentsTimelineDataSource.h"
#import "ImageUtils.h"
#import "Comment.h"
#import "CommentCell.h"

@interface NSObject (CommentsTimelineControllerDelegate)
- (void)timelineDidUpdate:(CommentsTimelineDataSource*)sender count:(int)count insertAt:(int)position;
- (void)timelineDidFailToUpdate:(CommentsTimelineDataSource*)sender position:(int)position;
@end

@implementation CommentsTimelineDataSource
@synthesize comments;

- (id)initWithController:(CommentsTimelineController*)aController {
    [super init];
    controller = aController;
	comments = [[NSMutableArray array] retain];
    endCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endCell"];
    [endCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [endCell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"bg_cellEnd1" FileExtension:@"png"]]];
    return self;
}

- (void)dealloc {
	[super dealloc];
} 

- (void)getTimelineWithStatus:(Status*)status {
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
    
    
    insertPosition = 0;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"0" forKey:@"since_id"];
    [param setObject:@"200" forKey:@"count"];
    [param setObject:[NSString stringWithFormat:@"%lld",status.statusId] forKey:@"id"];
    
    [weibo getCommentsWithParams:param andDelegate:self];
}

- (void)request:(WBRequest *)request didLoad:(id)result {
    //    NSString *urlString = request.url;
    //    NSLog(@"%@",urlString);
    //	if ([urlString rangeOfString:@"statuses/public_timeline"].location !=  NSNotFound)
    //	{
    //		NSLog(@"%@",result);
    //	}
    
    weibo = nil;
    //    [loadCell.spinner stopAnimating];
    
    NSArray *ary = nil;
    if ([result isKindOfClass:[NSArray class]]) {
        ary = (NSArray*)result;
    }
    else {
        return;
    }    
    if ([ary count]) {
        // Add messages to the timeline
        for (int i = [ary count] - 1; i >= 0; --i) {
            NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            Comment* comment = [Comment commentWithJsonDictionary:[ary objectAtIndex:i]];
            [comment calcTextBounds];
            [comments insertObject:comment atIndex:insertPosition];
        }
    }
    
    if ([controller respondsToSelector:@selector(timelineDidUpdate:count:insertAt:)]) {
        [controller timelineDidUpdate:self count:[comments count] insertAt:insertPosition];
	}   
}

- (void)insertComment:(id)result {

    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic = (NSDictionary*)result;
        Comment* comment = [Comment commentWithJsonDictionary:dic];
        [comment calcTextBounds];
        [comments insertObject:comment atIndex:insertPosition];
    }
    else {
        return;
    }  
    if ([controller respondsToSelector:@selector(timelineDidUpdate:count:insertAt:)]) {
        [controller timelineDidUpdate:self count:[comments count] insertAt:insertPosition];
	}   
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([comments count] == 0) {
        [tableView setScrollEnabled:NO];
    }else{
        [tableView setScrollEnabled:YES];
    }
    return [comments count]+1;
}

//
// UITableViewDelegate
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h;
    if (indexPath.row >= [comments count]) {
        h = 60;
    }else{
        Comment* comment = (Comment*)[comments objectAtIndex:indexPath.row];
        h = comment.cellHeight;
    }
    return h;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [comments count]){
        return endCell;
    }else{
        Comment * comment = (Comment *)[comments objectAtIndex:[indexPath row]];
        CommentCell* cell = (CommentCell*)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (!cell) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
        }
        cell.comment = comment;
        [cell update];
        return cell;
    }
    return nil;
    
}
@end
