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

//Google Places
static NSString * const apiKeyGoogle = @"AIzaSyDaawUPba6kyVzy-FAZQ4hAP_E39HIkhCM";




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

- (void)getTheaterswithLat:(NSString *)lat withLong:(NSString *)lng completion:(void (^)(NSMutableDictionary *, NSError *))completion{
    //get request to get all currently showing movies
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //TODO: update date each time
    NSString *urlString = [[[[[[[@"http://data.tmsapi.com/v1.1/movies/showings?startDate=" stringByAppendingString:@"2018-08-02"] stringByAppendingString:@"&lat="] stringByAppendingString:lat] stringByAppendingString:@"&lng="] stringByAppendingString:lng] stringByAppendingString:@"&api_key="] stringByAppendingString:apiKeyGrace];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
        else{
            NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Request successful");
            
            //Dictionary: {theater1: {movie1, movie2}, theater2: {movie1, movie2},...}
            NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
            for(NSDictionary *movie in dataArray){ //for each movie
                NSArray *showtimes = movie[@"showtimes"];
                for(NSDictionary *showtime in showtimes){
                    NSString *nameOfTheatre = showtime[@"theatre"][@"name"];
                    if([output objectForKey:nameOfTheatre] == NO){ //no value for theatre name key
                        [output setObject:[NSMutableArray new] forKey:nameOfTheatre];
                    }
                    NSArray *moviesInTheatres = output[nameOfTheatre];
                    if(moviesInTheatres.count == 0){
                        [output[nameOfTheatre] addObject:movie[@"title"]]; //add movie name to theatre key
                    }
                    else{
                        bool flag = false;
                        for(NSString *movieInTheatre in moviesInTheatres){ //check and make sure movie isn't already a key in the theatre
                            if([movieInTheatre isEqualToString:movie[@"title"]] == YES){
                                flag = true;
                            }
                        }
                        if(flag == false){
                            [output[nameOfTheatre] addObject:movie[@"title"]]; //add movie name to theatre key
                        }
                    }
                }
            }

            completion(output, nil);
        }
    }];
    [task resume];
}


//googlePlaces

- (void)findPlaceFromText:(NSString *)placeName completion:(void (^)(NSDictionary *dataDictionary, NSError *error))completion{
    //get request to get all currently showing movies
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSMutableString *placeNameURL = [@"" mutableCopy];
    for(NSInteger charIndex = 0; charIndex < placeName.length; charIndex++){
        if([placeName characterAtIndex:charIndex] == ' '){
            [placeNameURL appendString:@"%20"];
        }
        else{
            NSString *charAsString = [NSString stringWithFormat:@"%c", [placeName characterAtIndex:charIndex]];
            [placeNameURL appendString:charAsString];
        }
    }
    
    NSString *urlString = [[[@"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=" stringByAppendingString:placeNameURL] stringByAppendingString:@"&inputtype=textquery&fields=formatted_address,geometry,name,rating,photos,opening_hours&key="] stringByAppendingString:apiKeyGoogle];
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
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

- (void)getPhotoFromReference:(NSString *)photoReference completion:(void (^)(NSData *imageData, NSError *error))completion{
    //get request to get photo of theater from reference
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSString *urlString = [[[@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" stringByAppendingString:photoReference] stringByAppendingString:@"&key="] stringByAppendingString:apiKeyGoogle];
    NSLog(@"REQUEST URL STRING: %@", urlString);
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        }
        else{
            NSLog(@"Request successful");
            NSData *imageData = data;
            completion(imageData, nil);
        }
    }];
    [task resume];
}

@end
