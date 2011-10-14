#import "Status.h"
#import "Followee.h"
#import "DBConnection.h"
#import "REString.h"
#import "StringUtil.h"
#import "TimeUtils.h"

#import "NSDictionaryAdditions.h"

@interface Status (Private)
- (void)insertDB;
@end

// sort function of DM timeline
//
static NSInteger sortByDateDesc(id a, id b, void *context)
{
    Status* dma = (Status*)a;
    Status* dmb = (Status*)b;
    int diff = dmb.createdAt - dma.createdAt;
    if (diff > 0)
        return -1;
    else if (diff < 0)
        return 1;
    else
        return 0;
}

@implementation Status

@synthesize retweetedStatus;
@synthesize source;
@synthesize favorited;
@synthesize truncated;

@synthesize inReplyToStatusId;
@synthesize inReplyToUserId;
@synthesize inReplyToScreenName;

@synthesize thumbnailPic, bmiddlePic, originalPic;


- (void)dealloc
{
	[thumbnailPic release];
	[bmiddlePic release];
	[originalPic release];
    [inReplyToScreenName release];
    [source release];
  	[super dealloc];
}

- (Status*)initWithJsonDictionary:(NSDictionary*)dic type:(TweetType)aType
{
	self = [super init];
    
    type = aType;
    cellType = TWEET_CELL_TYPE_NORMAL;
    
	tweetId           = [[dic objectForKey:@"id"] longLongValue];
    stringOfCreatedAt   = [dic objectForKey:@"created_at"];
    if ((id)stringOfCreatedAt == [NSNull null]) {
        stringOfCreatedAt = @"";
    }

    favorited = [dic objectForKey:@"favorited"] == [NSNull null] ? 0 : [[dic objectForKey:@"favorited"] boolValue];
    truncated = [dic objectForKey:@"truncated"] == [NSNull null] ? 0 : [[dic objectForKey:@"truncated"] boolValue];
    
    NSString *tweet = [dic objectForKey:@"text"];

    if ((id)tweet == [NSNull null]) {
        text = @"";
    }
    else {
        tweet = [[tweet unescapeHTML] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        text  = [[tweet stringByReplacingOccurrencesOfString:@"\r" withString:@" "] retain];
    }

    // parse source parameter
    NSString *src = [dic objectForKey:@"source"];
    if (src == nil) {
        source = @"";
    }
    else if ((id)src == [NSNull null]) {
        source = @"";
    }
    else {
        NSRange r = [src rangeOfString:@"<a href"];
        if (r.location != NSNotFound) {
            NSRange start = [src rangeOfString:@"\">"];
            NSRange end   = [src rangeOfString:@"</a>"];
            if (start.location != NSNotFound && end.location != NSNotFound) {
                r.location = start.location + start.length;
                r.length = end.location - r.location;
                source = [[src substringWithRange:r] retain];
            }
        }
        else {
            source = [src retain];
        }
    }
    
    inReplyToStatusId   = [dic objectForKey:@"in_reply_to_status_id"]   == [NSNull null] ? 0 : [[dic objectForKey:@"in_reply_to_status_id"] longLongValue];
    //    NSLog(@"in_reply_to_user_id = %@",[dic objectForKey:@"in_reply_to_user_id"]);
    inReplyToUserId     = ([dic objectForKey:@"in_reply_to_user_id"]     == [NSNull null] || [[dic objectForKey:@"in_reply_to_user_id"] isEqualToString:@""]) ? 0 : [[dic objectForKey:@"in_reply_to_user_id"] longValue];
    inReplyToScreenName = [dic objectForKey:@"in_reply_to_screen_name"];
    
    thumbnailPic = [[dic getStringValueForKey:@"thumbnail_pic" defaultValue:@""] retain];
    bmiddlePic = [[dic getStringValueForKey:@"bmiddle_pic" defaultValue:@""] retain];
    originalPic = [[dic getStringValueForKey:@"original_pic" defaultValue:@""] retain];    
    
    //    NSLog(@"originalPic = %@",originalPic);
    
    if ((id)inReplyToScreenName == [NSNull null]) inReplyToScreenName = @"";
    if (inReplyToScreenName == nil) inReplyToScreenName = @"";
    [inReplyToScreenName retain];
	
	NSDictionary* userDic = [dic objectForKey:@"user"];
	if (userDic) {
        user = [User userWithJsonDictionary:userDic];
    }
	NSDictionary* retweetedStatusDic = [dic objectForKey:@"retweeted_status"];
	if (retweetedStatusDic) {
        retweetedStatus = [[Status statusWithJsonDictionary:retweetedStatusDic type:TWEET_TYPE_OTHER] retain];
//        retweetedStatusText = [retweetedStatus.text copy];
    }    
    [self updateAttribute];
    unread = true;

	return self;
}

- (Status*)initWithSearchResult:(NSDictionary*)dic
{
	self = [super init];
    
    type = TWEET_TYPE_SEARCH_RESULT;
    cellType = TWEET_CELL_TYPE_NORMAL;
    
	tweetId           = [[dic objectForKey:@"id"] longLongValue];
    stringOfCreatedAt   = [dic objectForKey:@"created_at"];
    if ((id)stringOfCreatedAt == [NSNull null]) {
        stringOfCreatedAt = @"";
    }
    
    NSString *tweet = [dic objectForKey:@"text"];
    
    if ((id)tweet == [NSNull null]) {
        text = @"";
    }
    else {
        tweet = [[tweet  unescapeHTML] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        text  = [[tweet stringByReplacingOccurrencesOfString:@"\r" withString:@" "] retain];
    }
    
    // parse source parameter
    source = @"";
    
    user = [User userWithSearchResult:dic];
    
    [self updateAttribute];
    
	return self;
}

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic type:(TweetType)type
{
	return [[[Status alloc] initWithJsonDictionary:dic type:type] autorelease];
}

+ (Status*)statusWithSearchResult:(NSDictionary*)dic
{
	return [[[Status alloc] initWithSearchResult:dic] autorelease];
}

- (id)copyWithZone:(NSZone *)zone
{
    Status *dist = [super copyWithZone:zone];
    
    dist.source     = source;
    dist.favorited  = favorited;
    dist.truncated  = truncated;

    dist.inReplyToStatusId   = inReplyToStatusId;
    dist.inReplyToUserId     = inReplyToUserId;
    dist.inReplyToScreenName = inReplyToScreenName;
    
    dist.thumbnailPic = thumbnailPic;
    dist.bmiddlePic = bmiddlePic;
    dist.originalPic = originalPic;
    
    dist.retweetedStatus = retweetedStatus;
    
    return dist;
}

int sTextWidth[] = {
    CELL_WIDTH,
    USER_CELL_WIDTH,
    DETAIL_CELL_WIDTH,
};

- (void)updateAttribute
{
    [super updateAttribute];
    int textWidth = sTextWidth[cellType];

    if (accessoryType == UITableViewCellAccessoryDetailDisclosureButton) {
        textWidth -= DETAIL_BUTTON_WIDTH;
    }
    else if (cellType == TWEET_CELL_TYPE_DETAIL) {
        textWidth -= H_MARGIN;
    }
    else {
        textWidth -= INDICATOR_WIDTH;
    }
    // Calculate text bounds and cell height here
    //
    CGFloat retweetedHeight = 0.0f;
//        NSLog(@"--%@",retweetedStatus.text);
    if (retweetedStatus) {
        retweetedHeight = retweetedStatus.retweetedTextBounds.size.height;
        retweetedHeight += 10;
        if (![retweetedStatus.thumbnailPic isEqualToString:@""]) {
            retweetedHeight += 75;
        }
    }
    [self calcTextBounds:textWidth AndHasThumble:(![thumbnailPic isEqualToString:@""]) AndRetweetedHeight:retweetedHeight];
}

+ (Status*)statusWithId:(sqlite_int64)aStatusId
{
    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"SELECT * FROM statuses WHERE id = ?"];
        [stmt retain];
    }

    [stmt bindInt64:aStatusId forIndex:1];
    if ([stmt step] != SQLITE_ROW) {
        [stmt reset];
        return nil;
    }
    
    Status *s = [Status initWithStatement:stmt type:TWEET_TYPE_FRIENDS];
    [stmt reset];
    return s;
}

+ (Status*)initWithStatement:(Statement*)stmt type:(TweetType)type
{
    // sqlite3 statement should be:
    //  SELECT * FROM messsages
    //
    Status *s               = [[[Status alloc] init] autorelease];
    
    s.statusId              = [stmt getInt64:0];
    s.text                  = [stmt getString:3];
    s.createdAt             = [stmt getInt32:4];
    s.source                = [stmt getString:5];
    s.favorited             = [stmt getInt32:6];
    s.truncated             = [stmt getInt32:7];
    s.inReplyToStatusId     = [stmt getInt64:8];
    s.inReplyToUserId       = [stmt getInt32:9];
    s.inReplyToScreenName   = [stmt getString:10];
    s.thumbnailPic = [stmt getString:11];
    s.bmiddlePic = [stmt getString:12];
    s.originalPic = [stmt getString:13];
    
    if ([stmt getInt64:14] != 0) {
        s.retweetedStatus = [Status statusWithId:[stmt getInt64:14]];
    }
    
    

    s.user = [User userWithId:[stmt getInt32:2]];

    if (s.user == nil) {
        return nil;
    }

    s.unread                = false;
    s.type                  = type;

    s.cellType = TWEET_CELL_TYPE_NORMAL;
    [s updateAttribute];
    
    return s;
}

+ (BOOL)isExists:(sqlite_int64)aStatusId type:(TweetType)aType
{
    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"SELECT id FROM statuses WHERE id=? and type=?"];
        [stmt retain];
    }
    
    [stmt bindInt64:aStatusId forIndex:1];
    [stmt bindInt32:aType forIndex:2];
    
    BOOL result = ([stmt step] == SQLITE_ROW) ? true : false;
    [stmt reset];
    return result;
}

- (BOOL)hasConversation
{
    sqlite_int64 inReplyTo = inReplyToStatusId;
    
    if (inReplyTo == 0) inReplyTo = -1;

//    static char *sql = "SELECT count(*) FROM statuses WHERE id = ? OR in_reply_to_status_id = ?";
    static char *sql = "SELECT count(*) FROM statuses WHERE id = ?";
    Statement *stmt = [DBConnection statementWithQuery:sql];
        
    [stmt bindInt64:inReplyToStatusId       forIndex:1];
//    [stmt bindInt64:tweetId                 forIndex:2];
    [stmt step];
        
    return [stmt getInt32:0];
}

- (int)getConversation:(NSMutableArray*)messages
{
    NSMutableDictionary *hash = [NSMutableDictionary dictionary];
    
    NSMutableArray *idArray = [NSMutableArray array];
    NSMutableArray *replyArray = [NSMutableArray array];
    
    int count = 1;
    [messages addObject:self];
    [idArray addObject:[NSNumber numberWithLongLong:self.tweetId]];
    [replyArray addObject:[NSNumber numberWithLongLong:self.inReplyToStatusId]];
     
    [hash setObject:self forKey:[NSString stringWithFormat:@"%lld", self.tweetId]];
    
    INIT_STOPWATCH(s);
    
    while ([idArray count]) {

        NSString *replies = [idArray componentsJoinedByString:@","];
        NSString *ids = [replyArray componentsJoinedByString:@","];
        
        [idArray removeAllObjects];
        [replyArray removeAllObjects];

        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM statuses WHERE id IN (%@) OR in_reply_to_status_id IN (%@)", ids, replies];
        Statement *stmt = [DBConnection statementWithQuery:[sql UTF8String]];
        
        //NSLog(@"Exec %@", sql);
        while ([stmt step] == SQLITE_ROW) {
            NSString *idStr = [NSString stringWithFormat:@"%lld", [stmt getInt64:0]];
            //NSLog(@"Found %@", idStr);
            if (![hash objectForKey:idStr]) {
                Status *s = [Status initWithStatement:stmt type:TWEET_TYPE_FRIENDS];
                [hash setObject:s forKey:idStr];
                [messages addObject:s];
                [idArray addObject:[NSNumber numberWithLongLong:s.tweetId]];
                if (s.inReplyToStatusId) {
                    [replyArray addObject:[NSNumber numberWithLongLong:s.inReplyToStatusId]];
                }
                
                // Up to 100 messages
                if (++count >= 100) break;
            }
        }
        [stmt reset];
    }
    
    LAP(s, @"Decode conversation");
    
    [messages sortUsingFunction:sortByDateDesc context:nil];    
    
    return count;
}

- (void)insertDB
{
    static Statement *stmt = nil;
    if (stmt == nil) {
        stmt = [DBConnection statementWithQuery:"REPLACE INTO statuses VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
        [stmt retain];
    }
    [stmt bindInt64:tweetId    forIndex:1];
    if (type == TWEET_TYPE_FAVORITES) {
        [stmt bindInt32:TWEET_TYPE_FRIENDS forIndex:2];
    }
    else {
        [stmt bindInt32:type        forIndex:2];
    }
    [stmt bindInt32:user.userId forIndex:3];
    
    [stmt bindString:text       forIndex:4];
    [stmt bindInt32:createdAt   forIndex:5];
    [stmt bindString:source     forIndex:6];
    [stmt bindInt32:favorited   forIndex:7];
    [stmt bindInt32:truncated   forIndex:8];
    
    [stmt bindInt64:inReplyToStatusId    forIndex:9];
    [stmt bindInt32:inReplyToUserId      forIndex:10];
    [stmt bindString:inReplyToScreenName forIndex:11];
	[stmt bindString:thumbnailPic       forIndex:12];
	[stmt bindString:bmiddlePic       forIndex:13];
	[stmt bindString:originalPic       forIndex:14];
    
	if (retweetedStatus && type != TWEET_TYPE_OTHER) {
        //        NSLog(@"insertDB %lld , type = %d",retweetedStatus.statusId,TWEET_TYPE_OTHER);
        [stmt bindInt64:retweetedStatus.statusId       forIndex:15];
	}else{
        [stmt bindInt64:0       forIndex:15];
    }
    
    if ([stmt step] != SQLITE_DONE) {
        [DBConnection alert];
    }
    [stmt reset];
    
    [user updateDB];
    
    if (retweetedStatus &&  type != TWEET_TYPE_OTHER) {
        retweetedStatus.type = TWEET_TYPE_OTHER;
		[retweetedStatus insertDB];
	}
    
    if (type == TWEET_TYPE_FRIENDS) {
        [Followee insertDB:user];
    }
}

- (void)insertDBIfFollowing
{
    Statement *stmt = [DBConnection statementWithQuery:"SELECT user_id FROM followees where user_id = ?"];
    [stmt bindInt32:user.userId forIndex:1];
    if ([stmt step] == SQLITE_ROW) {
        [self insertDB];
    }
}

- (void)deleteFromDB
{
    Statement *stmt = [DBConnection statementWithQuery:"DELETE FROM statuses WHERE id = ?"];
    [stmt bindInt64:tweetId forIndex:1];
    [stmt step]; // ignore error
}

- (void)updateFavoriteState
{
    Statement *stmt = [DBConnection statementWithQuery:"UPDATE statuses SET favorited = ? WHERE id = ?"];
    [stmt bindInt32:favorited forIndex:1];
    [stmt bindInt64:tweetId forIndex:2];
    [stmt step]; // ignore error
}

@end
