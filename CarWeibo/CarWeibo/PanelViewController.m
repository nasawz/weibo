//
//  PanelViewController.m
//  EmojiKeyboard
//
//  Created by tongzhong qian on 11-10-31.
//  Copyright (c) 2011年 fratalist. All rights reserved.
//

#import "PanelViewController.h"
#import "Emotion.h"
@implementation PanelViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isDrag=0;
        pagecontrol=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 180, 320, 50)];
        
       // [self.view setBackgroundColor:[UIColor redColor]];
        
        //
        emotionObj=[[NSMutableArray alloc]init];
        //
        zoomInEmotionView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 108)];
        [zoomInEmotionView setImage:[UIImage imageNamed:@"keyboard_press.png"]];
        [zoomInEmotionView setAlpha:0.0f];
        tempemotionview=[[UIImageView alloc]initWithFrame:CGRectMake(16, 13, 32, 32)];
        //tempemotionview.frame=CGRectMake(15, 13, 32, 32);
        [zoomInEmotionView addSubview:tempemotionview];

        panelBgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emotionPanelBG.png"]];
        panelBgView.frame=CGRectMake(0, 0, 320, 216);
        
        //set the content for the emotions
        contentscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
        contentscrollview.contentSize=CGSizeMake(960, 216);
        contentscrollview.pagingEnabled=YES;
        contentscrollview.showsHorizontalScrollIndicator=NO;
        contentscrollview.delegate=self;
        // contentview
        contentview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 960, 216)];
      
    }
    return self;
}

#pragma mark  - showEmotiomIn
-(void)showEmotionIn:(id)sender{
     UIButton *btn=(UIButton *)sender;
    if(isDrag!=1){
        [zoomInEmotionView setAlpha:1.0f];
        zoomInEmotionView.frame=CGRectMake(btn.frame.origin.x-17, btn.frame.origin.y-20, 64, 108);
        //set the emotion show 
        NSString *tempath=((Emotion *)[emotionObj objectAtIndex:btn.tag]).path;
        [tempemotionview setImage:[UIImage imageNamed:tempath]];
    }
    
    if ([delegate respondsToSelector:@selector(PanelViewDidSelect:WithFace:)]) {
        [delegate PanelViewDidSelect:self WithFace:((Emotion *)[emotionObj objectAtIndex:btn.tag]).meaning];
        
    }
    
}
-(void)dragStart{
    isDrag=0;
}
-(void)hideEmotionIn:(id)sender{
    [zoomInEmotionView setAlpha:0.0f];
        
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readEmotionFromFile:self];
    [self setEmotionCollection:self];
   
    [self.view addSubview:panelBgView];
    [contentscrollview addSubview:contentview];
    [contentscrollview addSubview:zoomInEmotionView];
    [panelBgView addSubview:pagecontrol];
    [self.view addSubview:contentscrollview];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - setEmotionColletion
-(void)setEmotionCollection:(id)sender{
    int sum=emotionObj.count;
    int page;
    int row;
    //int column=7;
    //set the page of the emotionpanel
    if(sum%28==0&&sum/28!=0){
        page=sum/28;
    }else{
        page=sum/28+1;
    }
    //set the page of the pagecontrol
    pagecontrol.numberOfPages=page;
    //set the rows of every page
    if(sum%7==0){
        row=sum/7;
    }else{
        row=sum/7+1;
    }
//    NSLog(@"page = %d",page);
//    NSLog(@"row = %d",row);
    int tempage=0;
    while (page>0) { 
        page=page-1;
        
        for(int i=0;i<row;i++){
            
            for(int j=0;j<7;j++){
                if((i*7+j)==(emotionObj.count)){                    
//                    NSLog(@"-------%d",(i*7+j));
                    return;
                }
                //paging
                if((emotionObj.count-sum)/28&&(emotionObj.count-sum)%28==0){
                    tempage=tempage+1;
                }
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
               
                //btn.frame=CGRectMake((15+43*j)+320*tempage, 25+43*i, 30 , 30);
                //NSLog(@"+++++++%d",(row-xx*4));
                btn.frame=CGRectMake((15+43*j)+320*tempage, 25+43*(i%4), 30 , 30);
                    
                NSString *tempath=((Emotion *)[emotionObj objectAtIndex:(i*7+j)]).path;
                //                NSLog(@"tempath = %@",tempath);
                //NSString *tempmeaning=((Emotion *)[emotionObj objectAtIndex:(i*7+j)]).meaning;
                [btn setImage:[UIImage imageNamed:tempath] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:tempath] forState:UIControlStateHighlighted];
                btn.tag=emotionObj.count-sum;
               
                [btn addTarget:self action:@selector(showEmotionIn:) forControlEvents:UIControlEventTouchDown];
                [btn addTarget:self action:@selector(hideEmotionIn:) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:@selector(hideEmotionIn:) forControlEvents:UIControlEventTouchUpOutside];
                [btn addTarget:self action:@selector(hideEmotionIn:) forControlEvents:UIControlEventTouchDragInside];
                [btn addTarget:self action:@selector(hideEmotionIn:) forControlEvents:UIControlEventTouchCancel];
                [contentview addSubview:btn];
                sum=sum-1;
               // NSLog(@"sum = %d",sum);
            }
            
        }
        
    } //end while

}

-(void)readEmotionFromFile:(id)sender{
    NSString *ss=[[NSBundle mainBundle] pathForResource:@"emotionlist" ofType:@"txt"];
    NSString *str=[NSString stringWithContentsOfFile:ss usedEncoding:0 error:nil];
    NSArray *listItems = [str componentsSeparatedByString:@"\n"];
//    NSLog(@"count = %d",listItems.count);

    for(int i=0;i<listItems.count;i++){
        NSArray *tempemotion=[[listItems objectAtIndex:i] componentsSeparatedByString:@","];
        Emotion *emotion=[[Emotion alloc]initWithTag:@"1" Meaning:[tempemotion objectAtIndex:0]  Path:[tempemotion objectAtIndex:1]];
       [emotionObj addObject:emotion];
        
    }
//    NSLog(@"***%d",emotionObj.count);
//    NSLog(@"***%@",((Emotion *)[emotionObj objectAtIndex:2]).meaning);
}
#pragma mark -implement the delegate of the UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = contentscrollview.frame.size.width;
    int page = floor((contentscrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pagecontrol.currentPage = page;

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isDrag=1;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    isDrag=0;
}

@end
