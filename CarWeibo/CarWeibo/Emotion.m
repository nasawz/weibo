//
//  Emotion.m
//  EmojiKeyboard
//
//  Created by tongzhong qian on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Emotion.h"
//#import <stdio.h>
@implementation Emotion

@synthesize tag;
@synthesize meaning;
@synthesize path;

-(id)initWithTag:(NSString *)t Meaning:(NSString *)m Path:(NSString *)p{
    [super init];
    tag=[t retain];
    meaning=[m retain];
    path=[p retain];
    return self;
}
@end
