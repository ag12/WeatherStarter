//
//  WTClient.m
//  Weather
//
//  Created by Amir Ghoreshi on 09/11/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//

#import "WTClient.h"

static NSString * const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/%@";
static NSString * const JSONFormat = @"weather.php?format=json";
static NSString * const XMLFormat = @"weather.php?format=xml";
static NSString * const PLISTFormat = @"weather.php?format=plist";

@interface WTClient()

-(void)requestServerWithCompletionBlock:(NSURLRequest *)request success:(void(^)(AFHTTPRequestOperation *, id))success failure:(void(^)(AFHTTPRequestOperation *, NSError *))failure;

@end

@implementation WTClient


#pragma mark - Singleton & init

+ (instancetype)sharedClient {
    static id _sharedClint = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _sharedClint = [[self alloc] init];
    });
    return _sharedClint;
}

-(id)initWithDelegate:(id<WTClientDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - For asynchronous request

//Could use this one for as one common request - method and to keep it DRY!
-(void)requestServerWithCompletionBlock:(NSURLRequest *)request success:(void(^)(AFHTTPRequestOperation *, id))success failure:(void(^)(AFHTTPRequestOperation *, NSError *))failure {

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        success(operation, responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        failure(operation, error);

    }];
    
    [operation start];

}



#pragma mark - For asynchronous json

//without using delegate
- (void)loadJSONFromServerWithSuccess:(void(^)(AFHTTPRequestOperation *, id))success failure:(void(^)(AFHTTPRequestOperation *, NSError *))failure {

    NSLog(@"loadJSONFromServerWithSuccess");

    NSURL *JSONUrl = [NSURL URLWithString:[NSString stringWithFormat:BaseURLString, JSONFormat]];
    NSURLRequest *request = [NSURLRequest requestWithURL:JSONUrl];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        success(operation, responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        failure(operation, error);
        
    }];

    [operation start];
}

#pragma mark - For delegate-protocol-pattern json


//Some repeating code, just for convenience sake
- (void)loadWeatherJSONFromServer {

    NSLog(@"loadJSONFromServerWithSuccess");

    NSURL *JSONUrl = [NSURL URLWithString:[NSString stringWithFormat:BaseURLString, JSONFormat]];
    NSURLRequest *request = [NSURLRequest requestWithURL:JSONUrl];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NO ERROR
        [self.delegate didFinishedLoadinWeatherJSONFromServer:operation responseObject:responseObject error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NO RESPONSEOBJECT
        [self.delegate didFinishedLoadinWeatherJSONFromServer:operation responseObject:nil error:error];
    }];
    
    [operation start];
}


























@end
