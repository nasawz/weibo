//
//  UserView.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-17.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "UserView.h"
#import "ImageUtils.h"


@implementation UserView 
@synthesize user;
@synthesize height;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    
    UIImage *back = [UIImage imageNamed:@"usercell_background.png"];
    background = CGImageRetain(back.CGImage);
    
    faceBgView = [[[UIImageView alloc] initWithFrame:CGRectMake(6, 14, 57, 60)] autorelease];
    [self addSubview:faceBgView];
    [faceBgView setImage:[UIImage imageByFileName:@"bg_face1" FileExtension:@"png"]];
    
    faceImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(6, 14, 57, 57)] autorelease];
    [self addSubview:faceImageView];
    
//    url = [UIButton buttonWithType:UIButtonTypeCustom];
//    url.font = [UIFont boldSystemFontOfSize:14];  	
//    [url setTitleColor:[UIColor cellLabelColor] forState:UIControlStateNormal];
//    [url setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [url setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    url.lineBreakMode = UILineBreakModeTailTruncation;
//    url.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    url.titleShadowOffset = CGSizeMake(0, 1);
//    [self addSubview:url];
//    
//    protected = false;
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
  	CGContextDrawImage(context, rect, background);
//    
//    if (profileImage) {
////        float w = profileImage.size.width;
////        float h = profileImage.size.height;
//        float w = 50;
//        float h = 50;
//        
//        NSLog(@"===>%f,%f",w,h);
//        
//        CGMutablePathRef path = CGPathCreateMutable();
//        
//        CGPathMoveToPoint  (path, nil, 10+w, 20+h/2);
//        CGPathAddArcToPoint(path, nil, 10+w, 20+h, 10+w/2, 20+h,    8);
//        CGPathAddArcToPoint(path, nil, 10,   20+h, 10,     20+ h/2, 8);
//        CGPathAddArcToPoint(path, nil, 10,   20,   10+w/2, 20,      8);
//        CGPathAddArcToPoint(path, nil, 10+w, 20,   10+w,   20+h/2,  8);
//        CGPathCloseSubpath(path);
//        
//        // Fill rect with drop shadow
//        CGContextAddPath(context, path);
//        //        CGContextSetShadowWithColor(context, CGSizeMake(0, -3), 12, [[UIColor darkGrayColor] CGColor]);
//        // Drawing with a white stroke color
//        if (profileImage) {
//            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
//        }
//        else {
//            CGContextSetRGBFillColor(context, 0.7, 0.7, 0.7, 1.0);
//        }
//        CGContextFillPath(context);
//        
//        //        // Draw path with 2px pen
//        //        CGContextAddPath(context, path);
//        //        CGContextSetLineWidth(context, 2.0);
//        //        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
//        //        CGContextSetShadowWithColor(context, CGSizeZero, 0, [[UIColor whiteColor] CGColor]);
//        //        CGContextDrawPath(context, kCGPathStroke);
//        
//        CGContextAddPath(context, path);
//        CGContextSaveGState(context);
//        CGContextClip(context);
//        [profileImage drawAtPoint:CGPointMake(10.0, 20.0)];
//        CGContextRestoreGState(context);
//        
//        CGPathRelease(path);
//    }
}

-(void)setUser:(User*)aUser
{
    user = aUser;
    
    if (profileImage) {
        [profileImage release];
    }
    NSLog(@"user.profileImageUrl = %@",user.profileImageUrl);
    profileImage = [self getProfileImage:user.profileImageUrl isLarge:true];
    [profileImage retain];
    [faceImageView setImage:profileImage];
    
//    if ([user.url length]) {
//        [url setTitle:user.url forState:UIControlStateNormal];
//        [url setTitle:user.url forState:UIControlStateHighlighted];
//        [url addTarget:self action:@selector(didTouchURL:) forControlEvents:UIControlEventTouchUpInside];   
//    }
//    else {
//        url.enabled = false;
//    }
    
    height = 113;
//    if (hasDetail) {
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.font = [UIFont systemFontOfSize:14];
//        label.text = user.description;
//        label.lineBreakMode = UILineBreakModeTailTruncation;
//        CGRect r = [label textRectForBounds:CGRectMake(20, 105, 280, 110) limitedToNumberOfLines:10];
//        [label release];
//        height = r.size.height + 115;
//    }
    [self setNeedsDisplay];
}

- (void)updateImage:(UIImage*)image
{
    if (profileImage != image) {
        [profileImage release];
    }
    profileImage = [image retain];
    [faceImageView setImage:profileImage];
    [self setNeedsDisplay];
}

- (void)dealloc {
    
    CGImageRelease(background);
    [profileImage release];
    [super dealloc];
}

@end
