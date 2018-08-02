//
//  APIManagerMovieGlu.m
//  Popcorn
//
//  Created by Rucha Patki on 8/1/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "APIManagerMovieGlu.h"

//MovieGlu
static NSString * const username = @"POPC";
static NSString * const apiKey = @"l37WKjilkJ7JYQkidJDUD6dqHShWVrQi5av5GIPb";
static NSString * const password = @"KObXuRfqZVyn";
static NSString * const basicAuth = @"Basic UE9QQzpLT2JYdVJmcVpWeW4=";
static NSString * const targetURL = @"https://api-gate.movieglu.com/";

//GraceNote

static NSString * const apiKeyGrace = @"n6bj2rbdfwrwvzww59zzkdqk";




@implementation APIManagerMovieGlu

+ (instancetype)shared {
    static APIManagerMovieGlu *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


//MovieGlu
- (void)getFilmsNowShowing:(void (^)(NSDictionary *, NSError *))completion{
    //get request to get all currently showing movies
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [targetURL stringByAppendingString:@"filmsNowShowing/?n=10"];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    //headers
    [request addValue:username forHTTPHeaderField: @"client"];
    [request addValue:apiKey forHTTPHeaderField: @"x-api-key"];
    [request addValue:basicAuth forHTTPHeaderField: @"Authorization"];
    [request addValue:@"v102" forHTTPHeaderField: @"api-version"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
        else{
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Request successful");
            NSLog(@"dataDictionary: %@", dataDictionary);
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}


- (void)getCinemasNearby:(NSString *)latLong completion:(void (^)(NSDictionary *, NSError *))completion{
    //get request to get all currently showing movies
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [targetURL stringByAppendingString:@"cinemasNearby/?n=5"];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    //headers
    [request addValue:username forHTTPHeaderField: @"client"];
    [request addValue:apiKey forHTTPHeaderField: @"x-api-key"];
    [request addValue:basicAuth forHTTPHeaderField: @"Authorization"];
    [request addValue:@"v102" forHTTPHeaderField: @"api-version"];
    [request addValue:latLong forHTTPHeaderField:@"geolocation"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
        else{
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Request successful");
            NSLog(@"dataDictionary: %@", dataDictionary);
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

//GraceNote

- (void)getTheaterswithLat:(NSString *)lat withLong:(NSString *)lng completion:(void (^)(NSDictionary *, NSError *))completion{
    //get request to get all currently showing movies
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //http://data.tmsapi.com/v1.1/theatres?zip=78701&api_key=1234567890
    NSString *urlString = [[[[[@"http://data.tmsapi.com/v1.1/theatres?lat=" stringByAppendingString:lat] stringByAppendingString:@"&lng="] stringByAppendingString:lng] stringByAppendingString:@"&api_key="] stringByAppendingString:apiKeyGrace];
//    NSString *urlString = [@"http://data.tmsapi.com/v1.1/theatres?zip=78701&api_key=" stringByAppendingString:apiKeyGrace];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
        else{
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Request successful");
            NSLog(@"dataDictionary: %@", dataDictionary);
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

@end
