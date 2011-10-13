//
//  ThumbleImageView.h
//  CarWeibo
//
//  Created by zhe wang on 11-10-12.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageStoreReceiver.h"

@interface ThumbleImageView : UIImageView{
    NSString*               _thumbleImageUrl;
    ImageStoreReceiver*     _receiver;
}

- (UIImage*)getThumbnailImage:(NSString*)url;

@end
