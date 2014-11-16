//
//  WTUIAlertViewManager.m
//  Weather
//
//  Created by Amir Ghoreshi on 16/11/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//

#import "WTUIAlertViewManager.h"

@implementation WTUIAlertViewManager

+ (void)showErrorAlertView:(NSError *)error {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


@end
