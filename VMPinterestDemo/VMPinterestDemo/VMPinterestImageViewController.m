//
//  VMPinterestImageViewController.m
//  VMPinterestDemo
//
//  Created by Jimmy on 18/02/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

/*
 
 If you have any suggestion, feature request or bug report, feel free to contact me at my fb page
 http://www.facebook.com/jimmyjose84
 
 or drop in a mail at vmpinterest@varshylmobile.com
 
 */

#import "VMPinterestImageViewController.h"
#import "ListOfBoardViewController.h"
#import "Reachability.h"

@interface VMPinterestImageViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,VMPinterestDelegate,VMPinterestImageUploadDelegate,VMPinterestDebugDelegate,LoginStatusDelegate,UITextFieldDelegate,UIPopoverControllerDelegate,BoardSelectionDelegate>{
    
    IBOutlet UIImageView *imageViewSingle;
   
       
    IBOutlet UITextField *txtField;
    
    IBOutlet UITextField *txtField1;
    IBOutlet UITextField *txtField2;
    IBOutlet UITextField *txtField3;

    
    IBOutlet UITextView *txtView;
    
    IBOutlet UIView *deleteSuperView;
    
    VMPinterest *pinterest;
    
    LoginViewController *loginVC;

    
    NSMutableArray *imageViewArray;
    //NSMutableArray *imagesArray;
    NSMutableDictionary *imagesDict;
    NSArray *txtFieldArray;

    UIActivityIndicatorView *activity;
    UIPopoverController *popoverController;
        
    // type = 1 -> Local Single
    // type = 2 -> Local Multiple
    // type = 3 -> Remote Single
    // type = 4 -> Remote Multiple
    int type;
    
    int imageCounter;
    
}

@end

@implementation VMPinterestImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    nibNameOrNil = [[nibNameOrNil componentsSeparatedByString:@"_"] objectAtIndex:0];
    
    if ([nibNameOrNil isEqualToString:@"LocalImageViewController"]) {
        type = 1;
    }
    else  if ([nibNameOrNil isEqualToString:@"MultipleLocalImageViewController"]) {
        type = 2;
    }else  if ([nibNameOrNil isEqualToString:@"RemoteImageViewController"]) {
        type = 3;
    }else{
        
        type = 4;
        

        
    }
    imageCounter = 0;
    

    
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (txtField) {
        txtField.delegate = self;
        [txtField.text length]? [[self.view viewWithTag:txtField.tag*4] setHidden:NO] :[[self.view viewWithTag:txtField.tag*4] setHidden:YES];
    }
    
    if (txtField1) {
        txtField1.delegate = self;
        [txtField.text length]? [[self.view viewWithTag:txtField1.tag*4] setHidden:NO] :[[self.view viewWithTag:txtField1.tag*4] setHidden:YES];
    }
    if (txtField2) {
        txtField2.delegate = self;
        if (txtField2.text.length) {
            [[self.view viewWithTag:txtField2.tag*4] setHidden:NO];
        }else{
        
            [[self.view viewWithTag:txtField2.tag*4] setHidden:YES];
        }
        if (!txtField1.text.length) {
            [txtField2 setPlaceholder:@"Disabled as previous field is empty"];
            [txtField2 setEnabled:NO];
        }
    }
    if (txtField3) {
        txtField3.delegate = self;
        if (txtField3.text.length) {
            [[self.view viewWithTag:txtField3.tag*4] setHidden:NO];
        }else{
            
            [[self.view viewWithTag:txtField3.tag*4] setHidden:YES];
        }
        if (!txtField2.text.length) {
            [txtField3 setPlaceholder:@"Disabled as previous field is empty"];
            [txtField3 setEnabled:NO];
        }
    }
    
}


- (void)viewDidLoad
{
 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[[PerformSelector new] selectorName:@"go" withParameter:nil forView:self.view];
    //reachability = [[Reachability alloc] init];
    //if ([reachability isInternetAvailable]) {
    //  [self noInternet];
    //}
    
//    ListOfBoardViewController *listOfBoardVC = [[ListOfBoardViewController alloc] initWithNibName:[NSString stringWithFormat:@"ListOfBoardViewController%@",[DeviceType deviceType]] bundle:nil];
//    
//    listOfBoardVC.delegate = self;
//    
//    listOfBoardVC.boardListArray = [NSArray arrayWithObjects:@"adsadsa",@"asdasd222",@"asdasdadewerweew", nil];
//    
//    [self presentModalViewController:listOfBoardVC animated:YES];
    
    pinterest = [VMPinterest instance];
    pinterest.delegate = self;
    pinterest.imagedelegate = self;
    pinterest.debugdelegate = self;
    
    
    [txtView setDelegate:self];
    

    imageViewArray = [NSMutableArray new];
    imagesDict = [NSMutableDictionary new];
    txtFieldArray = [NSArray arrayWithObjects:txtField1,txtField2,txtField3, nil];
    
    
}

-(IBAction)cancelButtonPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [txtField resignFirstResponder];
    [txtField1 resignFirstResponder];
    [txtField2 resignFirstResponder];
    [txtField3 resignFirstResponder];
    
    [txtView resignFirstResponder];
    
    [self stopShakeAnimation];
    [self moveFrameDown];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"Image description here ...."]) {
        textView.text = @"";
        [textView setTextColor:[UIColor blackColor]];
    }
    
    [self moveFrameUp];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"Image description here ...."]) {
        
        [textView setTextColor:[UIColor lightTextColor]];
    }
    
    [self moveFrameDown];
    
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
    
    [txtView resignFirstResponder];
    
    [UIView commitAnimations];
    
}


-(IBAction)cameraButtonPressed:(id)sender{
    
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Camera not available on this device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([[imagesDict allKeys] count]==3) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Max 3 Images allowed for this app, the framework allows unlimited images upload" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    [self presentModalViewController:picker animated:YES];
    
}

-(IBAction)cameraRollButtonPressed:(id)sender{
    
    if ([[imagesDict allKeys] count]==3) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Max 3 Images allowed for this app, the framework allows unlimited images upload" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentModalViewController:picker animated:YES];
        
    }else {
        
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        popoverController=[[UIPopoverController alloc] initWithContentViewController:picker];
        popoverController.delegate=self;
        [popoverController presentPopoverFromRect:((UIButton *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{

    return YES;

}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{

    

}

-(IBAction)resourceButtonPressed:(id)sender{
    
    if (type == 1) {
        
        imageViewSingle.image = [UIImage imageNamed:@"114x114.png"];
        //  [[imageView layer] addAnimation:[self getShakeAnimation] forKey:@"transform"];
    }
    
    
    if (type ==2) {

        [self loadAllImageViewWithImage];


    }
    
    
}

-(void)loadAllImageViewWithImage{

    for(UIView *view in [deleteSuperView subviews]){
        if([view isKindOfClass:[UIView class]]){
            
            [view removeFromSuperview];
            
        }
    }
    
    [imagesDict removeAllObjects];
    

    imageCounter = 0;
    
    for (int i=0; i<3; ++i) {
        
        ++imageCounter;
        
        UIImage *newImage = [UIImage imageNamed:@"114x114.png"];
        [imagesDict setObject:newImage forKey:[NSNumber numberWithInt:imageCounter]];
        
        [self updateGUIWithImage:newImage startFromIndex:[[imagesDict allKeys] count]-1];
    }

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissModalViewControllerAnimated:YES];
    int size = 0;
    if ([[DeviceType deviceType] isEqualToString:@"_iPad"]) {
        
        size = 125;
        
        [popoverController dismissPopoverAnimated:YES];
        
    }else{
        
        size = 75;
    }
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CGSize newSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (type == 1) {
        imageViewSingle.image = newImage;
        
    }else if (type == 2){
    
        ++imageCounter;
        
        [imagesDict setObject:newImage forKey:[NSNumber numberWithInt:imageCounter]];
        
        [self updateGUIWithImage:newImage startFromIndex:[[imagesDict allKeys] count]-1];

    }
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)uploadButtonPressed:(id)sender{
   
    NSString *pinDescription = [txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!pinDescription.length || [pinDescription isEqualToString:@"Image description here ...."]) {
        pinDescription = @"powered by VarshylMobile";
    }

    NSString *pinLink = @"varshylmobile.com/";
    NSString *pinImageUploadToServer = [NSString stringWithFormat:@"%s",SERVER_URL];

    
    if (type == 1) {
        
    
    UIImage *image = imageViewSingle.image;
        
        if (!image) {
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"No image to upload." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            return;
        }
        
        if(![self isConnectedToNetwork]){
        
            [self noInternetMsg];
            return;
        }
        
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Pinning local image";
    
    //At the moment withServiceURLString:nil is disabled,
    //Upload the file ImageUploadVMPinterest.php on your server and also make a folder named 'images'
    //So your url would be somethig like this - http://www.yourdomain.com/ImageUploadVMPinterest.php
    //Then instead of nil pass the parameter
    // withServiceURLString:@"http://www.yourdomain.com/ImageUploadVMPinterest.php"
    
    [pinterest pinLocalImageToPinterestWithImage:image
                                  ofTypeJPGorPNG:@"png"
                     andFilenameWithoutExtension:[NSString stringWithFormat:@"%u",arc4random()]
                            withServiceURLString:pinImageUploadToServer
                                  pinDescription:pinDescription pinLink:pinLink];
    }
    else if (type == 2){
        
        if (![[imagesDict allValues] count]) {
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"No image to upload." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            return;
        }
        
        if(![self isConnectedToNetwork]){
            
            [self noInternetMsg];
            return;
        }
        
        NSArray *nameArray = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
        NSArray *imageTypeArray = [NSArray arrayWithObjects:@"png",@"png",@"png",nil];
        NSArray *descriptionArray = [NSArray arrayWithObjects:pinDescription,pinDescription,pinDescription,nil];
        NSArray *linkArray = [NSArray arrayWithObjects:pinLink,pinLink,pinLink,nil];
        NSArray *imageUploadArray = [NSArray arrayWithObjects:pinImageUploadToServer,pinImageUploadToServer,pinImageUploadToServer, nil];
        
    
        [pinterest pinLocalMultipleImagesToPinterestWithImageURLArray:[imagesDict allValues] ofTypeJPGorPNGArray:imageTypeArray andFilenameWithoutExtensionArray:nameArray withServiceURLStringArray:imageUploadArray pinDescriptionArray:descriptionArray pinLinkArray:linkArray askForBoardNameEachTime:NO];
    
    }else if (type == 3){
    
        [self setOrUploadImageForLink:txtField.text shouldUpload:1 setImageForTag:666];
        
    }else{
    
      
        
        NSString *pinDescription = [txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!pinDescription.length || [pinDescription isEqualToString:@"Image description here ...."]) {
            pinDescription = @"powered by VarshylMobile";
        }
        NSString *pinLink = @"varshylmobile.com/";
        
        NSMutableArray *imageArray = [NSMutableArray new];
        NSMutableArray *descriptionArray = [NSMutableArray new];
        NSMutableArray *linkArray = [NSMutableArray new];
        
        for (UITextField *link in txtFieldArray) {
            if (link.text.length) {
                NSLog(@"link text %@",link.text);
            [imageArray addObject:link.text];
            [descriptionArray addObject:pinDescription];
                [linkArray addObject:pinLink];
            }
        }
        
                
        if (![imageArray count]) {
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"No image to upload." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            return;
        }
        
        if(![self isConnectedToNetwork]){
            
            [self noInternetMsg];
            return;
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([imageArray count]>1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = [NSString stringWithFormat: @"Pinning %d images",[imageArray count]];
        }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = [NSString stringWithFormat: @"Pinning %d image",[imageArray count]];
        }
        
        [pinterest pinRemoteMultipleImagesToPinterestWithImageURLArray:imageArray
                                                   pinDescriptionArray:descriptionArray
                                                          pinLinkArray:linkArray
                                               askForBoardNameEachTime:NO];
    
    }
    
    
    
}


//Delegate method, gets called when you want to pin a local image
-(void)imageUploadStarted{
    
    NSLog(@"imageUploadStarted");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Uploading image to server";
    
    
}

//Delegate method, gets called when a local image is upload successfully to the server
-(void)imageUploadFinishedAndSavedAtPath:(NSString *)serverPath{
    
    NSLog(@"imageUploadFinishedAndSavedAtPath %@",serverPath);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Image Uploaded Successfully";
    
}

//Delegate method, gets called when there is an error during the upload process of local image
-(void)imageUploadFailedWithError:(NSError *)error{
    
    NSLog(@"%@",[error localizedDescription]);
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:[error localizedDescription] animated:YES];
    
}

//Delegate method, gets called when Pinterest ask's for Authentication
-(void)PinterestNeedsAuthentication{
    NSLog(@"%s",__func__);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    //Handle pinterest login
    loginVC = [[LoginViewController alloc] initWithNibName:[NSString stringWithFormat:@"LoginViewController%@",[DeviceType deviceType]] bundle:nil];
    loginVC.delegate = self;
    [self presentViewController:loginVC animated:YES completion:NULL];
    
}


//Delegate method, gets called when there is an error during the login process
-(void)loginFailedWithError:(NSString *)reason{
    
    NSLog(@"Authentication Failed : %@",reason);
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:reason animated:YES];
    [loginVC dismissModalViewControllerAnimated:YES];
    
}

//Delegate method, gets called when the user logs into Pinterest successfully
-(void)loginDidCompleteWithSuccess:(NSString *)userName{
    
    NSLog(@"PinterestSignedInSuccessfullyWithUserName %@",userName);
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:[NSString stringWithFormat:@"%@ signed successfully",userName] animated:YES];
    
}

-(void)loginReturnedBoardList:(NSArray *)boardNameArray{

    [loginVC dismissViewControllerAnimated:YES completion:^{[self PinToBoard:boardNameArray];}];
    
}

-(void)loginPinnedSuccessfullyToBoard:(NSString *)boardName{
    
    [self PinnedSuccessfullyToBoard:boardName];
    
}


//Delegate method, gets called to return any other error the framework encounters
-(void)anErrorOccuredDueToReason:(NSString *)reason
{
    //While testing the framework Pinterest used to go down temporiariy, probably due to continous uploading of images.
    NSLog(@"%@",reason);
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:reason animated:YES];
    
    
}

//Delegate method, gets called when there is some error which is not handled by the framwork
-(void)logThisForJimmy:(NSString *)log{
    
    NSLog(@"Jimmy: %@",log);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

//Delegate method, gets called when no board is found for that user
-(void)PinterestNoBoardFound{
    
    NSLog(@"No Board found");
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:@"No Board found" animated:YES];
    
    //[pinterest createAndPostImageOnBoardWithName:@"inyourspace"];
    
}

//Delegate method, gets called when Image is pinned to board successfully
-(void)PinnedSuccessfullyToBoard:(NSString *)boardName{
    
    NSLog(@"pinning completed successfully to board %@",boardName);
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:[NSString stringWithFormat:@"Image pinned to board %@",boardName] animated:YES];
}

//Delegate method, gets called if there is an error in pinning the image

-(void)PinningFailedWithError:(NSString *)reason{
    
    NSLog(@"failed due to %@",reason);
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:reason animated:YES];
}


//Delegate method, gets called when new board is created successfully
-(void)PinterestNewBoardCreatedWithName:(NSString *)boardName{
    
    NSLog(@"New Board name %@",boardName);
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:[NSString stringWithFormat:@"New board created with name %@",boardName] animated:YES];
}


//Delegate method, sends the list of boards availble for pinning
-(void)PinToBoard:(NSArray *)boardNameArray{
    
    NSLog(@"PinToBoard delegate called boards %@",boardNameArray);
    
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:@"Getting board name(s)" animated:YES];
    
    ListOfBoardViewController *listOfBoardVC = [[ListOfBoardViewController alloc] initWithNibName:[NSString stringWithFormat:@"ListOfBoardViewController%@",[DeviceType deviceType]] bundle:nil];
    
    listOfBoardVC.delegate = self;
    
    boardNameArray = [boardNameArray sortedArrayUsingSelector:@selector(compare:)];
    listOfBoardVC.boardListArray = [NSArray arrayWithArray:boardNameArray];
    
    [self presentModalViewController:listOfBoardVC animated:YES];
    
}


-(void)boardSelectedWithName:(NSString *)boardName{

    NSString *message = [NSString stringWithFormat:@"You selected: %@",boardName];
    NSLog(@"%@",message);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = message;
    
    pinterest = [VMPinterest instance];
    pinterest.delegate = self;
  
    [pinterest pinToBoard:boardName];

    
}

-(void)boardSelectionError:(NSString *)error{


}


//Delegate method, gets called when a user tries to create a board with a pre-existing name
-(void)PinterestBoardExistsWithName:(NSString *)boardName{
    
    NSLog(@"PinterestBoardExistsWithName %@",boardName);
    [MBProgressHUD hideHUDForView:self.view afterDelay:2 withMessage:[NSString stringWithFormat:@"Board exists with name %@",boardName] animated:YES];
    
}


-(void)NameEnteredForNewBoard:(NSString *)boardName{
    
    [pinterest createNewBoardWithName:boardName];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = [NSString stringWithFormat:@"Creating board with name %@",boardName];
    
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField setTextColor:[UIColor blackColor]];
    [[self.view viewWithTag:textField.tag*4] setHidden:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    //NSString *str = textField.text.lowercaseString;
    
//    if ([self isValidTypeImageForExtension:[self getFileTypeFromURLStr:str]]) {
//        [self setStatusForTextField:textField];
//    }
   
        [self setStatusForTextField:textField];
   
    
    return YES;

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *http = @"http://";
    NSString *https = @"https://";
    NSString *str = textField.text.lowercaseString;
    
    
    if (str.length) {
        
        if (([str rangeOfString:http].location == NSNotFound && [str rangeOfString:https].location == NSNotFound) || ![self isValidTypeImageForExtension:[self getFileTypeFromURLStr:str]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Not a valid image url !!!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
            
            //[textField becomeFirstResponder];
            [textField setTextColor:[UIColor redColor]];
        }
        else{
            
            [textField resignFirstResponder];
            [[self.view viewWithTag:textField.tag*4] setHidden:NO];
           
            
        }
        
    }/*else{
    
        UIButton *button = (UIButton *)textField;
        button.tag *= 4;
        button.tag +=1;
        [self removeImage:button];
    
    }
    */
    [self setStatusForTextField:textField];
        
    /*
    
    if (!txtField1.text.length) {
        [txtField2 setPlaceholder:placeHolderDisabled];
        [txtField2 setEnabled:NO];
    }else{
    
        [txtField2 setPlaceholder:placeHolder];
        [txtField2 setEnabled:YES];
    }


    if (!txtField2.text.length) {
        [txtField3 setPlaceholder:placeHolderDisabled];
        [txtField3 setEnabled:NO];
    }else{
    
        [txtField3 setPlaceholder:placeHolder];
        [txtField3 setEnabled:YES];
    }
    */
    
    if (textField.tag >=10 && !textField.text.length) {
        NSLog(@"length %d",textField.text.length);
        UIButton *button = (UIButton *)[self.view viewWithTag:textField.tag*4];
        [self removeImage:button];
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self setStatusForTextField:textField];
    
    if (textField == txtField1) {
        [txtField2 becomeFirstResponder];
    }else if (textField == txtField2){
    
        [txtField3 becomeFirstResponder];
    }
    else{
    
        [textField resignFirstResponder];
    }
    return YES;
    
}

-(void)setStatusForTextField:(UITextField *)textField{

    NSString *placeHolderEnabled = @"Enter image url here ....";
    NSString *placeHolderDisabled = @"Disabled as previous field is empty";
    
    NSString *placeHolder = placeHolderDisabled;
    
    BOOL enabledStatus = NO;
    
    if (textField.text.length) {
        enabledStatus = YES;
        placeHolder = placeHolderEnabled;
    }
    
    if (textField == txtField1) {
        [txtField2 setPlaceholder:placeHolder];
        [txtField2 setEnabled:enabledStatus];
    }else if (textField == txtField2){
        
        [txtField3 setPlaceholder:placeHolder];
        [txtField3 setEnabled:enabledStatus];
    }

    

}


-(NSString *)getFileTypeFromURLStr:(NSString *)urlString{
    
    NSArray *tempArray = [urlString componentsSeparatedByString:@"."];
    
    return [tempArray lastObject];
    
}

-(BOOL)isValidTypeImageForExtension:(NSString *)extension{
    
    NSArray *validTypes = [NSArray arrayWithObjects:@"jpg",@"jpeg",@"png", nil];
    BOOL isValid = NO;
    
    for (NSString *validTypeExt in validTypes) {
        if ([[extension lowercaseString] isEqualToString:validTypeExt]) {
            isValid = YES;
            break;
        }
    }
    
    return isValid;
    
}


-(IBAction)previewButtonPressed:(UIButton *)sender{
    
    if (type == 3) {
        
        [self setOrUploadImageForLink:txtField.text shouldUpload:0 setImageForTag:sender.tag+1];
    
    }
    else {
        
        NSString *link = [(UITextField *)[txtFieldArray objectAtIndex:sender.tag/40-1] text];
        link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"link %@",link);
        [self setOrUploadImageForLink:link shouldUpload:0 setImageForTag:sender.tag+1];
    }
    
}


-(void)setOrUploadImageForLink:(NSString *)link shouldUpload:(int)shouldUpload setImageForTag:(int)viewWithTag{
    
    if ((type == 3 || type == 4 ) && shouldUpload) {
        
    
    
    if (![link length]) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"No image to upload." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        return;
    }
    }
    
    if(![self isConnectedToNetwork]){
        
        [self noInternetMsg];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:link];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"HEAD"];
    
    NSLog(@"Image preview");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if ((type == 3 || type == 4 ) && shouldUpload) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Fetching image for preview";
    }
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error){
                               
    if (error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
        NSLog(@"an error occurred %@",[error localizedDescription]);
        
    }
    else{
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        int responseStatusCode = [httpResponse statusCode];
                                   
        if (responseStatusCode == 200) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
                                       
            if(![self isConnectedToNetwork]){
                [self noInternetMsg];
                return;
            }
                                       
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *error){
                                                                  
            if (error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
                NSLog(@"an error occurred %@",[error localizedDescription]);
            }
            else {
                if (!shouldUpload) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if (type == 3) {
                        [imageViewSingle setImage:[UIImage imageWithData:data]];
                    }
                    else{
                        NSLog(@"viewtag %d newtag %d update tag %d",viewWithTag,viewWithTag/40,viewWithTag/40-1);
                    [imagesDict setObject:[UIImage imageWithData:data] forKey:[NSNumber numberWithInt:viewWithTag/40]];
                        [self updateGUIWithImage:[UIImage imageWithData:data] startFromIndex:viewWithTag/40-1];
                    }
                }
                else {
                    if(![self isConnectedToNetwork]){
                        [self noInternetMsg];
                        return;
                    }
                    
                    //image upload here
                    NSString *pinDescription = [txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (!pinDescription.length || [pinDescription isEqualToString:@"Image description here ...."]) {
                        pinDescription = @"powered by VarshylMobile";
                    }
                    [pinterest pinRemoteImageToPinterestWithImageURL:link pinDescription:pinDescription pinLink:@"varshylmobile.com/"];
                }
            }
                                   }
             ];}
        else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:nil message:@"Image doesn't exist !!!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            NSLog(@"image doesn't exist");
        }
    }
                           }
     ];
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


-(void)updateGUIWithImage:(UIImage *)image startFromIndex:(int)index{
    
    for (int idx = index; idx < [[imagesDict allKeys] count]; ++idx) {
        
        CGRect frame = CGRectZero;
    
        int iPhoneImageSize = 75;
        int iPadImageSize = 125;
        
        int centerY = 0;
    
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            centerY = (deleteSuperView.frame.size.height - iPhoneImageSize)/2;
            frame = CGRectMake(20+(88*idx), centerY, iPhoneImageSize, iPhoneImageSize);
        }
        else{
            centerY = (deleteSuperView.frame.size.height - iPadImageSize)/2;
            frame = CGRectMake(20+(210*idx), centerY, iPadImageSize, iPadImageSize);
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setUserInteractionEnabled:YES];
        [imageView setImage:image];
        [imageViewArray addObject:imageView];
        
        [imageView setTag:imageCounter];
        
        UILongPressGestureRecognizer *lpg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [imageView addGestureRecognizer:lpg];
        [deleteSuperView addSubview:imageView];
        
    }
    
}

-(void)rearrangeImageViewFromIndex:(int)index{
    
    for (UIView *vw in [deleteSuperView subviews]) {
        if (vw.tag > index) {
            CGRect frame = [vw frame];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                frame.origin.x -=88;
            }
            else{
                frame.origin.x -=210;
            }
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            //[UIView setAnimationDelay:1.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [vw setFrame:frame];
            [UIView commitAnimations];
        }
    }
}





-(void)longPress:(UILongPressGestureRecognizer *)pgr
{
  
    if(pgr.state == UIGestureRecognizerStateBegan ) {
        
        UIImageView *imageView = (UIImageView *) pgr.view;
        imageView.frame = pgr.view.frame;
    
        imageView = (UIImageView *)[self getDeleteViewWithSubview:imageView];
        
        [imageView.layer addAnimation:[self getShakeAnimation] forKey:@"wobbledelete"];
    }
    
    
}

-(UIView *)getDeleteViewWithSubview:(UIImageView *)imageView{

    CGRect frame = imageView.frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        frame.size = CGSizeMake(78, 78);
    }else{
    
        frame.size = CGSizeMake(128, 128);
    }
    frame.origin.x -=10;
    frame.origin.y -=10;
    
    
    UIView *vw = [[UIView alloc] initWithFrame:frame];
    frame = imageView.frame;
    frame.origin = CGPointMake(0, 0);
    
    imageView.layer.shouldRasterize = YES;
    
    
    imageView.frame = frame;
    
    UIImageView *deleteButtonImageView = [[UIImageView alloc] initWithFrame:frame];
    [deleteButtonImageView setImage:[UIImage imageNamed:@"wobbledelete_iPhone"]];
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [deleteBtn setFrame:CGRectMake(0,0, 30, 30)];
    
    
    [deleteBtn addTarget:self action:@selector(removeImage:)
        forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setShowsTouchWhenHighlighted:YES];
    [deleteBtn setUserInteractionEnabled:YES];

    
    deleteBtn.tag = [imageView tag];

    // vw.tag = [imageView tag];
    
    [vw addSubview:imageView];
    
    frame.origin = CGPointMake(10, 10);
    imageView.frame = frame;
    
    vw.tag = imageView.tag;
    
    [vw addSubview:deleteButtonImageView];
    [vw addSubview:deleteBtn];

    [deleteSuperView addSubview:vw];
    
    return vw;

}


-(void)removeImage:(UIButton*)sender
{
  
    for(UIView *view in [deleteSuperView subviews]){
        if([view isKindOfClass:[UIView class]]&&view.tag == [sender tag]){
            
          [view removeFromSuperview];
            
          [imagesDict removeObjectForKey:[NSNumber numberWithInt:sender.tag]];
           
        break;
            
        }
    }
    
    [self rearrangeImageViewFromIndex:sender.tag];

}


-(void)stopShakeAnimation{
  
    for(UIView *view in [deleteSuperView subviews]){
        if([view isKindOfClass:[UIView class]]){
            
            CGRect frame = view.frame;
            frame.origin.x += 10;
            frame.origin.y += 10;
            if ([[view subviews] count]) {
            
            UIImageView *imgView = (UIImageView *)([[view subviews] objectAtIndex:0]);
            [imgView setFrame:frame];
            [imgView setUserInteractionEnabled:YES];
            [deleteSuperView addSubview:imgView];
            [view removeFromSuperview];
                
            }
            
        }
    }
    
    
}



- (CAAnimation*)getShakeAnimation {
    
    CABasicAnimation *animation;
    CATransform3D transform;
    
    // Create the rotation matrix
    transform = CATransform3DMakeRotation(0.08, 0, 0, 1.0);
    
    // Create a basic animation to animate the layer's transform
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    // Assign the transform as the animation's value
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    
    animation.autoreverses = YES;
    animation.duration = 0.1;
    animation.repeatCount = HUGE_VALF;
    
    return animation;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

