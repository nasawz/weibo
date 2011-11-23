//
//  PanelViewController.h
//  EmojiKeyboard
//
//  Created by tongzhong qian on 11-10-31.
//  Copyright (c) 2011年 fratalist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PanelViewControllerDelegate;

@interface PanelViewController : UIViewController<UIScrollViewDelegate>{
    UIImageView *panelBgView;
    UIScrollView *contentscrollview;
    UIView *contentview;
    UIImageView *zoomInEmotionView;
    UIImageView *tempemotionview;
    UIPageControl *pagecontrol;
   
    NSMutableArray *emotionArray;
    NSMutableArray *emotionObj;//存放emotion对象
    int isDrag;
    //UITextView *showmeaningTextView;
    
    id delegate;
    
}

@property (nonatomic, retain) id<PanelViewControllerDelegate> delegate;

-(void)readEmotionFromFile:(id)sender;
-(void)setEmotionCollection:(id)sender;


@end

@protocol PanelViewControllerDelegate
@optional
- (void)PanelViewDidSelect:(PanelViewController *)pvc WithFace:(NSString *)face;
@end
