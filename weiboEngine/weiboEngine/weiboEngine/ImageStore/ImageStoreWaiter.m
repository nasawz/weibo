//
//  ImageStoreWaiter.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-12.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "ImageStoreWaiter.h"

@implementation ImageStoreWaiter

- (id)initWith:(UIImageView *)aImageView
{
    self = [super init];
    if (self) {
        imageView = [aImageView retain];
    }
    
    return self;
}
- (void)imageDidGetNewImage:(UIImage*)image {
    [imageView setImage:image];
    [imageView setNeedsDisplay];
}


@end
