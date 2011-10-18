#import "Tweet.h"
#import "REString.h"
#import "CarWeiboAppDelegate.h"

@implementation Tweet

@synthesize tweetId;
@synthesize text;
@synthesize user;

@synthesize createdAt;
@synthesize timestamp;
@synthesize needTimestamp;

@synthesize unread;
@synthesize hasReply;
@synthesize type;
@synthesize cellType;
@synthesize textBounds;
@synthesize retweetedTextBounds;
@synthesize bubbleRect;
@synthesize cellHeight;

@synthesize accessoryType;

- (void)dealloc
{
    [text release];
    [timestamp release];
  	[super dealloc];
}

- (id)copyWithZone:(NSZone*)zone
{
    Tweet* dist = [[[self class] allocWithZone:zone] init];
    dist.tweetId    = tweetId;
	dist.text       = text;
    dist.user       = user;
    
    dist.createdAt  = createdAt;
    dist.timestamp  = timestamp;

    dist.unread     = unread;
    dist.hasReply   = hasReply;
    dist.type       = type;
    dist.cellType   = cellType;
    
    dist.accessoryType = accessoryType;
    
    return dist;
}

- (void)calcTextBounds:(int)textWidth AndHasThumble:(BOOL)flag AndRetweetedHeight:(CGFloat)height
{
    CGRect bounds, result,retweetedBounds,retweetedResult;
    
    CGFloat retweetedWidth = textWidth - 18;
    
    if (cellType == TWEET_CELL_TYPE_NORMAL) {
        bounds = CGRectMake(0, TOP + 4, textWidth, 200);
    }
    else {
        bounds = CGRectMake(0, 4, textWidth, 200);
    }
    
    retweetedBounds = CGRectMake(bounds.origin.x,bounds.origin.y,retweetedWidth,bounds.size.height);
    
    static UILabel *label = nil;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    label.font = [UIFont systemFontOfSize:(cellType == TWEET_CELL_TYPE_DETAIL) ? 14 : 13];
    label.text = text;
    
    
    static UILabel *labelRetweeted = nil;
    if (labelRetweeted == nil) {
        labelRetweeted = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    labelRetweeted.font = [UIFont systemFontOfSize:(cellType == TWEET_CELL_TYPE_DETAIL) ? 14 : 13];
    labelRetweeted.text = [NSString stringWithFormat:@"%@:%@",user.screenName,text];    
    
    result = [label textRectForBounds:bounds limitedToNumberOfLines:20];
    retweetedResult = [labelRetweeted textRectForBounds:retweetedBounds limitedToNumberOfLines:20];
    
    textBounds = CGRectMake(bounds.origin.x, bounds.origin.y, textWidth, result.size.height);
    
    retweetedTextBounds = CGRectMake(retweetedBounds.origin.x, retweetedBounds.origin.y, retweetedWidth, retweetedResult.size.height);
    //    NSLog(@"%@",text);
    //    NSLog(@"Bounds = %@",NSStringFromCGRect(textBounds));
    //    NSLog(@"Bounds = %@",NSStringFromCGRect(retweetedTextBounds));  
    //    NSLog(@"-----");
    
    if (cellType == TWEET_CELL_TYPE_NORMAL) {
        result.size.height += 18 + 15 + 2 + 8 + 4;
        if (result.size.height < IMAGE_WIDTH + 1) result.size.height = IMAGE_WIDTH + 1;
    }
    else {
        result.size.height += 40;
    }
    if (flag) {
        if (cellType == TWEET_CELL_TYPE_NORMAL) {
            result.size.height += 65;
        }
        if (cellType == TWEET_CELL_TYPE_DETAIL) {
            result.size.height += 270;
        }
    }
    result.size.height += height;
    cellHeight = result.size.height;
}

static NSString *userRegexp = @"@([0-9a-zA-Z_]+)";
static NSString *hashRegexp = @"(#[a-zA-Z0-9\\-_\\.+:=]+)";

- (void)updateAttribute
{
    NSRange range;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int hasUsername = 0;
    hasReply = false;
    NSString *tmp = text;
    
    while ([tmp matches:userRegexp withSubstring:array]) {
        NSString *match = [array objectAtIndex:0]; 
        if ([CarWeiboAppDelegate isMyScreenName:match]) {
            hasReply = true;
            if (type != TWEET_TYPE_REPLIES) {
                ++hasUsername;
            }
        }
        else {
            ++hasUsername;
        }
        range = [tmp rangeOfString:match];
        tmp = [tmp substringFromIndex:range.location + range.length];
        [array removeAllObjects];
    }
    
    tmp = text;
    if ([tmp matches:hashRegexp withSubstring:array]) {
        hasUsername = true;
    }
    
    [array release];
    //    NSLog(@"text = %@",text);
    range = [text rangeOfString:@"http://"];
    if (range.location != NSNotFound || hasUsername) {    
        accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    else {
        if (cellType == TWEET_CELL_TYPE_DETAIL) {
            accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    accessoryType = UITableViewCellAccessoryNone;

    // Convert timestamp string to UNIX time
    //
    struct tm created;
    time_t now;
    time(&now);
    
    if (!createdAt) {
        if (stringOfCreatedAt) {
            if (strptime([stringOfCreatedAt UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
                strptime([stringOfCreatedAt UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
            }
            createdAt = mktime(&created);
        }
    }
}

- (int)getConversation:(NSMutableArray*)messages
{
    // implement in deliver class
    return 0;
}

- (BOOL)hasConversation
{
    return false;
}

- (NSString*)timestamp
{
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        self.timestamp = [NSString stringWithFormat:@"%d %@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }
    else if (distance < 60 * 60) {  
        distance = distance / 60;
        self.timestamp = [NSString stringWithFormat:@"%d %@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }  
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        self.timestamp = [NSString stringWithFormat:@"%d %@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        self.timestamp = [NSString stringWithFormat:@"%d %@", distance, (distance == 1) ? @"天前" : @"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        self.timestamp = [NSString stringWithFormat:@"%d %@", distance, (distance == 1) ? @"周前" : @"周前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];        
        self.timestamp = [dateFormatter stringFromDate:date];
    }
    return timestamp;
}

@end
