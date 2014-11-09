//
//  WTClient.h
//  Weather
//
//  Created by Amir Ghoreshi on 09/11/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//

@protocol WTClientDelegate <NSObject>

- (void)didFinishedLoadinWeatherJSONFromServer:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject error:(NSError *)error;
- (void)didFinishedLoadinWeatherXMLFromServer:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject error:(NSError *)error;
- (void)didFinishedLoadinWeatherPLISTFromServer:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject error:(NSError *)error;

@end

@interface WTClient : NSObject

+ (instancetype)sharedClient;

- (id)initWithDelegate:(id<WTClientDelegate>)delegate;

- (void)loadJSONFromServerWithSuccess:(void(^)(AFHTTPRequestOperation *, id))success failure:(void(^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)loadWeatherJSONFromServer;
- (void)loadWeatherPLISTFromServer;
- (void)loadWeatherXMLFromServer;

@property (nonatomic, weak) id<WTClientDelegate> delegate;

@end
