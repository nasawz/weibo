//
//  LoginViewController.m
//  CarWeibo
//
//  Created by zhe wang on 11-10-10.
//  Copyright 2011年 nasa.wang. All rights reserved.
//

#import "LoginViewController.h"
#import "ImageUtils.h"

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageByFileName:@"bg_leathertexture" FileExtension:@"png"]]];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [self.view addSubview:contentView];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 320, 460)];
        [btn addTarget:self action:@selector(moveDown) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        
        btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLogin setBackgroundImage:[[UIImage imageByFileName:@"btn_bg_blue" FileExtension:@"png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal];
        [btnLogin setFrame:CGRectMake(33, 332, 122, 38)];
        [btnLogin.titleLabel setShadowColor:[UIColor blackColor]];
        [btnLogin.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
        [btnLogin addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btnLogin];
        
        btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setBackgroundImage:[[UIImage imageByFileName:@"btn_bg_grey" FileExtension:@"png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal];
        [btnClose setFrame:CGRectMake(166, 332, 122, 38)];
        [btnClose.titleLabel setShadowColor:[UIColor blackColor]];
        [btnClose.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btnClose];   
        
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_big.png"]];
        [iconView setFrame:CGRectMake(90, 58, 141, 142)];
        [contentView addSubview:iconView];
        
        bg_inputView = [[UIImageView alloc] initWithImage:[UIImage imageByFileName:@"bg_input" FileExtension:@"png"]];
        [bg_inputView setFrame:CGRectMake(11, 211, 299, 108)];
        [contentView addSubview:bg_inputView];
        
        
        txt_accound = [[UITextField alloc] initWithFrame:CGRectMake(28, 230, 265, 30)];
        [txt_accound setKeyboardType:UIKeyboardTypeEmailAddress];
        [txt_accound setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        txt_accound.delegate = self;
        txt_accound.tag = 0;
        [txt_accound setBorderStyle:UITextBorderStyleNone];
        [txt_accound setPlaceholder:@"sina微博帐号"];
        [contentView addSubview:txt_accound];
        
        txt_password = [[UITextField alloc] initWithFrame:CGRectMake(28, 270, 265, 30)];
        [txt_password setBorderStyle:UITextBorderStyleNone];
        [txt_password setSecureTextEntry:YES];
        txt_password.delegate = self;
        txt_password.tag = 1;
        [txt_password setPlaceholder:@"帐户密码"];
        [contentView addSubview:txt_password];
    }
    return self;
}

- (void)close:(id)sender {
    [contentView setFrame:CGRectMake(0, 0, 320, 460)];
    [self dismissModalViewControllerAnimated:YES];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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


#pragma mark - UITextFieldDelegate


-(void)hiddenKeyboards {
    [txt_accound resignFirstResponder];
    [txt_password resignFirstResponder];
}

- (void)moveUp {
    [UIView beginAnimations:@"move up" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    [contentView setFrame:CGRectMake(0, -200, 320, 460)];
    [UIView commitAnimations];
}

- (void)moveDown {
    [self hiddenKeyboards];
    [UIView beginAnimations:@"move up" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    [contentView setFrame:CGRectMake(0, 0, 320, 460)];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self moveUp];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0) {
        [txt_password becomeFirstResponder];
    }else if(textField.tag == 1){
        [self doLogin];        
    }
    return YES;
}

#pragma mark - login

- (void)doLogin {
    [self moveDown];
    if( weibo )
	{
		[weibo release];
		weibo = nil;
	}
	weibo = [[WeiBo alloc] init];
	weibo.delegate = self;
    [weibo LogOut];
    [weibo startAuthorizeByAccount:txt_accound.text Password:txt_password.text];

}


#pragma mark - WBSessionDelegate
- (void)weiboDidLogin
{
	
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"用户验证已成功！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)weiboLoginFailed:(BOOL)userCancelled withError:(NSError*)error
{
	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"用户验证失败！"  
													   message:userCancelled?@"用户取消操作":[error description]  
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
@end
