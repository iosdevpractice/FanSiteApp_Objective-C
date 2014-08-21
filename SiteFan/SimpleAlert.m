//
//  SimpleAlert.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/21/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAlert.h"

@implementation SimpleAlert

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    NSLog(@"alert: title: %@ message: %@", title, message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}

@end
