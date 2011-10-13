//
//  ThumbleImageView.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-12.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "ThumbleImageView.h"
#import "CarWeiboAppDelegate.h"

@implementation ThumbleImageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self setBackgroundColor:[UIColor redColor]];
        _receiver = [[ImageStoreReceiver alloc] init];
    }
    return self;
}

- (UIImage*)getThumbnailImage:(NSString*)url
{
    if (_thumbleImageUrl != url) {
        [_thumbleImageUrl release];
    }
    _thumbleImageUrl = [url copy];
    
    ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
    NSLog(@"url = %@",url);
    UIImage *image = [store getThumbnailImage:url delegate:_receiver];
    _receiver.imageContainer = self;
    return image;
}

- (void)updateImage:(UIImage*)image
{
    NSLog(@"updateImage");
    [self setImage:image];
    [self setNeedsDisplay];
}

- (void)dealloc {
    _receiver.imageContainer = nil;
    ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
    [store removeDelegate:_receiver forURL:_thumbleImageUrl];
    [_thumbleImageUrl release];
    [_receiver release];
    [super dealloc];
}

@end
