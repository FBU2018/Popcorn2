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

- (void)getShelves:(void(^)(NSDictionary *shelves, NSError *error))completion;
- (void)getShelfMovies: (NSString *) listId completion:(void (^) (NSArray *, NSError *))completion;

@end
