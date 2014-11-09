//
//  WTJSONClient.h
//  Weather
//
//  Created by Amir Ghoreshi on 09/11/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTJSONClient : NSObject

+ (instancetype)sharedClient;

- (void)loadJSONFromServer;

@end
