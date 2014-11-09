//
//  WTJSONClient.m
//  Weather
//
//  Created by Amir Ghoreshi on 09/11/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//

#import "WTJSONClient.h"

@implementation WTJSONClient

+ (instancetype)sharedClient {
    static id _sharedClint = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _sharedClint = [[self alloc] init];
    });
    return _sharedClint;
}

- (void)loadJSONFromServer {
    
}


@end
