//
//  WBAuthorize.h
//  weiboEngine
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRequest.h"
#import "NSString+SBJSON.h"


//Same as "WBRequest", this interface should also not be used directly.
//Meanwhile, the protocol "WBAuthorizeDelegate" should not be used directly either.
//Instead, you should use the functions in "weibo.h" and the protocol named "WBSessionDelegate" for user authorizing.


@class WBAuthorize;

@protocol WBAuthorizeDelegate <NSObject>


- (void)authorizeSuccess:(WBAuthorize*)auth userID:(NSString*)userID oauthToken:(NSString*)token oauthSecret:(NSString*)secret;	//Called when authorization succeed and all useful info will be returned.
- (void)authorizeDufaultSuccess:(WBAuthorize*)auth userID:(NSString*)userID oauthToken:(NSString*)token oauthSecret:(NSString*)secret;
- (void)authorizeFailed:(WBAuthorize*)auth withError:(NSError*)error;															//Called when authorization failed.

@end

@class WeiBo;
@interface WBAuthorize : NSObject <WBRequestDelegate>{
    NSString*               _defaultAccount;
    NSString*               _defaultPassword;
    NSString*               _account;
    NSString*               _password;
	NSString*				_appKey;
	NSString*				_appSecret;
	
	WBRequest*				_request;
	WeiBo*					_weibo;
	
	NSString*				_requestToken;
	NSString*				_requestSecret;
	
	id<WBAuthorizeDelegate> _delegate;
	
	BOOL					_waitingUserAuthorize;
}

@property (nonatomic,assign) id<WBAuthorizeDelegate> delegate;
@property (nonatomic) BOOL waitingUserAuthorize;					//Mark whether check the user has been authorized when the app is rerunned.

- (id)initWithAppKey:(NSString*)app_key 
	   withAppSecret:(NSString*)app_secret 
   withWeiBoInstance:(WeiBo*)weibo;

- (void)startAuthorize;
- (void)startAuthorizeByAccount:(NSString *)account Password:(NSString *)password;
- (void)startAuthorizeDefaultByAccount:(NSString *)account Password:(NSString *)password;
@end


//The gategory of the interface "WBRequest"
//Only one function used for creating a request using the authorized info with OAuth. 
@interface WBRequest (WBAuthorize)
+ (WBRequest*)getAuthorizeRequestWithParams:(NSMutableDictionary *) params
								 httpMethod:(NSString *) httpMethod 
							   postDataType:(WBRequestPostDataType) postDataType					//only valid when http method is "POST"
								   delegate:(id<WBRequestDelegate>)delegate
								 requestURL:(NSString *) url 
						   headerFieldsInfo:(NSDictionary*)headerFieldsInfo 
									 appKey:(NSString*)appkey 
								  appSecret:(NSString*)secret
								accessToken:(NSString*)token 
							   accessSecret:(NSString*)secret;
@end