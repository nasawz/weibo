//
//  Emotion.h
//  EmojiKeyboard
//
//  Created by tongzhong qian on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject{
    NSString *tag;
    NSString *meaning;
    NSString *path;
}
@property (nonatomic,retain)NSString* tag;
@property (nonatomic, retain)NSString* meaning;
@property(nonatomic,retain) NSString* path;

-(id)initWithTag:(NSString *)t Meaning:(NSString *)m Path:(NSString *)p;
@end
