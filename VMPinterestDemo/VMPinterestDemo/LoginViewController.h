//
//  LoginViewController.h
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

#import <UIKit/UIKit.h>

//Login Status delegate
@protocol LoginStatusDelegate <NSObject>

-(void)loginDidCompleteWithSuccess:(NSString *)forUsername;
-(void)loginFailedWithError:(NSString *)error;
-(void)loginReturnedBoardList:(NSArray *)boardNameArray;
-(void)loginPinnedSuccessfullyToBoard:(NSString *)boardName;

@end

@interface LoginViewController : UIViewController

@property(retain,nonatomic) id <LoginStatusDelegate> delegate;

@end
