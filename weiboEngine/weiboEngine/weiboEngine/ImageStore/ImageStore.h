#import <UIKit/UIKit.h>
#import "User.h"

@interface ImageStore : NSObject
{
	NSMutableDictionary*    images;
    NSMutableDictionary*    delegates;
	NSMutableDictionary*    pending;
    CGFloat w;
}

- (UIImage*)getProfileImage:(NSString*)url isLarge:(BOOL)flag delegate:(id)delegate;
- (UIImage*)getThumbnailImage:(NSString*)url delegate:(id)delegate;

- (void)removeDelegate:(id)delegate forURL:(NSString*)key;

- (void)releaseImage:(NSString*)url;
- (void)didReceiveMemoryWarning;

@end
