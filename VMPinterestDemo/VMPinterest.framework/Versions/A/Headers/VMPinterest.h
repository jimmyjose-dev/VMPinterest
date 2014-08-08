//
//  VMPinterest.h
//  VMPinterest
//
//  Created by Jimmy Jose on 12/11/12.

/*
 
 If you have any suggestion, feature request or bug report, feel free to contact me at my fb page
 http://www.facebook.com/jimmyjose84
 
 or drop in a mail at vmpinterest@varshylmobile.com
 
 */



/*
 
 This is free and unencumbered software released into the public domain.
 
 Anyone is free to copy, modify, publish, use, compile, sell, or
 distribute this software, either in source code form or as a compiled
 binary, for any purpose, commercial or non-commercial, and by any
 means.
 
 In jurisdictions that recognize copyright laws, the author or authors
 of this software dedicate any and all copyright interest in the
 software to the public domain. We make this dedication for the benefit
 of the public at large and to the detriment of our heirs and
 successors. We intend this dedication to be an overt act of
 relinquishment in perpetuity of all present and future rights to this
 software under copyright law.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 For more information, please refer to <http://unlicense.org/>

 */


#import <Foundation/Foundation.h>

//Image upload delegates
@protocol VMPinterestImageUploadDelegate <NSObject>

-(void)imageUploadFailedWithError:(NSError *)error;

@optional
-(void)imageUploadStarted;
-(void)imageUploadFinishedAndSavedAtPath:(NSString *)serverPath;

@end


//VMPinterest delegates
@protocol VMPinterestDelegate <NSObject>

@optional
-(void)PinterestNeedsAuthentication;
-(void)PinterestAuthenticationFailedWithError:(NSString *)reason;
-(void)PinterestSignedInSuccessfullyWithUserName:(NSString *)userName;
-(void)PinterestUserName:(NSString *)userName;
-(void)PinterestNoBoardFound;
-(void)PinterestNewBoardCreatedWithName:(NSString *)boardName;
-(void)PinterestBoardExistsWithName:(NSString *)boardName;
-(void)PinToBoard:(NSArray *)boardNameArray;
-(void)PinterestSignOutSuccessfully;
-(void)PinnedSuccessfullyToBoard:(NSString *)boardName;
-(void)PinnedImageNumber:(int)imageNumber toBoard:(NSString *)boardName;
-(void)PinningFailedWithError:(NSString *)reason;

@end


//VMPinterest framework debug delegate
@protocol VMPinterestDebugDelegate <NSObject>

-(void)anErrorOccuredDueToReason:(NSString *)reason;

@optional
-(void)logThisForJimmy:(NSString *)log;
@end


@interface VMPinterest : UIView

@property(retain,nonatomic) id <VMPinterestDelegate> delegate;
@property(retain,nonatomic) id <VMPinterestImageUploadDelegate> imagedelegate;
@property(retain,nonatomic) id <VMPinterestDebugDelegate> debugdelegate;



/*
 
 Use this method if you have to pin an image from your resource bundle, gallery or camera roll.
 
 Sample usage:
 
 UIImage *image = image or UIImageView.image or [UIImage imageNamed:@"dummy.png"];
 
 NSString *fileName = nil; //  if you make this 'nil' it will upload with some random name
 
 NSString *pinDescription = @"My booga booga hooga chaa chaa pin";
 NSString *pinLink = @"varshylmobile.com/";
 
 NSString *serviceURLString = nil; // if you make this 'nil' it will upload the image to our server, we are not an image hosting company so dont abuse this service, we will be cleaning the stored images on regular basis. If you provide your own url you also need to have the server side code written for image upload.
 
 
 
 [[VMPinterest new] pinLocalImageToPinterestWithImage:image 
                                       ofTypeJPGorPNG:@"png"
                          andFilenameWithoutExtension:fileName
                                 withServiceURLString:nil
                                       pinDescription:pinDescription
                                              pinLink:pinLink];]
 
 
 */

-(void)pinLocalImageToPinterestWithImage:(UIImage *)image
                          ofTypeJPGorPNG:(NSString *)JPGorPNG
             andFilenameWithoutExtension:(NSString *)filename
                    withServiceURLString:(NSString *)serviceURLString
                          pinDescription:(NSString *)description
                                 pinLink:(NSString *)link;


-(void)pinLocalMultipleImagesToPinterestWithImageURLArray:(NSArray *)imageURLArray
                                      ofTypeJPGorPNGArray:(NSArray *)JPGorPNG
                         andFilenameWithoutExtensionArray:(NSArray *)filename
                                withServiceURLStringArray:(NSArray *)serviceURLString
                                      pinDescriptionArray:(NSArray *)descriptionArray
                                             pinLinkArray:(NSArray *)linkArray
                                  askForBoardNameEachTime:(BOOL)shouldAsk;

/*
 
 Use this method if you already have an image on remote server.
 
 Sample usage:
 
 NSString *imageURLStr = @"http://varshylmoble.com/images/pin.png";
 NSString *pinDescription = @"My booga booga hooga chaa chaa pin";
 NSString *pinLink = @"varshylmobile.com/";
 
 [[VMPinterest new]  pinRemoteImageToPinterestWithImageURL:imageURLStr 
                                            pinDescription:pinDescription 
                                                   pinLink:pinLink];
 
 */


-(void)pinRemoteImageToPinterestWithImageURL:(NSString *)imageURL
                              pinDescription:(NSString *)description
                                     pinLink:(NSString *)link;

-(void)pinRemoteMultipleImagesToPinterestWithImageURLArray:(NSArray *)imageURLArray
                                       pinDescriptionArray:(NSArray *)descriptionArray
                                              pinLinkArray:(NSArray *)linkArray
                                   askForBoardNameEachTime:(BOOL)shouldAsk;


// To sign in when the credentials are required, bydeault it will maintain a session for the same user till he signout
-(void)signInWithUsername:(NSString *)username andPassword:(NSString *)password;

// To create a new board
-(void)createNewBoardWithName:(NSString *)boardName;


// To get Username after login
-(void)getUsername;

// To create a new board and pin image on it
-(void)createAndPostImageOnBoardWithName:(NSString *)boardName;

// To pin on already existing board
-(void)pinToBoard:(NSString *)boardname;

// To signout a user
-(void)signOut;


// Singleton
+(VMPinterest *)instance;



@end
