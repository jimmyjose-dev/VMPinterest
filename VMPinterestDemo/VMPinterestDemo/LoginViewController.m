//
//  LoginViewController.m
//  VMPinterestDemo
//
//  Created by Jimmy on 05/01/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

/*
 
 If you have any suggestion, feature request or bug report, feel free to contact me at my fb page
 http://www.facebook.com/jimmyjose84
 
 or drop in a mail at vmpinterest@varshylmobile.com
 
 */

#import "LoginViewController.h"
#import "Reachability.h"


@interface LoginViewController () <VMPinterestDelegate,VMPinterestDebugDelegate,UITextFieldDelegate>{

    IBOutlet UITextField *emailIDTextField;
    IBOutlet UITextField *passwordTextField;
    VMPinterest *pinterest;
}

@end

@implementation LoginViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [emailIDTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [self moveFrameDown];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    emailIDTextField.delegate  = self;
    passwordTextField.delegate = self;
    
    // Make use of singleton object so that it maintains the session accross class files.
    pinterest = [VMPinterest instance];
    pinterest.delegate = self;
    pinterest.debugdelegate = self;
    
}

-(IBAction)cancelButtonPressed:(id)sender{

    NSString *reason = @"User cannceled Authentication";
    
    [self delegateErrorMsg:reason];

}

-(IBAction)doneButtonPressed:(id)sender{

    NSLog(@"%s",__func__);
    
    [emailIDTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    if(![self isConnectedToNetwork]){
        
        [self noInternetMsg];
        return;
    }
    
    NSString *emailID = emailIDTextField.text;
    emailID = [emailID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password = passwordTextField.text;
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!emailID.length) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter your email address" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (!password.length) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter your password" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = [NSString stringWithFormat:@"Signing in with email %@",emailIDTextField.text];
    
    
    [pinterest signInWithUsername:emailIDTextField.text andPassword:passwordTextField.text];

}

-(void)PinterestSignedInSuccessfullyWithUserName:(NSString *)userName{

    //I am too lazy to implement the isUserSignedIn property... probably in the next framework rev ;)
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SignedIn"];
   
    NSLog(@"PinterestSignedInSuccessfullyWithUserName");
    
    [pinterest getUsername];
    
    [self delegateSuccessMsg:userName];
}

-(void)PinterestUserName:(NSString *)userName{

    NSLog(@"username %@",userName);
}

-(void)PinterestAuthenticationFailedWithError:(NSString *)reason{

    NSLog(@"PinterestAuthenticationFailedWithError");
    
    [self delegateErrorMsg:reason];
}

-(void)PinToBoard:(NSArray *)boardNameArray{

    
    if ([delegate respondsToSelector:@selector(loginReturnedBoardList:)]) {
        [delegate loginReturnedBoardList:boardNameArray];
    }

}

-(void)PinnedSuccessfullyToBoard:(NSString *)boardName{
    
    if ([delegate respondsToSelector:@selector(loginPinnedSuccessfullyToBoard:)]) {
        [delegate loginPinnedSuccessfullyToBoard:boardName];
    }

    NSLog(@"PinnedSuccessfullyToBoard %@",boardName);
}

-(void)anErrorOccuredDueToReason:(NSString *)reason{

    [self delegateErrorMsg:reason];

}

-(void)delegateSuccessMsg:(NSString *)message{

    if ([delegate respondsToSelector:@selector(loginDidCompleteWithSuccess:)]) {
        [delegate loginDidCompleteWithSuccess:message];
    }
}

-(void)delegateErrorMsg:(NSString *)message{
    
    if ([delegate respondsToSelector:@selector(loginFailedWithError:)]) {
        [delegate loginFailedWithError:message];
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:message animated:YES];
    
}


-(void)moveFrameUp{
    
    if (self.view.frame.origin.y==-55) {
        return;
    }
    
    CGRect frame = self.view.frame;
    
    frame.origin.y -= 55;
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.view.frame = frame;
    
    [UIView commitAnimations];
    
}


-(void)moveFrameDown{
    
    if (self.view.frame.origin.y==0) {
        return;
    }
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = 0;
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.view.frame = frame;
    
    [emailIDTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    [UIView commitAnimations];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self moveFrameUp];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self moveFrameDown];
}


-(BOOL)isConnectedToNetwork{
    
    NetworkStatus internetStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if(internetStatus == NotReachable){
        return NO;
    }
    
    return YES;
    
}


-(void)noInternetMsg{
    
    //App name
    //[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    // [entry objectForKey:(id)kCGWindowOwnerName]
    
    NSString *msg = [NSString stringWithFormat:@"%@ requires an active internet connection to work .\nEDGE,3G and Wi-Fi are supported connection.",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Required" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
