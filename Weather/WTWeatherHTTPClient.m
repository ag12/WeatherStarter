//
//  WTWeatherHTTPClient.m
//  Weather
//
//  Created by Amir Ghoreshi on 15/11/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//

#import "WTWeatherHTTPClient.h"

static NSString * const WorldWeatherOnlineAPIKey = @"7a1d266719a345dc972a415905e6d";
static NSString * const WorldWeatherOnlineURLString = @"http://api.worldweatheronline.com/premium/v1/";

@implementation WTWeatherHTTPClient

//Not sure if it is a good idea to send the delegte here
// WTWeatherHTTPClient *cli = [WTWeatherHTTPClient sharedClient]
//cli.delegate = xxx...
//Its the same here ... 
+ (WTWeatherHTTPClient *)sharedHTTPClientWithDelegate:(id<WTWTWeatherHTTPClientDelegate>)delegate {

    static WTWeatherHTTPClient *_sharedClient = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:WorldWeatherOnlineURLString]];
    });
    _sharedClient.delegate = delegate;
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}


- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSInteger )number {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"num_of_days"] = @(number);
    params[@"q"] = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    params[@"format"] = @"json";
    params[@"key"] = WorldWeatherOnlineAPIKey;

    [self updateWeatherWithParameters:@"weather.ashx" params:params];

}

- (void)updateWeatherWithParameters:(NSString *)get params:(NSDictionary *)params {

    [self GET:get parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didUpdateWithWeather:)]) {
            [self.delegate weatherHTTPClient:self didUpdateWithWeather:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didFailWithError:)]) {
            [self.delegate weatherHTTPClient:self didFailWithError:error];
        }
    }];
}

@end
