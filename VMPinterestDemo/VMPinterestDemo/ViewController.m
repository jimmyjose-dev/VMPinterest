//
//  ViewController.m
//  VMPinterestDemo
//
//  Created by Jimmy on 04/01/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

/*
 
 If you have any suggestion, feature request or bug report, feel free to contact me at my fb page
 http://www.facebook.com/jimmyjose84
 
 or drop in a mail at vmpinterest@varshylmobile.com
 
 */

#import "ViewController.h"
#import "VMPinterestImageViewController.h"

@interface ViewController ()<VMPinterestDelegate>{
    
    IBOutlet UIButton *signOutButton;

}

@end

@implementation ViewController

/*
 -(void)viewWillAppear:(BOOL)animated{
 
 [super viewWillAppear:animated];
 [self.navigationController setNavigationBarHidden:YES];
 
 }
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //I am too lazy to implement the isUserSignedIn property... probably in the next framework rev ;)
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"SignedIn"]) {
        VMPinterest *pinterest = [VMPinterest instance];
        [pinterest signOut];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SignedIn"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"SignedIn"]) {
        [signOutButton setHidden:NO];
    }else{
        
        [signOutButton setHidden:YES];
    }
    
    
    
}


-(IBAction)localImageButtonPressed:(id)sender{
    
    VMPinterestImageViewController *localVC = [[VMPinterestImageViewController alloc] initWithNibName:[NSString stringWithFormat:@"LocalImageViewController%@",[DeviceType deviceType]] bundle:nil];
    
    [self.navigationController pushViewController:localVC animated:YES];
    
    
}

-(IBAction)multiLocalImageButtonPressed:(id)sender{
    
    VMPinterestImageViewController *multiLocalImageVC = [[VMPinterestImageViewController alloc] initWithNibName:[NSString stringWithFormat:@"MultipleLocalImageViewController%@",[DeviceType deviceType]] bundle:nil];
    
    [self.navigationController pushViewController:multiLocalImageVC animated:YES];
    
}

-(IBAction)remoteImageButtonPressed:(id)sender{
    
    VMPinterestImageViewController *remoteImageVC = [[VMPinterestImageViewController alloc] initWithNibName:[NSString stringWithFormat:@"RemoteImageViewController%@",[DeviceType deviceType]] bundle:nil];
    [self.navigationController pushViewController:remoteImageVC animated:YES];
    
    
}

-(IBAction)multiRemoteImageButtonPressed:(id)sender{
    
    VMPinterestImageViewController *multiRemoteImageVC = [[VMPinterestImageViewController alloc] initWithNibName:[NSString stringWithFormat:@"MultipleRemoteImageViewController%@",[DeviceType deviceType]] bundle:nil];
    [self.navigationController pushViewController:multiRemoteImageVC animated:YES];
    
}


-(IBAction)signOutButtonPressed:(id)sender{
    
    VMPinterest *pinterest = [VMPinterest instance];
    pinterest.delegate = self;
    [pinterest signOut];
    
}


-(void)PinterestSignOutSuccessfully{
    
    NSLog(@"PinterestSignOutSuccessfully");
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:@"PinterestSignOutSuccessfully" animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SignedIn"];
    [signOutButton setHidden:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
