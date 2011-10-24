#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "User.h"
#import "Tweet.h"

@class Statement;

#define IMAGE_PADDING       10
#define H_MARGIN            10
#define INDICATOR_WIDTH     (30 - H_MARGIN)
#define DETAIL_BUTTON_WIDTH (45 - H_MARGIN)

#define IMAGE_WIDTH         50
#define USER_CELL_LEFT      15
#define STAR_BUTTON_WIDTH   32

#define TOP                 (16 + 1 + 8)
#define LEFT                (IMAGE_PADDING * 2 + IMAGE_WIDTH)
#define CELL_WIDTH          (320 - LEFT)
#define TIMESTAMP_WIDTH     60
#define TIMESTAMP_LEFT      (LEFT + CELL_WIDTH) - TIMESTAMP_WIDTH

#define USER_CELL_WIDTH     (320 - USER_CELL_LEFT)
#define DETAIL_CELL_WIDTH   (300 - USER_CELL_LEFT)

@interface Status : Tweet
{
    NSString*       source;
    BOOL            favorited;
    BOOL            truncated;
    sqlite_int64    inReplyToStatusId;
    int             inReplyToUserId;
    NSString*       inReplyToScreenName;
    Status*         retweetedStatus;
    
	NSString*		thumbnailPic; //缩略图
	NSString*		bmiddlePic; //中型图片
	NSString*		originalPic; //原始图片    
    
    int             repostsCount;//转发数
    int             commentsCount;//评论数
}

@property (getter=tweetId, setter=setTweetId:) sqlite_int64  statusId;
//@property (nonatomic, retain) User*         user;
@property (nonatomic, retain) Status*		retweetedStatus; //转发的博文，内容为status，如果不是转发，则没有此字段
@property (nonatomic, retain) NSString*     source;
@property (nonatomic, assign) BOOL          favorited;
@property (nonatomic, assign) BOOL          truncated;
@property (nonatomic, assign) sqlite_int64  inReplyToStatusId;
@property (nonatomic, assign) int           inReplyToUserId;
@property (nonatomic, retain) NSString*     inReplyToScreenName;

@property (nonatomic, retain) NSString*		thumbnailPic; //缩略图
@property (nonatomic, retain) NSString*		bmiddlePic; //中型图片
@property (nonatomic, retain) NSString*		originalPic; //原始图片


+ (Status*)statusWithId:(sqlite_int64)statusId;
+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic type:(TweetType)type;
+ (Status*)statusWithSearchResult:(NSDictionary*)dic;
+ (Status*)initWithStatement:(Statement*)statement type:(TweetType)type;
+ (BOOL)isExists:(sqlite_int64)statusId type:(TweetType)aType;

- (Status*)initWithJsonDictionary:(NSDictionary*)dic type:(TweetType)type;
- (Status*)initWithSearchResult:(NSDictionary*)dic;
- (void)updateAttribute;

- (void)insertDB;
- (void)insertDBIfFollowing;
- (void)deleteFromDB;
- (void)updateFavoriteState;

@end
