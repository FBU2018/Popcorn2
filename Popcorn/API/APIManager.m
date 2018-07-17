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


@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (void)createList:(NSString *)name completion:(void (^)(NSError *))completion{
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
                completion(error);
            }
            else{
                NSLog(@"Request successful");
            }
        }];
        [task resume];
    }
}



- (void)getShelves:(NSMutableArray *)shelvesArray{
//    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/4/list/{list_id}?page=1&api_key=<<api_key>>"]
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //this part runs when network call is finished
//        if (error != nil) {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//        else {
//            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            self.movies = dataDictionary[@"results"];
//            self.filteredData = self.movies;
//
//            //refreshes, will call numberOfRowsInSection again
//            [self.tableView reloadData];
//            // Stop the activity indicator
//            // Hides automatically since "Hides When Stopped" is enabled
//            [self.activityIndicator stopAnimating];
//
//        }
//        [self.refreshControl endRefreshing];
//    }];
//    [task resume];
}


@end
