//
//  APIManager.m
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "APIManager.h"

//static NSString * const apiKey = @"15703e94357b9dc777959d930e92e7dc";
//static NSString * const readAccessToken4 = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNTcwM2U5NDM1N2I5ZGM3Nzc5NTlkOTMwZTkyZTdkYyIsInN1YiI6IjViNGNmYTVlYzNhMzY4MjNlNjA0YWJjNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4BwAxs_-AWbqm-ckcyg8IH5bwrfNCjN8iHAV84xiLJc";
//static NSString * requestToken3 = @"585512c8018c084ce18c5419769f5e161c870fe0";
//static NSString * requestToken4 = @"";
//static NSString * sessionID = @"241562b4ac28f52aa9c89e810b4046d6df4dc985";
//static NSString * accessToken = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE1MzE3NzI4NTUsInN1YiI6IjViNGNmYTVlYzNhMzY4MjNlNjA0YWJjNyIsImp0aSI6Ijg5NTk3MSIsImF1ZCI6IjE1NzAzZTk0MzU3YjlkYzc3Nzk1OWQ5MzBlOTJlN2RjIiwic2NvcGVzIjpbImFwaV9yZWFkIiwiYXBpX3dyaXRlIl0sInZlcnNpb24iOjF9.abd9n5YDL2ToVRuaNw3CQhUAs95H2Gqhxwlf3sZusZw";
//static NSString * accountID = @"7966256";

static NSString * const apiKey = @"15703e94357b9dc777959d930e92e7dc";
static NSString * const readAccessToken4 = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNTcwM2U5NDM1N2I5ZGM3Nzc5NTlkOTMwZTkyZTdkYyIsInN1YiI6IjViNGNmYTVlYzNhMzY4MjNlNjA0YWJjNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4BwAxs_-AWbqm-ckcyg8IH5bwrfNCjN8iHAV84xiLJc";
static NSString * requestToken3 = @"";
static NSString * requestToken4 = @"";
static NSString * sessionID = @"";
static NSString * accessToken = @"";
static NSString * accountID = @"";


@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


//- (void)createList:(NSString *)name completion:(void (^)(NSString *, NSError *))completion{
//    //post request to create list VERSION 4
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"https://api.themoviedb.org/4/list"]];
//    [request setHTTPMethod:@"POST"];
//
//    //headers
//    NSString *bearer = @"Bearer ";
//    NSString *accessing = [bearer stringByAppendingString:accessToken];
//
//    [request addValue:accessing forHTTPHeaderField: @"Authorization"];
//    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//
//    //request body + variables
//    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name",@"en",@"iso_639_1", nil];
//    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {
//            NSError* error;
//            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
//        [request setHTTPBody:jsonData];
//
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//
//        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if(error != nil){
//                NSLog(@"Error: %@", error.localizedDescription);
//                completion(nil,error);
//            }
//            else{
//                NSString *myData = [[NSString alloc] initWithData:data
//                                      encoding:NSUTF8StringEncoding];
//
//
//                NSData *data = [myData dataUsingEncoding:NSUTF8StringEncoding];
//                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//                NSLog(@"Request successful");
//                completion(jsonResponse[@"id"], nil);
//            }
//        }];
//        [task resume];
//    }
//}

- (void)createList:(NSString *)name completion:(void (^)(NSString *, NSError *))completion{
    //post request to create list VERSION 3

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *stringURL = [[[@"https://api.themoviedb.org/3/list?api_key=" stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:sessionID];
    [request setURL:[NSURL URLWithString:stringURL]];
    [request setHTTPMethod:@"POST"];

    //headers
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];

    //request body + variables
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name",@"",@"description", @"en", @"language", nil];
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
                completion(jsonResponse[@"list_id"], nil);
            }
        }];
        [task resume];
    }
}

//- (void)deleteList:(NSString *)listId completion:(void (^)(NSError *error))completion{
//    //delete request to delete list with given id
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSString *urlString = [@"https://api.themoviedb.org/4/list/" stringByAppendingString:listId];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"DELETE"];
//
//    //headers
//    NSString *bearer = @"Bearer ";
//    NSString *accessing = [bearer stringByAppendingString:accessToken];
//
//    [request addValue:accessing forHTTPHeaderField: @"Authorization"];
//    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error != nil) {
//            NSLog(@"Error: %@", [error localizedDescription]);
//            completion(error);
//        }
//        else {
//            NSLog(@"Successfully deleted shelf");
//            completion(nil);
//        }
//    }];
//    [task resume];
//}

- (void)deleteList:(NSString *)listId completion:(void (^)(NSError *error))completion{
    //delete request to delete list with given id VERSION 3
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/list/" stringByAppendingString:listId] stringByAppendingString:@"?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:sessionID];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
            completion(error);
        }
        else {
            NSLog(@"Successfully deleted shelf");
            completion(nil);
        }
    }];
    [task resume];
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


//- (void)getShelfMovies:(NSString *)listId completion:(void (^)(NSArray *, NSError *))completion{
//    //get request to get array of all movies in a list
//
//    NSString *urlString = [[[@"https://api.themoviedb.org/4/list/" stringByAppendingString:listId] stringByAppendingString: @"?page=1&api_key="] stringByAppendingString: apiKey];
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //this part runs when network call is finished
//        if (error != nil) {
//            NSLog(@"Error: %@", [error localizedDescription]);
//            completion(nil, error);
//        }
//        else {
//            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"Successfully got movies in shelf");
//
//            completion(dataDictionary[@"results"], nil);
//        }
//    }];
//    [task resume];
//}

- (void)getShelfMovies:(NSString *)listId completion:(void (^)(NSArray *, NSError *))completion{
    //get request to get array of all movies in a list VERSION 3

    NSString *urlString = [[[[@"https://api.themoviedb.org/3/list/" stringByAppendingString:listId] stringByAppendingString:@"?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&language=en-US"];
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
            NSLog(@"Successfully got movies in shelf");

            completion(dataDictionary[@"items"], nil);
        }
    }];
    [task resume];
}

//- (void)removeItem:(NSString *)shelfId forItem:(Movie *)item completion:(void (^)(NSError *error))completion{
//    //delete request to delete item from list VERSION 4
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSString *urlString = [[@"https://api.themoviedb.org/4/list/" stringByAppendingString:shelfId] stringByAppendingString:@"/items"];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"DELETE"];
//
//    //headers
//    NSString *bearer = @"Bearer ";
//    NSString *accessing = [bearer stringByAppendingString:accessToken];
//
//    [request addValue:accessing forHTTPHeaderField: @"Authorization"];
//    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//
//    //request body + variables
//    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys: item.mediaType,@"media_type",item.movieID, @"media_id", nil];
//    NSArray *itemArr = [[NSArray alloc] initWithObjects:itemDict, nil];
//    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:itemArr, @"items", nil];
//
//    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {
//        NSError* error;
//        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
//        [request setHTTPBody:jsonData];
//
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//
//        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if(error != nil){
//                NSLog(@"Error: %@", error.localizedDescription);
//                completion(error);
//            }
//            else{
//                NSLog(@"Request successful");
//                completion(nil);
//            }
//        }];
//        [task resume];
//    }
//}

- (void)removeItem:(NSString *)shelfId forItem:(Movie *)item completion:(void (^)(NSError *error))completion{
    //post request to delete item from list VERSION 3
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/list/" stringByAppendingString:shelfId] stringByAppendingString:@"/remove_item?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:sessionID];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //headers
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    //request body + variables
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:item.movieID, @"media_id", nil];
    
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
                completion(nil);
            }
        }];
        [task resume];
    }
}

- (void)getTrailerURL:(NSString *)movieId completion:(void (^)(NSURL *, NSError *))completion{
    NSString *baseURLString = @"https://www.youtube.com/watch?v=";
    NSString *identity = movieId;
    
    NSString *myUrl = [[[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:identity] stringByAppendingString:@"/videos?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&language=en-US"];
    
    NSURL *url = [NSURL URLWithString: myUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *myResult = dataDictionary[@"results"];
            NSDictionary *movieInfo = myResult[0];
            NSString *key = movieInfo[@"key"];
            NSString *urlString = [baseURLString stringByAppendingString:key];
            NSURL *url = [NSURL URLWithString:urlString];
            
            completion(url, nil);
        }
    }];
    [task resume];
}

//- (void)getItemStatus:(NSString *)listId forMovie:(NSString *)movieId ofType: (NSString *) itemType completion:(void (^)(NSString *, NSError *))completion{
//    //get request to see if item is in the list
//
//    NSString *urlString = [[[[[@"https://api.themoviedb.org/4/list/" stringByAppendingString:listId] stringByAppendingString:@"/item_status?media_id="] stringByAppendingString:movieId] stringByAppendingString:@"&media_type="] stringByAppendingString:itemType];
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//
//    //headers
//    NSString *bearer = @"Bearer ";
//    NSString *accessing = [bearer stringByAppendingString:accessToken];
//
//    [request addValue:accessing forHTTPHeaderField: @"Authorization"];
//    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //this part runs when network call is finished
//        if (error != nil) {
//            NSLog(@"Error: %@", [error localizedDescription]);
//        }
//        else{
//            NSLog(@"Successfully checked if movie was in list");
//            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            completion([dataDictionary[@"status_code"] stringValue], nil);
//        }
//    }];
//    [task resume];
//}


- (void)getItemStatus:(NSString *)listId forMovie:(NSString *)movieId ofType: (NSString *) itemType completion:(void (^)(bool, NSError *))completion{
    //get request to see if item is in the list
    
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/list/" stringByAppendingString:listId] stringByAppendingString:@"/item_status?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&movie_id="] stringByAppendingString:movieId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //this part runs when network call is finished
        if (error != nil) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else{
            NSLog(@"Successfully checked if movie was in list");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      
            id someItem = dataDictionary[@"item_present"];
            if([someItem boolValue] == NO){
                completion(NO, nil);
            }
            else{
                completion(YES, nil);
            }
            
//            completion(dataDictionary[@"item_present"], nil);
//            NSLog(@"listId: %@", listId);
//            NSLog(@"apiKey: %@", apiKey);
//            NSLog(@"movieId: %@", movieId);
//            NSLog(@"DATA DICTIONARY: %@", dataDictionary);
        }
    }];
    [task resume];
}


- (void)getCast:(NSString *)movieId completion:(void (^)(NSArray *, NSError *))completion{
    NSString *urlString = [[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieId]stringByAppendingString:@"/credits?api_key="]stringByAppendingString:apiKey];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *fullCastList = dataDictionary[@"cast"];
            completion(fullCastList, nil);
        }
    }];
    [task resume];
}

//- (void)addItem:(NSString *)shelfId forItem:(Movie *)item completion:(void (^)(NSError *))completion{
//    //post request to add item to list VERSION 4
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSString *urlString = [[@"https://api.themoviedb.org/4/list/" stringByAppendingString:shelfId] stringByAppendingString:@"/items"];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//
//    //headers
//    NSString *bearer = @"Bearer ";
//    NSString *accessing = [bearer stringByAppendingString:accessToken];
//
//    [request addValue:accessing forHTTPHeaderField: @"Authorization"];
//    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
//
//    //request body + variables
//    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys: item.mediaType,@"media_type",item.movieID, @"media_id", nil];
//    NSArray *itemArr = [[NSArray alloc] initWithObjects:itemDict, nil];
//    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:itemArr, @"items", nil];
//
//    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {
//        NSError* error;
//        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
//        [request setHTTPBody:jsonData];
//
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//
//        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if(error != nil){
//                NSLog(@"Error: %@", error.localizedDescription);
//                completion(error);
//            }
//            else{
//                NSLog(@"Request successful");
//                completion(nil);
//            }
//        }];
//        [task resume];
//    }
//}

- (void)addItem:(NSString *)shelfId forItem:(Movie *)item completion:(void (^)(NSError *))completion{
    //post request to add item to list VERSION 3
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/list/" stringByAppendingString:shelfId] stringByAppendingString:@"/add_item?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:sessionID];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //headers
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    //request body + variables
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:item.movieID, @"media_id", nil];
    
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
                completion(nil);
            }
        }];
        [task resume];
    }
}

// Send a network call to search movies with a given string and page number, with completion blocks to make use of the returned data and handle any errors
-(void)searchMoviesWithString:(NSString *)searchString andPageNumber:(NSString *)pageNumber andResultsCompletionHandler:(void (^)(NSArray *))resultsHandler andErrorCompletionHandler:(void (^)(NSError *))errorHandler{
    // place search string in URL
    NSString *baseUrl = @"https://api.themoviedb.org/3/search/movie?api_key=69308a1aa1f4a3c54b17a53c591eadb0&language=en-US&query=";
    NSString *searchUrl = [baseUrl stringByAppendingString:searchString];
    NSString *fullUrl = [[[searchUrl stringByAppendingString:@"&page="] stringByAppendingString:pageNumber] stringByAppendingString:@"&include_adult=false"];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // this runs when network call is finished
        if (error != nil) {
            //calls completion handler that creates an alert when there is an error
            errorHandler(error);
        }
        else{
            NSLog(@"Network call returned results");
            // store the received data in a dictionary
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            // store the results section of the JSON data in the movies array
            NSArray *dictionaries = dataDictionary[@"results"];
            NSMutableArray *finalResults = [NSMutableArray new];
            for (NSDictionary *dictionary in dictionaries){
                [finalResults addObject:dictionary];
            }
            resultsHandler(finalResults);
        }
    }];
    [task resume];
}

-(void) addRating:(NSString *)movieId withRating:(NSString *)rating completion:(void (^)(NSError *))completion{
    //post request to add item to list
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieId] stringByAppendingString:@"/rating?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="]stringByAppendingString:sessionID];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //headers
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    
    //request body + variables
    NSNumber *ratingNumber = [NSNumber numberWithDouble:[rating doubleValue]];
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:ratingNumber, @"value", nil];
    
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
                completion(nil);
            }
        }];
        [task resume];
    }
}

- (void) getRating:(NSString *)movieID completion:(void (^)(NSObject *, NSError *))completion{
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieID] stringByAppendingString:@"/account_states?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="]stringByAppendingString:sessionID];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSObject *rating = dataDictionary[@"rated"];
            completion(rating, nil);
        }
    }];
    [task resume];
}

- (void) getReviews:(NSString *)movieID completion:(void (^)(NSArray *, NSError *))completion{
    NSString *urlString = [[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieID]stringByAppendingString:@"/reviews?api_key="]stringByAppendingString:apiKey];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSLog(@"successfully fetched reviews");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *reviews = dataDictionary[@"results"];
            completion(reviews, nil);
        }
    }];
    [task resume];
}

- (void)getRequestToken3:(void (^)(NSString *, NSError *))completion{
    NSString *urlString = [@"https://api.themoviedb.org/3/authentication/token/new?api_key=" stringByAppendingString:apiKey];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSLog(@"successfully got request token");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *returnedRequestToken = dataDictionary[@"request_token"];
            requestToken3 = returnedRequestToken;
            NSLog(@"Request token: %@", returnedRequestToken);
            completion(returnedRequestToken, nil);
            
            //forward user to https://www.themoviedb.org/authenticate/{REQUEST_TOKEN}
        }
    }];
    [task resume];
}


//HERE
- (void)postRequestToken4:(void (^)(NSString *, NSError *))completion{
    //post request to get request token V4
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = @"https://api.themoviedb.org/4/auth/request_token";
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //headers
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    NSString *bearerVal = [@"Bearer " stringByAppendingString:readAccessToken4];
    [request addValue:bearerVal forHTTPHeaderField: @"Authorization"];
    
    //request body + variables
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"https://www.themoviedb.org/", @"redirect_to", nil];
    
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
                NSLog(@"Request successful");
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *returnedRequestToken = dataDictionary[@"request_token"];
                requestToken4 = returnedRequestToken;
                completion(requestToken4, nil);
            }
        }];
        [task resume];
    }
}



- (void)getSession:(void (^)(NSString *, NSError *))completion{
    NSString *urlString = [[[@"https://api.themoviedb.org/3/authentication/session/new?api_key=" stringByAppendingString:apiKey] stringByAppendingString:@"&request_token="] stringByAppendingString:requestToken3];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSLog(@"successfully got session ID");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *returnedSessionId = dataDictionary[@"session_id"];
            sessionID = returnedSessionId;
            completion(returnedSessionId, nil);
        }
    }];
    [task resume];
}

- (void)getAccountDetails:(void (^)(NSString *, NSError *))completion{
    NSString *urlString = [[[@"https://api.themoviedb.org/3/account?api_key=" stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:sessionID];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSLog(@"successfully got session ID");
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber *returnedAccountId = dataDictionary[@"id"];
            accountID = [returnedAccountId stringValue];
            completion(accountID, nil);
        }
    }];
    [task resume];
}



- (void)createAccessToken4:(void (^)(NSString *, NSString *, NSError *))completion{
    //post request to create access token
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = @"https://api.themoviedb.org/4/auth/access_token";
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //headers
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    NSString *bearerVal = [@"Bearer " stringByAppendingString:readAccessToken4];
    [request addValue:bearerVal forHTTPHeaderField: @"Authorization"];
    
    
    //request body
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:requestToken4, @"request_token", nil];
    
    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
        [request setHTTPBody:jsonData];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Error: %@", error.localizedDescription);
                completion(nil,nil,error);
            }
            else{
                NSLog(@"Request successful");
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"Data dictionary: %@", dataDictionary);
                NSString *returnedAccessToken = dataDictionary[@"access_token"];
                NSString *returnedAccountId = dataDictionary[@"account_id"];
                accessToken = returnedAccessToken;
                accountID = returnedAccountId;
                NSLog(@"ACCESS TOKEN: %@", accessToken);
                completion(accessToken, accountID, nil);
            }
        }];
        [task resume];
    }
}

@end
