//
//  IEVTClient.h
//  CarWeibo
//
//  Created by zhe wang on 11-11-17.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEVTConnection.h"
#import "StringUtil.h"
#import "JSON.h"


@interface IEVTClient : IEVTConnection {
    NSString*           request;
    id                  context;
    SEL                 action;
    BOOL                hasError;
    NSString*           errorMessage;
    NSString*           errorDetail;
}
@property(nonatomic, readonly) NSString* request;
@property(nonatomic, assign) id context;
@property(nonatomic, assign) BOOL hasError;
@property(nonatomic, copy) NSString* errorMessage;
@property(nonatomic, copy) NSString* errorDetail;

- (id)initWithTarget:(id)aDelegate action:(SEL)anAction;


//  热门话题
- (void)getHottrends;

//  提交反馈
- (void)sendFeedBack:(NSString *)content;

@end
