//
//  APIManager.m
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "APIManager.h"

static NSString * const apiKey = @"15703e94357b9dc777959d930e92e7dc";
static NSString * const requestToken = @"585512c8018c084ce18c5419769f5e161c870fe0";
static NSString * const sessionID = @"241562b4ac28f52aa9c89e810b4046d6df4dc985";
static NSString * const accessToken = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE1MzE3NzI4NTUsInN1YiI6IjViNGNmYTVlYzNhMzY4MjNlNjA0YWJjNyIsImp0aSI6Ijg5NTk3MSIsImF1ZCI6IjE1NzAzZTk0MzU3YjlkYzc3Nzk1OWQ5MzBlOTJlN2RjIiwic2NvcGVzIjpbImFwaV9yZWFkIiwiYXBpX3dyaXRlIl0sInZlcnNpb24iOjF9.abd9n5YDL2ToVRuaNw3CQhUAs95H2Gqhxwlf3sZusZw";
static NSString * const accountID = @"7966256";


@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (void)createList:(NSString *)name completion:(void (^)(NSString *, NSError *))completion{
    //post request to create list
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.themoviedb.org/4/list"]];
    [request setHTTPMethod:@"POST"];
    
    //headers
    NSString *bearer = @"Bearer ";
    NSString *accessing = [bearer stringByAppendingString:accessToken];
    
    [request addValue:accessing forHTTPHeaderField: @"Authorization"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    //request body + variables
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name",@"en",@"iso_639_1", nil];
    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {
            NSError* error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
        [request setHTTPBody:jsonData];

        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Error: %@", error.localizedDescription);
                completion(nil,error);
            }
            else{
                NSString *myData = [[NSString alloc] initWithData:data
                                      encoding:NSUTF8StringEncoding];
                
                
                NSData *data = [myData dataUsingEncoding:NSUTF8StringEncoding];
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"Request successful");
                completion(jsonResponse[@"id"], nil);
            }
        }];
        [task resume];
    }
}



- (void)getShelves:(void (^)(NSDictionary *shelves, NSError *error))completion{
    //get request to get all of user's created list
    
    NSString *urlString = [[[[[[@"https://api.themoviedb.org/3/account/" stringByAppendingString:accountID] stringByAppendingString:@"/lists?api_key="] stringByAppendingString:apiKey] stringByAppendingString: @"&language=en-US&session_id="] stringByAppendingString:sessionID] stringByAppendingString:@"&page=1"];
    NSURL *url = [NSURL URLWithString:urlString];
    
     NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
     NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //this part runs when network call is finished
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Successfully got shelves");
            completion(dataDictionary, nil);
        }
    }];
     [task resume];
}

@end
