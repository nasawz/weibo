#import "ImageDownloader.h"

@interface NSObject (ImageDownloaderDelegate)
- (void)imageDownloaderDidSucceed:(ImageDownloader*)sender;
- (void)imageDownloaderDidFail:(ImageDownloader*)sender error:(NSError*)error;
@end

@implementation ImageDownloader

- (void)dealloc
{
	[super dealloc];
}

- (void)WBConnectionDidFailWithError:(NSError*)error
{
    [delegate imageDownloaderDidFail:self error:error];
}   

- (void)WBConnectionDidFinishLoading:(NSString*)content
{
    if (statusCode == 200) {
        [delegate imageDownloaderDidSucceed:self];
    }
}

@end
