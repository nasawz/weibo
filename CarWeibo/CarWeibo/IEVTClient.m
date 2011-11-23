//
//  IEVTClient.m
//  CarWeibo
//
//  Created by zhe wang on 11-11-17.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "IEVTClient.h"

@implementation IEVTClient
@synthesize context;
@synthesize hasError;
@synthesize errorMessage;
@synthesize errorDetail;
@synthesize request;

- (id)initWithTarget:(id)aDelegate action:(SEL)anAction {
    self = [super initWithDelegate:aDelegate];
    if (self) {
        action = anAction;
        hasError = false;
    }
    return self;
}

- (void)dealloc
{
    [errorMessage release];
    [errorDetail release];
    [super dealloc];
}

#pragma mark -
- (NSString*) nameValString: (NSDictionary*) dict {
	NSArray* keys = [dict allKeys];
	NSString* result = [NSString string];
	int i;
	for (i = 0; i < [keys count]; i++) {
        result = [result stringByAppendingString:
                  [@"--" stringByAppendingString:
                   [@"0194784892923" stringByAppendingString:
                    [@"\r\nContent-Disposition: form-data; name=\"" stringByAppendingString:
                     [[keys objectAtIndex: i] stringByAppendingString:
                      [@"\"\r\n\r\n" stringByAppendingString:
                       [[dict valueForKey: [keys objectAtIndex: i]] stringByAppendingString: @"\r\n"]]]]]]];
	}
	
	return result;
}

- (NSString *)_encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)string, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}


- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
    // Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            //            [str appendString:[NSString stringWithFormat:@"%@=%@", 
            //							   name, [self _encodeString:[params objectForKey:name]]]];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
							   name, [NSString urlencode:[params objectForKey:name]]]];  
            
        }
    }
    
    return str;
}


- (NSString *)getURL:(NSString *)path 
	 queryParameters:(NSMutableDictionary*)params {
    NSString* fullPath = [NSString stringWithFormat:@"http://%@/%@",
						  API_DOMAIN, path];
	if (params) {
        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
    }
	return fullPath;
}

#pragma mark - 

- (void)IEVTConnectionDidFailWithError:(NSError*)error {
    hasError = true;
    if (error.code ==  NSURLErrorUserCancelledAuthentication) {
        statusCode = 401;
    }
    else {
        self.errorMessage = @"Connection Failed";
        self.errorDetail  = [error localizedDescription];
    }
    [self autorelease];
}

- (void)IEVTConnectionDidFinishLoading:(NSString*)content {
    switch (statusCode) {
        case 401: // Not Authorized: either you need to provide authentication credentials, or the credentials provided aren't valid.
            hasError = true;
            goto out;
            
        case 304: // Not Modified: there was no new data to return.
            goto out;
            
        case 400: // Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit
        case 200: // OK: everything went awesome.
        case 403: // Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why.
            break;
            
        case 404: // Not Found: either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user). 
        case 500: // Internal Server Error: we did something wrong.  Please post to the group about it and the Weibo team will investigate.
        case 502: // Bad Gateway: returned if Weibo is down or being upgraded.
        case 503: // Service Unavailable: the Weibo servers are up, but are overloaded with requests.  Try again later.
        default:
        {
            hasError = true;
            self.errorMessage = @"Server responded with an error";
            self.errorDetail  = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            goto out;
        }
    }
    NSObject *obj = [[content stringByConvertingHTMLToPlainText] JSONValue];  
    //    if ([obj isKindOfClass:[NSDictionary class]]) {
    //        NSDictionary* dic = (NSDictionary*)obj;
    //        NSString *code = [dic objectForKey:@"code"];
    //        if ([code isEqualToString:@"1"]) {
    //            //            NSLog(@"ROI responded with an error: %@", [dic objectForKey:@"message"]);
    //            hasError = true;
    //            self.errorMessage = @"Server Error";
    //            self.errorDetail  = [dic objectForKey:@"message"];
    //        }
    //    }
    
    [delegate performSelector:action withObject:self withObject:obj];
    
    out:
    [self autorelease];
}



#pragma mark -
#pragma mark REST API methods

/***********************************************************************************************************
 * MARK: 热门话题
 ***********************************************************************************************************
 输入参数: 
 ***********************************************************************************************************/
- (void)getHottrends {
    request = @"getHottrends";
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init]; 
    NSString *path = [NSString stringWithFormat:@"weibo/hottrends/1/json/"];
    [super get:[self getURL:path queryParameters:dict]];
    [dict release];
}

/***********************************************************************************************************
 * MARK: 提交反馈
 ***********************************************************************************************************
 输入参数: 
 contnt       内容
 ***********************************************************************************************************/
- (void)sendFeedBack:(NSString *)content {
    request = @"sendFeedBack";
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init]; 
    NSString *path = [NSString stringWithFormat:@"weibo/feedback/%@/json/",content];
    [super get:[self getURL:path queryParameters:dict]];
    [dict release];
}

@end
