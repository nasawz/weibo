//
//  ProfileImageCell.m
//  TwitterFon
//
//  Created by kaz on 12/22/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import "ProfileImageCell.h"
#import "CarWeiboAppDelegate.h"

@implementation ProfileImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _receiver = [[ImageStoreReceiver alloc] init];
    }
    return self;
}

- (void)updateImage:(UIImage*)image
{
    // Perhaps, you need re-implement on deliver class
    [self.imageView setImage:image];
    [self setNeedsDisplay];
    [self setNeedsLayout];    
}



- (UIImage*)getProfileImage:(NSString*)url isLarge:(BOOL)flag
{
    if (_profileImageUrl != url) {
        [_profileImageUrl release];
    }
    _profileImageUrl = [url copy];
    
    ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
    UIImage *image = [store getProfileImage:url isLarge:flag delegate:_receiver];
    _receiver.imageContainer = self;
    return image;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
    [store removeDelegate:_receiver forURL:_profileImageUrl];
    _receiver.imageContainer = nil;
}

- (void)dealloc {
    _receiver.imageContainer = nil;
    ImageStore *store = [CarWeiboAppDelegate getAppDelegate].imageStore;
    [store removeDelegate:_receiver forURL:_profileImageUrl];
    [_profileImageUrl release];
    [_receiver release];
    [super dealloc];
}


@end
