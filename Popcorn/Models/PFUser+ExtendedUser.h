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
//-(void)retrieveRelationsWithObjectID:(NSString*)objectId andCompletion: (void (^)(Relations *myRelations))completion;
@property (strong, nonatomic) Relations *relations;
@end
