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
@dynamic movieId;
@dynamic createdAt;
@dynamic shelves;

+ (nonnull NSString *)parseClassName{
    return @"Post";
}

+ (void)postUpdateWithUser:(NSString *)authorId andMovie:(NSString *)movieId withCompletion:(PFBooleanResultBlock)completion{
    Post *newPost = [Post new];
    newPost.authorId = authorId;
    newPost.movieId = movieId;
    
    newPost.shelves = [NSMutableArray new];
    
    [newPost saveInBackgroundWithBlock:completion];
}

@end
