//
//  PFUser+ExtendedUser.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/26/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PFUser+ExtendedUser.h"
@implementation PFUser (ExtendedUser)
@dynamic relations;

//-(void)retrieveRelationsWithObjectID:(NSString*)objectId andCompletion: (void (^)(Relations*userRelations))completion{
//    PFQuery *query = [Relations query];
//    [query getObjectInBackgroundWithId:objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
//        Relations *relation = (Relations*)object;
//        completion(relation);
//    }];
//}
//-(void)follow:(PFUser *)user{
//    // Get relations object of current user
//    [user retrieveRelationsWithObjectID:user.relations.objectId andCompletion:^(Relations *userRelations) {
//
//    }];
//}

@end
