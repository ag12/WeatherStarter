//
//  WTWeatherHTTPClient.h
//  Weather
//
//  Created by Amir Ghoreshi on 15/11/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol WTWTWeatherHTTPClientDelegate;

@interface WTWeatherHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<WTWTWeatherHTTPClientDelegate> delegate;

+ (WTWeatherHTTPClient *)sharedHTTPClientWithDelegate:(id<WTWTWeatherHTTPClientDelegate>)delegate;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSInteger )number;


@end

@protocol WTWTWeatherHTTPClientDelegate <NSObject>

@optional
- (void)weatherHTTPClient:(WTWeatherHTTPClient *)client didUpdateWithWeather:(id)weather;
- (void)weatherHTTPClient:(WTWeatherHTTPClient *)client didFailWithError:(NSError *)error;

@end