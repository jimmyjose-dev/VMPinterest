//
//  ListOfBoardViewController.m
//  VMPinterestDemo
//
//  Created by Jimmy on 22/02/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

#import "ListOfBoardViewController.h"
#import "Reachability.h"

@interface ListOfBoardViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,VMPinterestDelegate>
{

    int selectedRow;
    UIView *newBoardView;
    
    IBOutlet UIView *newBoardViewiPhone;
    IBOutlet UIView *newBoardViewiPad;
    NSDictionary *newBoardNameDict;
    IBOutlet UITextField *boardNameText;
    
    IBOutlet UITableView *tableView;
    
    NSString *createBoardWithName;

}

@end

@implementation ListOfBoardViewController
@synthesize boardListArray,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedRow = -1;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    boardNameText.delegate = self;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [boardListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == selectedRow) {
        
        UIImageView *checkMarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_check%@.png",[DeviceType deviceType]]]];
        [cell setAccessoryView:checkMarkImageView];
    }else{
    
        cell.accessoryView = nil;
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:28];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell detailTextLabel] setText:[boardListArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == selectedRow) {
        selectedRow =-1;
    }else{
        selectedRow = [indexPath row];
    }
    
    [tableview reloadData];
}

-(IBAction)cancelButtonPressed:(id)sender{

    if ([delegate respondsToSelector:@selector(boardSelectionError:)]) {
        [delegate boardSelectionError:@"User canceled selection"];
    }
    
    [self dismissModalViewControllerAnimated:YES];

}

-(IBAction)doneButtonPressed:(id)sender{

    if (selectedRow != -1) {
     
    if(![self isConnectedToNetwork]){
        
        [self noInternetMsg];
        return;
    }
    
    if ([delegate respondsToSelector:@selector(boardSelectedWithName:)]) {
        [delegate boardSelectedWithName:[boardListArray objectAtIndex:selectedRow]];
    
        }
        [self dismissModalViewControllerAnimated:YES];
    
    }
    else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select a board to Pin" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
    }

}

-(IBAction)createBoardButtonPressed:(id)sender{
    
    if(![self isConnectedToNetwork]){
        [self noInternetMsg];
        return;
    }
    
    newBoardNameDict = [NSDictionary dictionaryWithObjects:boardListArray forKeys:boardListArray];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    
        newBoardView = newBoardViewiPhone;
    
    }
    else{
    
        newBoardView = newBoardViewiPad;
    
    }
    
    CGPoint newPoint = self.view.center;
    newPoint.y -=100;
    
    [newBoardView setCenter:newPoint];
    [self.view addSubview:newBoardView];
    [boardNameText becomeFirstResponder];
    


}


-(IBAction)newBoardOKButtonPressed:(id)sender{
    
    [boardNameText resignFirstResponder];
    
    if(![self isConnectedToNetwork]){
        [self noInternetMsg];
        return;
    }
    
    createBoardWithName = boardNameText.text;
    
    createBoardWithName = [createBoardWithName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (createBoardWithName.length) {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = [NSString stringWithFormat:@"Creating board with name %@",createBoardWithName];
    
    VMPinterest *pinterest = [VMPinterest instance];
    pinterest.delegate = self;
    [pinterest createNewBoardWithName:createBoardWithName];
        
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a boardname" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
    
    }
    
}

-(void)PinToBoard:(NSArray *)boardNameArray{

    NSLog(@"%s %@",__func__,boardNameArray);
    NSMutableArray *boardNameMutArray = [NSMutableArray arrayWithArray:boardNameArray];
    NSUInteger newBoardIdx = [boardNameMutArray indexOfObject:createBoardWithName];

    if (newBoardIdx != NSNotFound) {
        
        [boardNameMutArray exchangeObjectAtIndex:newBoardIdx withObjectAtIndex:0];
        selectedRow = 0;
        
    }
    else{
        
        selectedRow = -1;
        
    }
    
    boardListArray = boardNameMutArray;
    
    [tableView reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [newBoardView removeFromSuperview];

}

-(void)PinterestBoardExistsWithName:(NSString *)boardName{

    [MBProgressHUD hideHUDForView:self.view afterDelay:1 withMessage:[NSString stringWithFormat:@"Board exists with name %@",boardName] animated:YES];

}

-(IBAction)newBoardCancelButtonPressed:(id)sender{

    [newBoardView removeFromSuperview];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    [textField resignFirstResponder];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;

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
