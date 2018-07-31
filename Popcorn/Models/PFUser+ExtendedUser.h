//
//  PFUser+ExtendedUser.h
//  Popcorn
//
//  Created by Ernest Omondi on 7/26/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PFUser.h"
#import "Relations.h"

@interface PFUser (ExtendedUser) <PFSubclassing>
// Instance methods
-(void)retrieveRelationsWithObjectID:(NSString*)objectId andCompletion: (void (^)(Relations *userRelations))completion;
-(void)follow:(PFUser *)user withCompletionBlock:(void (^)(BOOL success))completion;
-(void)unfollow:(PFUser *)user withCompletionBlock:(void (^)(BOOL success))completion;

// Class properties
@property (strong, nonatomic) Relations *relations;
@property (strong, nonatomic) NSString *accountId;
@end
