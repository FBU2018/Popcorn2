//
//  APIManager.h
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

//API Manager for MovieDB
@interface APIManager : NSObject

+ (instancetype)shared;

- (void)createList: (NSString*) name withSessionId: (NSString*) mySessionId completion:(void (^)(NSString *, NSError *))completion;
- (void)deleteList: (NSString*) listId withSessionId: (NSString*) mySessionId completion:(void (^)(NSError *))completion;
- (void)removeItem: (NSString *) shelfId forItem:(Movie *)item withSessionId: (NSString*) mySessionId completion:(void (^) (NSError *)) completion;
- (void)addItem: (NSString *) shelfId forItem:(Movie *)item withSessionId: (NSString*) mySessionId completion:(void (^) (NSError *)) completion;
- (void)addRating: (NSString *) movieId withRating: (NSString *) rating withSessionId: (NSString*) mySessionId completion:(void (^) (NSError *)) completion;

- (void)getRequestToken3:(void(^)(NSString *requestToken, NSError *error))completion;
- (void)getSession:(void(^)(NSString *sessionId, NSError *error))completion;
- (void)getAccountDetails:(void(^)(NSString *userId, NSError *error))completion;
-(void)getShelvesWithSessionId: (NSString *)sessionId andAccountId: (NSString *) accountId andCompletionBlock: (void (^)(NSArray *results, NSError *error))completion;
- (void)getShelfMovies: (NSString *) listId completion:(void (^) (NSArray *, NSError *))completion;
- (void)getTrailerURL: (NSString *) movieId completion:(void (^) (NSURL *, NSError *)) completion;
- (void)getItemStatus: (NSString *) listId forMovie: (NSString *) movieId ofType: (NSString *) itemType completion:(void (^) (bool presentInList, NSError *error)) completion;

- (void)getCast:(NSString *)movieId completion:(void (^)(NSArray *, NSError *))completion;
-(void)searchMoviesWithString:(NSString *)searchString andPageNumber:(NSString *)pageNumber andResultsCompletionHandler:(void (^)(NSArray *))resultsHandler andErrorCompletionHandler:(void (^)(NSError *))errorHandler;

- (void)getRating:(NSString *)movieID withSessionId: (NSString*) mySessionId completion:(void (^)(NSObject *, NSError *)) completion;
- (void) getReviews:(NSString *)movieID completion:(void (^)(NSArray *, NSError *))completion;

- (void)getActorDetails:(NSString *)actorID completion:(void (^)(NSDictionary *, NSError *))completion;
- (void)getCredits:(NSString *)actorID completion:(void (^)(NSArray *, NSError *))completion;

- (void)getSimilar:(NSString *)movieID completion:(void (^)(NSArray *, NSError *))completion;
- (void)getMovieDetails:(NSString *)movieId completion:(void (^)(NSDictionary *, NSError *))completion;
@end
