//
//  PFUser+ExtendedUser.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/26/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PFUser+ExtendedUser.h"
@implementation PFUser (ExtendedUser)
@dynamic relations, accountId;

// Helper function to retrieve a relations object given its objectid
-(void)retrieveRelationsWithObjectID:(NSString*)objectId andCompletion: (void (^)(Relations*userRelations))completion{
    PFQuery *query = [Relations query];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        Relations *relation = (Relations*)object;
        completion(relation);
    }];
}

// Follow a given user by updating self and passed in user's relation objects
-(void)follow:(PFUser *)user withCompletionBlock:(void (^)(BOOL success))completion{
    // Get relations object of passed in user
    [user retrieveRelationsWithObjectID:user.relations.objectId andCompletion:^(Relations *userRelations) {
        // Add self user's account id to passed in user's followersids array
        NSMutableArray *userArray = [NSMutableArray arrayWithArray:userRelations.myfollowers];
        [userArray addObject:self.username];
        
        // Update passed in user's followersids array and save in background
        userRelations.myfollowers = [userArray copy];
        [userRelations saveInBackground];
        completion(YES);
    }];
    
    // Get relations object of self user
    [self retrieveRelationsWithObjectID:self.relations.objectId andCompletion:^(Relations *userRelations) {
        // Add passed in user's accountid to self's followingids array
        NSMutableArray *selfArray = [NSMutableArray arrayWithArray:userRelations.myfollowings];
        [selfArray addObject:user.username];
        
        // Update self user's followingids array and save in background
        userRelations.myfollowings = [selfArray copy];
        [userRelations saveInBackground];
        completion(YES);
    }];
}

// Unfollow a given user by updating self and passed in user's relation objects
-(void)unfollow: (PFUser *)user withCompletionBlock:(void (^)(BOOL success))completion{
    // Get relations object of passed in user
    [user retrieveRelationsWithObjectID:user.relations.objectId andCompletion:^(Relations *userRelations) {
        // Remove self user's account id from passed in user's followersids array
        NSMutableArray *array = [NSMutableArray arrayWithArray:userRelations.myfollowers];
        [array removeObject:self.username];
        
        // Update passed in user's followersids array and save in background
        userRelations.myfollowers = [array copy];
        [userRelations saveInBackground];
        completion(YES);
    }];
    
    // Get relations object of self user
    [self retrieveRelationsWithObjectID:self.relations.objectId andCompletion:^(Relations *userRelations) {
        // Remove passed in user's accountid from self's followingids array
        NSMutableArray *array = [NSMutableArray arrayWithArray:userRelations.myfollowings];
        [array removeObject:user.username];
        
        // Update self user's followingids array and save in background
        userRelations.myfollowings = [array copy];
        [userRelations saveInBackground];
        completion(YES);
    }];
}

@end
