//
//  PostView.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-25.
//  Copyright (c) 2011年 nasa.wang. All rights reserved.
//

#import "PostView.h"
#import "ImageUtils.h"
#import "PostViewController.h"

@implementation PostView
@synthesize inReplyToStatusId;
@synthesize recipient;
@synthesize isBoth;
@synthesize controller;
@synthesize keyWords;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        keyWords = @"车博通";
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        fy = 0.0f;
       
    }
    return self;
}

- (void)bulidUI {
    
    itemsContenter = [[UIView alloc] initWithFrame:CGRectMake(0, 90 + fy, 320, 30)];
    [self addSubview:itemsContenter];
    
    UIImageView * shadowView = [[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"img_shadow" FileExtension:@"png"]];
    [shadowView setFrame:CGRectMake(0, 13, 320, 9)];
    [self addSubview:shadowView];
    
    recipient = [[UITextView alloc] initWithFrame:CGRectMake(0, 6, 320, 120 - 6 - 30 + fy)];
    [recipient setFont:[UIFont systemFontOfSize:16.0f]];
    [recipient setKeyboardType:UIKeyboardTypeDefault];
    [recipient setDelegate:self];
    [self addSubview:recipient];
    [recipient becomeFirstResponder];
    
    
    
    
    UIButton* btn_trend = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_trend setImage:[UIImage imageByFileName:@"WeiboItem06" FileExtension:@"png"] forState:UIControlStateNormal];
    [btn_trend setFrame:CGRectMake(57, 6, 23, 19)];
    [btn_trend setShowsTouchWhenHighlighted:YES];
    [btn_trend addTarget:self action:@selector(addTrend) forControlEvents:UIControlEventTouchUpInside];
    [itemsContenter addSubview:btn_trend];
    
    UIButton* btn_at = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_at setImage:[UIImage imageByFileName:@"WeiboItem05" FileExtension:@"png"] forState:UIControlStateNormal];
    [btn_at setFrame:CGRectMake(113, 6, 23, 19)];
    [btn_at setShowsTouchWhenHighlighted:YES];
    [btn_at addTarget:self action:@selector(addAt) forControlEvents:UIControlEventTouchUpInside];
    [itemsContenter addSubview:btn_at];
    
    btn_anim = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_anim setImage:[UIImage imageByFileName:@"WeiboItem04" FileExtension:@"png"] forState:UIControlStateNormal];
    [btn_anim setFrame:CGRectMake(169, 6, 23, 19)];
    [btn_anim setShowsTouchWhenHighlighted:YES];
    [btn_anim addTarget:self action:@selector(addAnim:) forControlEvents:UIControlEventTouchUpInside];
    [itemsContenter addSubview:btn_anim];
    
    txtCount = [[UILabel alloc] initWithFrame:CGRectMake(251, 6, 39, 19)];
    [txtCount setText:@"140"];
    [txtCount setTextColor:[UIColor darkGrayColor]];
    [itemsContenter addSubview:txtCount];
    
    totalleft = 140;
    
    
    barView = [[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"bg_commentBar" FileExtension:@"png"]];
    [barView setFrame:CGRectMake(0, 120, 320, 40)];
    [barView setUserInteractionEnabled:YES];
    [self addSubview:barView];
    
    lab_Both = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 270, 24)];
    [lab_Both setTextColor:[UIColor whiteColor]];
    [lab_Both setBackgroundColor:[UIColor clearColor]];
    [lab_Both setFont:[UIFont systemFontOfSize:16.0f]];
    [barView addSubview:lab_Both];
    
    btn_Both = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_Both setImage:[UIImage imageByFileName:@"btn_select_a" FileExtension:@"png"] forState:UIControlStateNormal];
    [btn_Both setImage:[UIImage imageByFileName:@"btn_select_b" FileExtension:@"png"] forState:UIControlStateSelected];
    [btn_Both setFrame:CGRectMake(0, 2, 40, 40)];
    [btn_Both addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:btn_Both];
    
    isBoth = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    panelviewcontroller=[[PanelViewController alloc]init];
    [panelviewcontroller.view setFrame:CGRectMake(0, 194, 320, 216)];
    [self addSubview:panelviewcontroller.view];
    panelviewcontroller.delegate=self;
    //        [panelviewcontroller.view setHidden:YES];
    
    keyboardType = 1;
    
    [barView setHidden:isPostMode];
}

- (void)SetPostMode:(BOOL)flag {
    isPostMode = flag;
    if (isPostMode) {
        fy = 40.0f;
    }else{
        fy = 0.0f;
    }
}

- (void)setBothText:(NSString *)str {
    [lab_Both setText:str];
}

- (void)onTap:(UIButton *)btn {
    
    [[GANTracker sharedTracker] trackEvent:@"PostView"
                                    action:@"touchDown"
                                     label:@"both"
                                     value:-1
                                 withError:nil];
    
    [btn setSelected:!btn.selected];
    isBoth = btn.selected;
}

#pragma mark - 
- (void) insertString: (NSString *) insertingString intoTextView: (UITextView *) textView  
{  
    NSRange range = textView.selectedRange; 
    NSString * firstHalfString = [textView.text substringToIndex:range.location];  
    NSString * secondHalfString = [textView.text substringFromIndex: range.location];  
    textView.scrollEnabled = NO;  // turn off scrolling or you'll get dizzy ... I promise  
    
    textView.text = [NSString stringWithFormat: @"%@%@%@",  
                     firstHalfString,  
                     insertingString,  
                     secondHalfString];  
    range.location += [insertingString length];  
    textView.selectedRange = range;  
    textView.scrollEnabled = YES;  // turn scrolling back on.  
    
}

- (void)setText:(NSString *)text {
    recipient.text = text;
    [recipient setSelectedRange:NSMakeRange(0, 0)];
    [self textViewDidChange:recipient];
}
- (void)textViewDidChange:(UITextView *)textView {
    totalleft = 140 - [textView.text length];
    if (totalleft < 0) {
        totalleft = 0;
    }
    [txtCount setText:[NSString stringWithFormat:@"%d",totalleft]];
}
- (void)addTrend {
    
    [[GANTracker sharedTracker] trackEvent:@"PostView"
                                    action:@"touchDown"
                                     label:@"trend"
                                     value:-1
                                 withError:nil];
    
    [self insertString:[NSString stringWithFormat:@"#%@#",keyWords] intoTextView:recipient];
    [self textViewDidChange:recipient];
}

- (void)addAt {
    
    [[GANTracker sharedTracker] trackEvent:@"PostView"
                                    action:@"touchDown"
                                     label:@"at"
                                     value:-1
                                 withError:nil];
    //    NSLog(@"addAt");
    //    
    //    [self insertString:@"@" intoTextView:recipient];
    //    [self textViewDidChange:recipient];
    AtViewController*  atViewController = [[AtViewController alloc] init];
    [atViewController setDelegate:self];
    [controller presentModalViewController:atViewController animated:YES];
//    [controller.navigationController pushViewController:atViewController animated:YES];
}

- (void)addAnim:(UIButton *)sender {
    
    [[GANTracker sharedTracker] trackEvent:@"PostView"
                                    action:@"touchDown"
                                     label:@"anim"
                                     value:-1
                                 withError:nil];
    if (keyboardType == 1) {
        keyboardType = 0;
        [sender setImage:[UIImage imageByFileName:@"WeiboItem01" FileExtension:@"png"] forState:UIControlStateNormal];
        
        [barView setFrame:CGRectMake(0, 120+36, 320, 40)];
        [itemsContenter setFrame:CGRectMake(0, 90+36 + fy, 320, 30)];
        [recipient setFrame:CGRectMake(0, 6, 320, 120 - 6 - 30 + 36 + fy)];
        [recipient resignFirstResponder];
        //        [panelviewcontroller.view setHidden:NO];
        
    }else{
        keyboardType = 1;
        [sender setImage:[UIImage imageByFileName:@"WeiboItem04" FileExtension:@"png"] forState:UIControlStateNormal];
        
        //        [panelviewcontroller.view setHidden:YES];
        [recipient becomeFirstResponder];
        
    }
}
#pragma mark - 
- (void)keyboardWillShow:(id)sender {
    CGRect keyboardFrame;
    [[[((NSNotification *)sender) userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardFrame];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardFrame);
    // 252,216
    keyboardType = 1;
    [btn_anim setImage:[UIImage imageByFileName:@"WeiboItem04" FileExtension:@"png"] forState:UIControlStateNormal];
    if (keyboardHeight == 252.0f) {
        [barView setFrame:CGRectMake(0, 120, 320, 40)];
        [itemsContenter setFrame:CGRectMake(0, 90 + fy, 320, 30)];
        [recipient setFrame:CGRectMake(0, 6, 320, 120 - 6 - 30 + fy)];
    }else{
        [barView setFrame:CGRectMake(0, 120+36, 320, 40)];
        [itemsContenter setFrame:CGRectMake(0, 90+36 + fy, 320, 30)];
        [recipient setFrame:CGRectMake(0, 6, 320, 120 - 6 - 30 + 36 + fy)];
    }
}
#pragma mark -the delegate of the emotionpanel
- (void)PanelViewDidSelect:(PanelViewController *)pvc WithFace:(NSString *)face{
    
    [[GANTracker sharedTracker] trackEvent:@"AnimKeyBoard"
                                    action:@"select"
                                     label:@"face"
                                     value:-1
                                 withError:nil];
    
    [self insertString:[NSString stringWithFormat:@"%@",face] intoTextView:recipient];
    [self textViewDidChange:recipient];
}
#pragma mark - 
///***********************************************************************************************************
// * MARK: 获取当前所在地
// ***********************************************************************************************************
// 使用方法:
// 
// //    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
// ////    CLLocationManager_sim* locationManager = [[CLLocationManager_sim alloc] init];
// //    locationManager.delegate=self;
// //    locationManager.desiredAccuracy=kCLLocationAccuracyThreeKilometers;
// //    [locationManager startUpdatingLocation]; 
// ***********************************************************************************************************/
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"---------- locationManager didUpdateToLocation");
//    
//    
//    CLLocationCoordinate2D location=[newLocation coordinate];
//    
//    /*Geocoder Stuff*/
//    
//    MKReverseGeocoder * geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:location];
//    geoCoder.delegate=self;
//    [geoCoder start];
//}
//
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
//	NSLog(@"Reverse Geocoder Errored");
//    
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
//	NSLog(@"Geocoder completed");
//    //    NSString *subthroung=placemark.subThoroughfare;-%@,,subthroung
//    NSLog(@"城市名:%@-%@",placemark.locality,placemark.subLocality);
//}

#pragma mark - AtViewControllerDelegate
- (void)didSelectFriend:(NSString *)name {
    
    
    
    [controller reSetNav];
    [self insertString:[NSString stringWithFormat:@"%@",name] intoTextView:recipient];
    [self textViewDidChange:recipient];
}

@end
