//
//  WeiBo.h
//  weiboEngine
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRequest.h"
#import "WBAuthorize.h"

//#define SinaWeiBo_APPKey @"2888398119"
//#define SinaWeiBo_APPSecret @"5e9982830d03d178b7e07a83e27430a0"


#define SinaWeiBo_APPKey @"399273601"
#define SinaWeiBo_APPSecret @"9e4fc846e44db2387c5c2c52990fa424"

extern NSString* domainWeiboError;						//The domain of the error which we defined and will be returned in all the protocols.
typedef enum
{
	DEFAULT_USER,
	CURR_USER,
}LOGINTYPE;	

typedef enum
{
	CodeWeiboError_Platform	= 100,
	CodeWeiboError_SDK		= 101,
}CodeWeiboError;										//The code of the error which we defined and will be returned in all the protocols.

extern NSString* keyCodeWeiboSDKError;					//The key of the SDK error info which is A key-value pair of the userinfo of the error that we defined and will be returned in all the protocols.
typedef enum
{
	CodeWeiboSDKError_ParserError		= 200,
	CodeWeiboSDKError_GetRequestError	= 201,
	CodeWeiboSDKError_GetAccessError	= 202,
	CodeWeiboSDKError_NotAuthorized		= 203,
}CodeWeiboSDKError;										//The value of the SDK error info which is A key-value pair of the userinfo of the error that we defined and will be returned in all the protocols.



@class WBAuthorize;
@protocol WBSessionDelegate;
@protocol WBAuthorizeDelegate;


@interface WeiBo : NSObject <WBRequestDelegate,WBAuthorizeDelegate>{
    
    LOGINTYPE  loginType;
    
	NSString* _appKey;
	NSString* _appSecret;
	
	WBAuthorize* _authorize;
	
	NSString* _userID;
	NSString* _accessToken;
	NSString* _accessTokenSecret;
	
    
	NSString* _defaultUserID;
	NSString* _defaultAccessToken;
	NSString* _defaultAccessTokenSecret;
    
	WBRequest* _request;
	
	id<WBSessionDelegate> _delegate;
}

@property (nonatomic,retain,readonly) NSString* userID;
@property (nonatomic,retain,readonly) NSString* accessToken;
@property (nonatomic,retain,readonly) NSString* accessTokenSecret;
@property (nonatomic,retain,readonly) NSString* defaultAccessToken;
@property (nonatomic,retain,readonly) NSString* defaultAccessTokenSecret;
@property (nonatomic,readonly) LOGINTYPE  loginType;

@property (nonatomic,assign) id<WBSessionDelegate> delegate;

- (NSString*)urlSchemeString;                   //You should set the url scheme of your app with the string this function returned.

- (id)initWithAppKey:(NSString*)app_key         //Normally, you must use this function to init your object of WeiBo.
       withAppSecret:(NSString*)app_secret;

- (void)startAuthorizeByAccount:(NSString *)account Password:(NSString *)password;//登陆帐户
- (void)startAuthorizeDefaultByAccount:(NSString *)account Password:(NSString *)password;//登陆默认帐户 


- (WBRequest*)postWeiboRequestWithText:(NSString*)text							//Just create an URL request to post one weibo with text and image.
							  andImage:(UIImage*)image
						   andDelegate:(id <WBRequestDelegate>)delegate;

- (WBRequest*)requestWithMethodName:(NSString *)methodName						//Create a request with all these infos.
                          andParams:(NSMutableDictionary *)params
                      andHttpMethod:(NSString *)httpMethod
                        andDelegate:(id <WBRequestDelegate>)delegate;

- (WBRequest*)requestWithMethodName:(NSString *)methodName
                          andParams:(NSMutableDictionary *)params
                      andHttpMethod:(NSString *)httpMethod
                        andDelegate:(id <WBRequestDelegate>)delegate 
                        accessToken:(NSString*)token 
                       accessSecret:(NSString*)secret;


// 获取当前默认用户及其所关注用户的最新微博
- (WBRequest*)getDefaultFriendsTimelineWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;

// 根据微博ID返回某条微博的评论列表
- (WBRequest*)getCommentsWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;


// 对一条微博信息进行评论。
- (WBRequest*)sendCommentsWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;
// 转发一条微博消息。
- (WBRequest*)retweetStatusWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;

//批量获取n条微博消息的评论数和转发数。一次请求最多可以获取20条微博消息的评论数和转发数
- (WBRequest*)getStatusesCountsWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;


//按用户ID或昵称返回用户资料以及用户的最新发布的一条微博消息。
- (WBRequest*)getUserWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;


// 返回用户最新发表的微博消息列表。
- (WBRequest*)getUserTimelineWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;

// 获取某话题下的微博消息。
- (WBRequest*)getTrendsTimelineWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;


// 关注某话题。
- (WBRequest*)getTrendFollowTimelineWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;


// 获取某用户的话题。
- (WBRequest*)getTrendsWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;


// 获取用户关注列表及每个关注用户的最新一条微博，返回结果按关注时间倒序排列，最新关注的用户排在最前面。
- (WBRequest*)getFriendsWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;


// 发布一条微博信息。也可以同时转发某条微博。请求必须用POST方式提交。
- (WBRequest*)updateTweetWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;

// 发表带图片的微博。必须用POST方式提交pic参数，且Content-Type必须设置为multipart/form-data。图片大小<5M。
- (WBRequest*)uploadTweetWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate;

- (WBRequest*)postWeiboRequestWithText:(NSString*)text							//Just create an URL request to post one weibo with text and image.
                                params:(NSMutableDictionary*)params
							  andImage:(UIImage*)image
						   andDelegate:(id <WBRequestDelegate>)delegate;


- (BOOL)isUserLoggedin;                         //Check whether the user has logged in.
- (BOOL)isDefaultUserLoggedin;					//Check whether the user has logged in.
- (void)LogOut;                                 //Remove the info about current user.
- (void)LogOutAll; 
- (void)cancel;
@end

@protocol WBSessionDelegate <NSObject>

@optional
- (void)weiboDidLogin;
- (void)weiboDidDefaultLogin;
- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError*)error;
- (void)weiboDidLogout;
@end
