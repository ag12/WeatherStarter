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
- (void)loadWeatherDataFromServer:(NSURLRequest *)request;

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

#pragma mark -  Delegate-protocol-pattern

//Some repeating code, just for convenience sake
//hold your horses! it looks sophisticated, but it's not!
//Should perhaps not do it like this in a real world project
- (void)loadWeatherDataFromServer:(NSURLRequest *)request type:(int)type {

    NSLog(@"Requesting server for data, wait for delegate...");
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    switch (type) {
        case 1: {
            //JOSN
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case 2: {
            //PLST
            operation.responseSerializer = [AFPropertyListResponseSerializer serializer];
            break;
        }
        case 3:{
            //XML
            operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        default:
            break;
    }
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NO ERROR

        switch (type) {
            case 1: {
                //JOSN
                [self.delegate didFinishedLoadinWeatherJSONFromServer:operation responseObject:responseObject error:nil];
                break;
            }
            case 2: {
                //PLST
                [self.delegate didFinishedLoadinWeatherPLISTFromServer:operation responseObject:responseObject error:nil];
                break;
            }
            case 3:{
                //XML
                [self.delegate didFinishedLoadinWeatherXMLFromServer:operation responseObject:responseObject error:nil];
                break;
            }
            default:
                break;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NO RESPONSEOBJECT
        switch (type) {
            case 1: {
                //JOSN
                [self.delegate didFinishedLoadinWeatherJSONFromServer:operation responseObject:nil error:error];
                break;
            }
            case 2: {
                //PLST
                [self.delegate didFinishedLoadinWeatherPLISTFromServer:operation responseObject:nil error:error];
                break;
            }
            case 3:{
                //XML
                [self.delegate didFinishedLoadinWeatherXMLFromServer:operation responseObject:nil error:error];
                break;
            }
            default:
                break;
        }
    }];

    [operation start];
}

- (void)loadWeatherJSONFromServer {
    NSLog(@"Requesting json data...");
    NSURL *JSONUrl = [NSURL URLWithString:[NSString stringWithFormat:BaseURLString, JSONFormat]];
    NSURLRequest *request = [NSURLRequest requestWithURL:JSONUrl];
    NSLog(@"URL: %@", JSONUrl.absoluteString);
    [self loadWeatherDataFromServer:request type:1];
}

- (void)loadWeatherPLISTFromServer {
    NSLog(@"Requesting plist data...");
    NSURL *PLISTUrl = [NSURL URLWithString:[NSString stringWithFormat:BaseURLString, PLISTFormat]];
    NSLog(@"URL: %@", PLISTUrl.absoluteString);
    NSURLRequest *request = [NSURLRequest requestWithURL:PLISTUrl];
    [self loadWeatherDataFromServer:request type:2];
}


- (void)loadWeatherXMLFromServer {
    NSLog(@"Requesting xml data...");
    NSURL *XMLUrl = [NSURL URLWithString:[NSString stringWithFormat:BaseURLString, XMLFormat]];
    NSLog(@"URL: %@", XMLUrl.absoluteString);
    NSURLRequest *request = [NSURLRequest requestWithURL:XMLUrl];
    [self loadWeatherDataFromServer:request type:3];
}





















@end
