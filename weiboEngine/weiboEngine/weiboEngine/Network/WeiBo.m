//
//  WeiBo.m
//  weiboEngine
//
//  Created by zhe wang on 11-9-30.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "WeiBo.h"
#import "WBUtil.h"
#import "SFHFKeychainUtils.h"

#define WeiBoSchemePre                      @"wb"

#define kKeyChainServiceNameForWeiBo		@"_WeiBoUserInfo"

#define kKeyChainUserIDForWeiBo				@"userID"
#define kKeyChainAccessTokenForWeiBo		@"accessToken"
#define kKeyChainAccessSecretForWeiBo		@"accessSecret"


#define kKeyChainDefaultUserIDForWeiBo				@"userID"
#define kKeyChainDefaultAccessTokenForWeiBo         @"accessToken"
#define kKeyChainDefaultAccessSecretForWeiBo		@"accessSecret"

NSString* domainWeiboError      =    @"domainWeiboError";
NSString* keyCodeWeiboSDKError  =    @"weibo_error_code";

static NSString* weiboHttpRequestDomain		= @"http://api.t.sina.com.cn/";



@implementation WeiBo
@synthesize userID = _userID,accessToken = _accessToken,accessTokenSecret = _accessTokenSecret,delegate=_delegate;
@synthesize loginType;

- (NSString*)urlSchemeString
{
	return [NSString stringWithFormat:@"%@%@",WeiBoSchemePre,_appKey];
}

- (id)initWithAppKey:(NSString*)app_key 
       withAppSecret:(NSString*)app_secret
{
	if (self = [super init]) {
		_appKey		= [[NSString alloc]initWithString:app_key];
		_appSecret	= [[NSString alloc]initWithString:app_secret];
		
		
		//When object is created, the user info stored in the KeyChain will be readed out firstly.
		NSString* serviceName = [[self urlSchemeString] stringByAppendingString:kKeyChainServiceNameForWeiBo];
		_userID = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainUserIDForWeiBo andServiceName:serviceName error:nil]retain];
		_accessToken = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainAccessTokenForWeiBo andServiceName:serviceName error:nil]retain];
		_accessTokenSecret = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainAccessSecretForWeiBo andServiceName:serviceName error:nil]retain];
        
        _defaultUserID = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainDefaultUserIDForWeiBo andServiceName:serviceName error:nil]retain];
		_defaultAccessToken = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainDefaultAccessTokenForWeiBo andServiceName:serviceName error:nil]retain];
		_defaultAccessTokenSecret = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainDefaultAccessSecretForWeiBo andServiceName:serviceName error:nil]retain];
        
	}
	return self;
}

- (id)init {
	if (self = [super init]) {
		_appKey		= [[NSString alloc]initWithString:SinaWeiBo_APPKey];
		_appSecret	= [[NSString alloc]initWithString:SinaWeiBo_APPSecret];
		
		
		//When object is created, the user info stored in the KeyChain will be readed out firstly.
		NSString* serviceName = [[self urlSchemeString] stringByAppendingString:kKeyChainServiceNameForWeiBo];
		_userID = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainUserIDForWeiBo andServiceName:serviceName error:nil]retain];
		_accessToken = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainAccessTokenForWeiBo andServiceName:serviceName error:nil]retain];
		_accessTokenSecret = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainAccessSecretForWeiBo andServiceName:serviceName error:nil]retain];
        
        _defaultUserID = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainDefaultUserIDForWeiBo andServiceName:serviceName error:nil]retain];
		_defaultAccessToken = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainDefaultAccessTokenForWeiBo andServiceName:serviceName error:nil]retain];
		_defaultAccessTokenSecret = [[SFHFKeychainUtils getPasswordForUsername:kKeyChainDefaultAccessSecretForWeiBo andServiceName:serviceName error:nil]retain];
        
	}
	return self;    
}

- (void)dealloc
{
	[_appKey release];_appKey=nil;
	[_appSecret release];_appSecret=nil;
	
	if( _userID ){[_userID release];_userID=nil;}
	if( _accessToken ){[_accessToken release];_accessToken=nil;}
	if( _accessTokenSecret ){[_accessTokenSecret release];_accessTokenSecret=nil;}
	
    
	if( _defaultUserID ){[_defaultUserID release];_defaultUserID=nil;}
	if( _defaultAccessToken ){[_defaultAccessToken release];_defaultAccessToken=nil;}
	if( _defaultAccessTokenSecret ){[_defaultAccessTokenSecret release];_defaultAccessTokenSecret=nil;}
    
	if (_authorize){[_authorize release];_authorize = nil;}
	
	[super dealloc];
}

#pragma mark -
#pragma mark For User Authorize
- (void)startAuthorizeByAccount:(NSString *)account Password:(NSString *)password {
    loginType = CURR_USER;
    //First we check out whether the user has been logged in.
	if( [self isUserLoggedin] )
	{
		if( [_delegate respondsToSelector:@selector(weiboDidLogin)] )
			[_delegate weiboDidLogin];
		return;
	}
	
	if( _authorize )
	{
		[_authorize release];
		_authorize = nil;
	}
    //Finally, an object of WBAuthorize is created and started.
	_authorize = [[WBAuthorize alloc]initWithAppKey:_appKey withAppSecret:_appSecret withWeiBoInstance:self];
	[_authorize startAuthorizeByAccount:account Password:password];
	_authorize.delegate = self;    
}
- (void)startAuthorizeDefaultByAccount:(NSString *)account Password:(NSString *)password {
    loginType = DEFAULT_USER;
    //First we check out whether the user has been logged in.
	if( [self isDefaultUserLoggedin] )
	{
		if( [_delegate respondsToSelector:@selector(weiboDidDefaultLogin)] )
			[_delegate weiboDidDefaultLogin];
		return;
	}
	
	if( _authorize )
	{
		[_authorize release];
		_authorize = nil;
	}
    //Finally, an object of WBAuthorize is created and started.
	_authorize = [[WBAuthorize alloc]initWithAppKey:_appKey withAppSecret:_appSecret withWeiBoInstance:self];
	[_authorize startAuthorizeDefaultByAccount:account Password:password];
	_authorize.delegate = self;
}

- (void)authorizeSuccess:(WBAuthorize*)auth userID:(NSString*)userID oauthToken:(NSString*)token oauthSecret:(NSString*)secret
{
	if( _userID ){[_userID release];_userID=nil;}
	if( _accessToken ){[_accessToken release];_accessToken=nil;}
	if( _accessTokenSecret ){[_accessTokenSecret release];_accessTokenSecret=nil;}
	
	_userID = [userID retain];
	_accessToken = [token retain];
	_accessTokenSecret = [secret retain];
	
	//If authorize succeed, the user info will be stored in the keychain.
	NSString* serviceName = [[self urlSchemeString] stringByAppendingString:kKeyChainServiceNameForWeiBo];
	[SFHFKeychainUtils storeUsername:kKeyChainUserIDForWeiBo andPassword:_userID forServiceName:serviceName updateExisting:YES error:nil];
	[SFHFKeychainUtils storeUsername:kKeyChainAccessTokenForWeiBo andPassword:_accessToken forServiceName:serviceName updateExisting:YES error:nil];
	[SFHFKeychainUtils storeUsername:kKeyChainAccessSecretForWeiBo andPassword:_accessTokenSecret forServiceName:serviceName updateExisting:YES error:nil];
	
	//and then tell the delegate.
	if( [_delegate respondsToSelector:@selector(weiboDidLogin)] )
		[_delegate weiboDidLogin];
}


- (void)authorizeDufaultSuccess:(WBAuthorize*)auth userID:(NSString*)userID oauthToken:(NSString*)token oauthSecret:(NSString*)secret {
	if( _defaultUserID ){[_defaultUserID release];_defaultUserID=nil;}
	if( _defaultAccessToken ){[_defaultAccessToken release];_defaultAccessToken=nil;}
	if( _defaultAccessTokenSecret ){[_defaultAccessTokenSecret release];_defaultAccessTokenSecret=nil;}
	
	_defaultUserID = [userID retain];
	_defaultAccessToken = [token retain];
	_defaultAccessTokenSecret = [secret retain];
	
	//If authorize succeed, the user info will be stored in the keychain.
	NSString* serviceName = [[self urlSchemeString] stringByAppendingString:kKeyChainServiceNameForWeiBo];
	[SFHFKeychainUtils storeUsername:kKeyChainDefaultUserIDForWeiBo andPassword:_defaultUserID forServiceName:serviceName updateExisting:YES error:nil];
	[SFHFKeychainUtils storeUsername:kKeyChainDefaultAccessTokenForWeiBo andPassword:_defaultAccessToken forServiceName:serviceName updateExisting:YES error:nil];
	[SFHFKeychainUtils storeUsername:kKeyChainDefaultAccessSecretForWeiBo andPassword:_defaultAccessTokenSecret forServiceName:serviceName updateExisting:YES error:nil];
	
	//and then tell the delegate.
	if( [_delegate respondsToSelector:@selector(weiboDidDefaultLogin)] )
		[_delegate weiboDidDefaultLogin];    
}

- (void)authorizeFailed:(WBAuthorize*)auth withError:(NSError*)error
{
	//If the authorize failed, just tell the delegate.
	if( [_delegate respondsToSelector:@selector(weiboLoginFailed:withError:)] )
		[_delegate weiboLoginFailed:NO withError:error];
}

- (void)removeInfoAndDefault:(BOOL)flag
{
	//remove the info stored in the keychain.
	NSString* serviceName = [[self urlSchemeString] stringByAppendingString:kKeyChainServiceNameForWeiBo];
	[SFHFKeychainUtils deleteItemForUsername:kKeyChainUserIDForWeiBo andServiceName:serviceName error:nil];
	[SFHFKeychainUtils deleteItemForUsername:kKeyChainAccessTokenForWeiBo andServiceName:serviceName error:nil];
	[SFHFKeychainUtils deleteItemForUsername:kKeyChainAccessSecretForWeiBo andServiceName:serviceName error:nil];
	//remove the info in the memory.
	if( _userID ){[_userID release];_userID=nil;}
	if( _accessToken ){[_accessToken release];_accessToken=nil;}
	if( _accessTokenSecret ){[_accessTokenSecret release];_accessTokenSecret=nil;}
    
    if (flag) {
        [SFHFKeychainUtils deleteItemForUsername:kKeyChainDefaultUserIDForWeiBo andServiceName:serviceName error:nil];
        [SFHFKeychainUtils deleteItemForUsername:kKeyChainDefaultAccessTokenForWeiBo andServiceName:serviceName error:nil];
        [SFHFKeychainUtils deleteItemForUsername:kKeyChainDefaultAccessSecretForWeiBo andServiceName:serviceName error:nil];
        //remove the info in the memory.
        if( _defaultUserID ){[_defaultUserID release];_defaultUserID=nil;}
        if( _defaultAccessToken ){[_defaultAccessToken release];_defaultAccessToken=nil;}
        if( _defaultAccessTokenSecret ){[_defaultAccessTokenSecret release];_defaultAccessTokenSecret=nil;}
    }
}

- (BOOL)isUserLoggedin
{
	//If all the three params are exist, we count that the user has been logged in.
	return _userID && _accessToken && _accessTokenSecret;
}

- (BOOL)isDefaultUserLoggedin
{
	//If all the three params are exist, we count that the user has been logged in.
	return _defaultUserID && _defaultAccessToken && _defaultAccessTokenSecret;
}

- (void)LogOut
{
	//Log out just means removing all the user info.
	[self removeInfoAndDefault:NO];
	
	if( [_delegate respondsToSelector:@selector(weiboDidLogout)] )
		[_delegate weiboDidLogout];
}
- (void)LogOutAll {
	//Log out just means removing all the user info.
	[self removeInfoAndDefault:YES];
	
	if( [_delegate respondsToSelector:@selector(weiboDidLogout)] )
		[_delegate weiboDidLogout];    
}

- (void)cancel {
    [_request.connection cancel];
}

#pragma mark -
#pragma mark For Http Request
//this funcion is used for posting multipart datas.
- (WBRequest*)postRequestWithMethodName:(NSString *)methodName
							  andParams:(NSMutableDictionary *)params
						andPostDataType:(WBRequestPostDataType)postDataType
							andDelegate:(id <WBRequestDelegate>)delegate
{
	//Before this function is used, user authorizing must be finished firstly.
	//Otherwise, an error will be throwed out.
	if( [self isUserLoggedin] == FALSE )
	{
		if( [delegate respondsToSelector:@selector(request:didFailWithError:)] )
			[delegate request:nil didFailWithError:[NSError errorWithDomain:domainWeiboError 
																	   code:CodeWeiboError_SDK 
																   userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",CodeWeiboSDKError_NotAuthorized] forKey:keyCodeWeiboSDKError]]];
		return nil;
	}
	
	if( _request )
	{
		[_request release];
		_request = nil;
	}
	
	_request = [WBRequest getAuthorizeRequestWithParams:params
											 httpMethod:@"POST"
										   postDataType:postDataType 
											   delegate:delegate 
											 requestURL:[NSString stringWithFormat:@"%@%@",weiboHttpRequestDomain,methodName]
									   headerFieldsInfo: nil 
												 appKey:_appKey	
											  appSecret:_appSecret
											accessToken:_accessToken
										   accessSecret:_accessTokenSecret];
	
	[_request connect];
	[_request retain];
	
	return _request;
}

- (WBRequest*)requestWithMethodName:(NSString *)methodName
                          andParams:(NSMutableDictionary *)params
                      andHttpMethod:(NSString *)httpMethod
                        andDelegate:(id <WBRequestDelegate>)delegate
{
	if( [self isUserLoggedin] == FALSE )
	{
		if( [delegate respondsToSelector:@selector(request:didFailWithError:)] )
			[delegate request:nil didFailWithError:[NSError errorWithDomain:domainWeiboError 
																	   code:CodeWeiboError_SDK 
																   userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",CodeWeiboSDKError_NotAuthorized] forKey:keyCodeWeiboSDKError]]];
		return nil;
	}
	
	if( _request )
	{
		[_request release];
		_request = nil;
	}
	
	_request = [WBRequest getAuthorizeRequestWithParams:params
											 httpMethod:httpMethod
										   postDataType:WBRequestPostDataType_Normal 
											   delegate:delegate 
											 requestURL:[NSString stringWithFormat:@"%@%@",weiboHttpRequestDomain,methodName]
									   headerFieldsInfo: nil 
												 appKey:_appKey	
											  appSecret:_appSecret
											accessToken:_accessToken
										   accessSecret:_accessTokenSecret];
	
	[_request connect];
	[_request retain];
	
	return _request;
}

- (WBRequest*)requestWithMethodName:(NSString *)methodName
                          andParams:(NSMutableDictionary *)params
                      andHttpMethod:(NSString *)httpMethod
                        andDelegate:(id <WBRequestDelegate>)delegate 
                        accessToken:(NSString*)token 
                       accessSecret:(NSString*)secret {
	
	if( _request )
	{
		[_request release];
		_request = nil;
	}
	
	_request = [WBRequest getAuthorizeRequestWithParams:params
											 httpMethod:httpMethod
										   postDataType:WBRequestPostDataType_Normal 
											   delegate:delegate 
											 requestURL:[NSString stringWithFormat:@"%@%@",weiboHttpRequestDomain,methodName]
									   headerFieldsInfo: nil 
												 appKey:_appKey	
											  appSecret:_appSecret
											accessToken:token
										   accessSecret:secret];
	
	[_request connect];
	[_request retain];
	
	return _request;    
}

- (WBRequest*)getDefaultFriendsTimelineWithParams:(NSMutableDictionary*)params andDelegate:(id <WBRequestDelegate>)delegate {
    if( [self isDefaultUserLoggedin] == FALSE )
	{
		if( [delegate respondsToSelector:@selector(request:didFailWithError:)] )
			[delegate request:nil didFailWithError:[NSError errorWithDomain:domainWeiboError 
																	   code:CodeWeiboError_SDK 
																   userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",CodeWeiboSDKError_NotAuthorized] forKey:keyCodeWeiboSDKError]]];
		return nil;
	}
	
	if( _request )
	{
		[_request release];
		_request = nil;
	}
	
	_request = [WBRequest getAuthorizeRequestWithParams:params
											 httpMethod:@"GET"
										   postDataType:WBRequestPostDataType_Normal 
											   delegate:delegate 
											 requestURL:[NSString stringWithFormat:@"%@%@",weiboHttpRequestDomain,@"statuses/friends_timeline.json"]
									   headerFieldsInfo: nil 
												 appKey:_appKey	
											  appSecret:_appSecret
											accessToken:_defaultAccessToken
										   accessSecret:_defaultAccessTokenSecret];
	
	[_request connect];
	[_request retain];
	
	return _request; 
}

#pragma mark For Post Weibo
- (WBRequest*)postWeiboRequestWithText:(NSString*)text
							  andImage:(UIImage*)image 
						   andDelegate:(id <WBRequestDelegate>)delegate
{
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
	[params setObject:text?text:@"" forKey:@"status"];
	if( image )
		[params setObject:image forKey:@"pic"];
	
	
	if( image )
		return [self postRequestWithMethodName:@"statuses/upload.json" 
									 andParams:params 
							   andPostDataType:WBRequestPostDataType_Multipart 
								   andDelegate:delegate];
	else
		return [self requestWithMethodName:@"statuses/update.json" 
								 andParams:params 
							 andHttpMethod:@"POST" 
							   andDelegate:delegate];
}





@end
