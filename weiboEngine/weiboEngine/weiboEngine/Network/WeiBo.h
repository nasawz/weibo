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

- (BOOL)isUserLoggedin;                         //Check whether the user has logged in.
- (BOOL)isDefaultUserLoggedin;					//Check whether the user has logged in.
- (void)LogOut;                                 //Remove the info about current user.
- (void)LogOutAll; 
@end

@protocol WBSessionDelegate <NSObject>

@optional
- (void)weiboDidLogin;
- (void)weiboDidDefaultLogin;
- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError*)error;
- (void)weiboDidLogout;
@end
