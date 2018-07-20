//
//  APIManager.h
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface APIManager : NSObject

+ (instancetype)shared;

- (void)createList: (NSString*) name completion:(void (^)(NSString *, NSError *))completion;
- (void)deleteList: (NSString*) listId completion:(void (^)(NSError *))completion;
- (void)removeItem: (NSString *) shelfId forItem:(Movie *)item completion:(void (^) (NSError *)) completion;
- (void)addItem: (NSString *) shelfId forItem:(Movie *)item completion:(void (^) (NSError *)) completion;
- (void)addRating: (NSString *) movieId withRating: (NSString *) rating completion:(void (^) (NSError *)) completion;


- (void)getShelves:(void(^)(NSDictionary *shelves, NSError *error))completion;
- (void)getShelfMovies: (NSString *) listId completion:(void (^) (NSArray *, NSError *))completion;
- (void)getTrailerURL: (NSString *) movieId completion:(void (^) (NSURL *, NSError *)) completion;
- (void)getItemStatus: (NSString *) listId forMovie: (NSString *) movieId ofType: (NSString *) itemType completion:(void (^) (NSString *, NSError *)) completion;

- (void)getCast:(NSString *)movieId completion:(void (^)(NSArray *, NSError *))completion;
-(void)searchMoviesWithString:(NSString *)searchString andPageNumber:(NSString *)pageNumber andResultsCompletionHandler:(void (^)(NSArray *))resultsHandler andErrorCompletionHandler:(void (^)(NSError *))errorHandler;

-(void) getRating:(NSString *)movieID completion:(void (^)(NSObject *, NSError *)) completion;
@end
