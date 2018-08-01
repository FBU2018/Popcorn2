//
//  Post.m
//  Popcorn
//
//  Created by Rucha Patki on 7/30/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic authorId;
@dynamic authorUsername;
@dynamic movieId;
@dynamic createdAt;
@dynamic shelves;
@dynamic postType;
@dynamic authorSessionId;

+ (nonnull NSString *)parseClassName{
    return @"Post";
}

+ (void)postReviewWithUser:(NSString *)authorId ofUsername: (NSString *) username withSession:(NSString *) sessionId andMovie:(NSString *)movieId withCompletion:(PFBooleanResultBlock)completion{
    Post *newPost = [Post new];
    newPost.authorId = authorId;
    newPost.authorUsername = username;
    newPost.movieId = movieId;
    newPost.postType = @"review";
    newPost.authorSessionId = sessionId;
    
    newPost.shelves = [NSMutableArray new];
    
    [newPost saveInBackgroundWithBlock:completion];
}

+ (void)postShelfUpdateWithUser:(NSString *)authorId ofUsername: (NSString *) username withSession: (NSString *) sessionId andMovie:(NSString *)movieId andShelves:(NSMutableArray *)shelves withCompletion:(PFBooleanResultBlock)completion{
    Post *newPost = [Post new];
    newPost.authorId = authorId;
    newPost.authorUsername = username;
    newPost.movieId = movieId;
    newPost.postType = @"shelfUpdate";
    newPost.shelves = shelves;
    newPost.authorSessionId = sessionId;
    
    [newPost saveInBackgroundWithBlock:completion];
}

@end
