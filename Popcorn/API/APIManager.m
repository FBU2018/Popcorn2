//
//  APIManager.m
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "APIManager.h"

static NSString * const apiKey = @"15703e94357b9dc777959d930e92e7dc";
static NSString * requestToken3 = @"";
static NSString * sessionID = @"";
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


- (void)createList:(NSString *)name withSessionId: (NSString *) mySessionId completion:(void (^)(NSString *, NSError *))completion{
    //post request to create list VERSION 3

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *stringURL = [[[@"https://api.themoviedb.org/3/list?api_key=" stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:mySessionId];
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


- (void)deleteList:(NSString *)listId withSessionId: (NSString*) mySessionId completion:(void (^)(NSError *error))completion{
    //delete request to delete list with given id VERSION 3
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/list/" stringByAppendingString:listId] stringByAppendingString:@"?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:mySessionId];
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

-(void)getShelvesWithSessionId: (NSString *)sessionId andAccountId: (NSString *) accountId andCompletionBlock: (void (^)(NSArray *results, NSError *error))completion{
    // get request to get all of a particular user's created lists/shelves using their sessionId
    
    NSString *urlString = [[[[[[@"https://api.themoviedb.org/3/account/" stringByAppendingString:accountId] stringByAppendingString:@"/lists?api_key="] stringByAppendingString:apiKey] stringByAppendingString: @"&language=en-US&session_id="] stringByAppendingString:sessionId] stringByAppendingString:@"&page=1"];
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
            //TODO: sort these shelves before completion!!
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Successfully got shelves");
            NSArray *resultsArray = dataDictionary[@"results"];
            
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
            NSArray *sortedArray = [resultsArray sortedArrayUsingDescriptors:sortDescriptors];
            
            completion(sortedArray, nil);
        }
    }];
    [task resume];
}


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
            
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"release_date" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
            NSArray *sortedArray = [dataDictionary[@"items"] sortedArrayUsingDescriptors:sortDescriptors];

            completion(sortedArray, nil);
        }
    }];
    [task resume];
}


- (void)removeItem:(NSString *)shelfId forItem:(Movie *)item withSessionId: (NSString*) mySessionId completion:(void (^)(NSError *error))completion{
    //post request to delete item from list VERSION 3
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/list/" stringByAppendingString:shelfId] stringByAppendingString:@"/remove_item?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:mySessionId];
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

- (void)addItem:(NSString *)shelfId forItem:(Movie *)item withSessionId: (NSString*) mySessionId completion:(void (^)(NSError *))completion{
    //post request to add item to list VERSION 3
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/list/" stringByAppendingString:shelfId] stringByAppendingString:@"/add_item?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="] stringByAppendingString:mySessionId];
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

-(void) addRating:(NSString *)movieId withRating:(NSString *)rating withSessionId: (NSString*) mySessionId completion:(void (^)(NSError *))completion{
    //post request to add item to list
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieId] stringByAppendingString:@"/rating?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="]stringByAppendingString:mySessionId];
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

- (void) getRating:(NSString *)movieID withSessionId: (NSString*) mySessionId completion:(void (^)(NSObject *, NSError *))completion{
    NSString *urlString = [[[[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieID] stringByAppendingString:@"/account_states?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&session_id="]stringByAppendingString:mySessionId];
    
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


- (void)getActorDetails:(NSString *)actorID completion:(void (^)(NSDictionary *, NSError *))completion{
    NSString *urlString = [[[[@"https://api.themoviedb.org/3/person/" stringByAppendingString:actorID]stringByAppendingString:@"?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&language=en-US"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else{
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

- (void)getCredits:(NSString *)actorID completion:(void (^)(NSArray *, NSError *))completion{
    NSString *urlString = [[[[@"https://api.themoviedb.org/3/person/" stringByAppendingString:actorID]stringByAppendingString:@"/movie_credits?api_key="]stringByAppendingString:apiKey]stringByAppendingString:@"&language=en-US"];
    
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
            NSArray *fullCreditsList = dataDictionary[@"cast"];
            completion(fullCreditsList, nil);
        }
    }];
    [task resume];
}

- (void)getSimilar:(NSString *)movieID completion:(void (^)(NSArray *, NSError *))completion{
    NSString *urlString = [[[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieID]stringByAppendingString:@"/similar?api_key="]stringByAppendingString:apiKey]stringByAppendingString:@"&language=en-US"];
    
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
            NSArray *similarMovies = dataDictionary[@"results"];
            completion(similarMovies, nil);
        }
    }];
    [task resume];
}

- (void)getMovieDetails:(NSString *)movieId completion:(void (^)(NSDictionary *, NSError *))completion{
    NSString *urlString = [[[[@"https://api.themoviedb.org/3/movie/" stringByAppendingString:movieId] stringByAppendingString:@"?api_key="] stringByAppendingString:apiKey] stringByAppendingString:@"&language=en-US"];
    
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
            completion(dataDictionary, nil);
        }
    }];
    [task resume];
}

@end
