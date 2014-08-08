//
//  DeviceType.m
//  VMPinterestDemo
//
//  Created by Jimmy on 08/02/13.
//  Copyright (c) 2013 VarshylMobile. All rights reserved.
//

/*
 
 If you have any suggestion, feature request or bug report, feel free to contact me at my fb page
 http://www.facebook.com/jimmyjose84
 
 or drop in a mail at vmpinterest@varshylmobile.com
 
 */

#import "DeviceType.h"

@implementation DeviceType

+(NSString *)deviceType{
    
    NSString *deviceType = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat scale = 1;
        if ([ [UIScreen mainScreen] respondsToSelector: @selector(scale)] == YES) {
            scale = [ [UIScreen mainScreen] scale];
        }
        
        if ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ( (height * scale) >= 1136) ){
            
            deviceType = @"_iPhone5";
        }
        else{
            
            deviceType = @"_iPhone";
            
        }
    }else{
    
        deviceType = @"_iPad";
        
    }
    
    return deviceType;
}

+(BOOL)isiPhone{

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) return YES;
    return NO;
    
}

@end
