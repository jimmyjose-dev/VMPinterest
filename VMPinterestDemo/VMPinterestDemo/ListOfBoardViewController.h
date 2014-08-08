//
//  ListOfBoardViewController.h
//  VMPinterestDemo
//
//  Created by Jimmy on 22/02/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BoardSelectionDelegate <NSObject>

-(void)boardSelectedWithName:(NSString *)boardName;
-(void)boardSelectionError:(NSString *)error;
@end

@interface ListOfBoardViewController : UIViewController
@property(nonatomic,retain)NSArray *boardListArray;
@property(retain,nonatomic) id <BoardSelectionDelegate> delegate;
@end